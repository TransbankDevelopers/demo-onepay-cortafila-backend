class TransactionController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        device = Device.find_by_deviceid(params[:deviceid])
        items = params[:items]
        cart = Transbank::Onepay::ShoppingCart.new items

        @transaction_creation_response = Transbank::Onepay::Transaction.create(shopping_cart: cart).to_h

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
end
