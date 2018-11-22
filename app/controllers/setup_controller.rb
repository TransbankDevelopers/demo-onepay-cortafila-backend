class SetupController < ApplicationController
    skip_before_action :verify_authenticity_token

    def register
        device = Device.find_or_create_by(deviceid: params[:deviceid]) do |device|
            device.update_attributes(fcmtoken: params[:token])
        end

        device.update(fcmtoken: params[:token])

        render json: { "result": "ok" }
    end
end
