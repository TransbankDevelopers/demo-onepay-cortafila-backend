class TransactionController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        device = Device.find_by_deviceid(params[:deviceid])
        items = params[:items].as_json.map {|item| Item.new(item)}

        cart = Transbank::Onepay::ShoppingCart.new params[:items].as_json

        channel = Transbank::Onepay::Channel::MOBILE

        @transaction_creation_response = Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: channel).to_h

        ShoppingCart.create(device: device, items: items, ott: @transaction_creation_response["ott"], occ: @transaction_creation_response["occ"], amount: cart.total, external_unique_number: @transaction_creation_response["external_unique_number"])

        logger.info "Cart total: #{cart.total}"
        
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
        device = (ShoppingCart.find_by_occ @occ).device
        registration_ids = [device.fcmtoken] 

        fcm = FCM.new("AAAAiDT4oJE:APA91bFLVt--Dr_nAhZ_ZqgGJnfqbQXXrj_uRwbWlLFlrwtsJto1u_X9mcQUIQWdFXvGrPq3kxEJNaF3MkZFQThQRTQr6twv45S-XkEKnxSa41oZIrx3YINT0_GQ8Q9At9X-DwWt2TUF")

        options = { "data": {
                    "occ": @occ,
                    "status": @status,
                    "external_unique_number": @external_unique_number
                }}
        response = fcm.send(registration_ids, options)

        begin
            if @status == "PRE_AUTHORIZED"
                @transaction_commit_response = Transbank::Onepay::Transaction.commit(
                occ: @occ,
                external_unique_number: @external_unique_number
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
            render :transaction_error
        end
    end
end
