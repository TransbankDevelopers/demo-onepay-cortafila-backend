class TransactionController < ApplicationController
    skip_before_action :verify_authenticity_token
    layout "transaction"

    def create
      cart = Transbank::Onepay::ShoppingCart.new params[:items].as_json
      channel = Transbank::Onepay::Channel::MOBILE
      @transaction_creation_response = Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: channel).to_h

      device = Device.find_by_deviceid(params[:deviceid])
      items = cart.items.as_json.map {|item| Item.new(item)}
      c = ShoppingCart.create(device: device, items: items, ott: @transaction_creation_response["ott"], occ: @transaction_creation_response["occ"], amount: cart.total, external_unique_number: @transaction_creation_response["external_unique_number"])

      BuyTransaction.create(
        status: "Creada",
        response_code: @transaction_creation_response["response_code"],
        description: @transaction_creation_response["description"],
        occ: @transaction_creation_response["occ"],
        ott: @transaction_creation_response["ott"],
        amount: cart.total,
        external_unique_number: @transaction_creation_response["external_unique_number"],
        issuedAt: @transaction_creation_response["issued_at"],
        ShoppingCart_id: c.id
        )

      render json: {
        responseCode: @transaction_creation_response["response_code"],
        description: @transaction_creation_response["description"],
        occ: @transaction_creation_response["occ"],
        ott: @transaction_creation_response["ott"],
        externalUniqueNumber: @transaction_creation_response["external_unique_number"],
        issuedAt: @transaction_creation_response["issued_at"],
        signature: @transaction_creation_response["signature"],
        amount: cart.total
      }

    end

    def endTransaction
      @status = params["status"]
      @occ = params["occ"]
      @external_unique_number = params["externalUniqueNumber"]
      @buy_transaction = BuyTransaction.find_by_occ @occ

      shopping_cart = ShoppingCart.find_by_occ @occ
      device = shopping_cart.device
      @items = shopping_cart.items

      options = { "data": {
                  "occ": @occ,
                  "status": @status,
                  "external_unique_number": @external_unique_number
              }}

      @buy_transaction.update(status: params["status"])

      if (@status == "PRE_AUTHORIZED" || @status == "AUTHORIZED")
        @transaction_commit_response = Transbank::Onepay::Transaction.commit(
        occ: @occ,
        external_unique_number: @external_unique_number
        )

        options[:data][:description] = @transaction_commit_response.description

        @buy_transaction.update(
          status: "Authorized",
          authorizationCode: @transaction_commit_response.authorization_code,
          issuedAt: @transaction_commit_response.issued_at,
          signature: @transaction_commit_response.signature,
          amount: @transaction_commit_response.amount,
          transactionDesc: @transaction_commit_response.transaction_desc,
          installmentsAmount: @transaction_commit_response.installments_amount,
          installmentsNumber: @transaction_commit_response.installments_number,
          buyOrder: @transaction_commit_response.buy_order
          )

        puts "refund_params = { amount: #{@transaction_commit_response.amount},
        occ: #{@transaction_commit_response.occ},
        external_unique_number:#{@external_unique_number},
        authorization_code: #{@transaction_commit_response.authorization_code} }

        @refund_response = Transbank::Onepay::Refund.create(refund_params)
        "
        render :voucher
      else
        render :transaction_error
      end

    rescue Transbank::Onepay::Errors::TransactionCommitError => e
      puts e
      @buy_transaction.update(status: "Error",
        description: e.message)
      render :transaction_error
    ensure
      if device.android?
        fcm = FCM.new(ENV["FCM_TOKEN"])
        response = fcm.send([device.fcmtoken.undump], options) if device.fcmtoken
      elsif device.web?
        push_data_conn = JSON.parse(device.fcmtoken)
        Webpush.payload_send(
          endpoint: push_data_conn["endpoint"],
          message: JSON.generate(options),
          p256dh: push_data_conn["keys"]["p256dh"],
          auth: push_data_conn["keys"]["auth"],
          vapid: {
            subject: "mailto:transbankdevelopers@continuum.cl",
            public_key: ENV["VAPID_PUBLIC_KEY"],
            private_key: ENV["VAPID_PRIVATE_KEY"]
          }
        )
      end
    end
end
