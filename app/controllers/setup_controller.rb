class SetupController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def register
        render json: { "result": "ok" }
    end
end
