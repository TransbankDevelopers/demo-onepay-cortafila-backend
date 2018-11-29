class TransactionController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        device = Device.find_by_deviceid(params[:deviceid])
        items = params[:items]

        cart = Transbank::Onepay::ShoppingCart.new items.as_json

        channel = Transbank::Onepay::Channel::MOBILE

        @transaction_creation_response = Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: channel).to_h

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

    def commit
        if params["status"] == "PRE_AUTHORIZED"
            response = Transbank::Onepay::Transaction.commit(
              occ: params["occ"],
              external_unique_number: params["external_unique_number"]
            )

            p res.authorization_code
            # Procesar response
          
          else
            # Mostrar página de error
          end
          
          rescue Transbank::Onepay::Errors::TransactionCommitError => e
            # Manejar el error de confirmación de transacción
    end

    def voucher

    end
end
