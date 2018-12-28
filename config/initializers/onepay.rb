Transbank::Onepay::Base.callback_url = "#{ENV["BASE_DOMAIN"] || "https://cortafilas-onepay.herokuapp.com"}/transaction/endTransaction"
Transbank::Onepay::Base.api_key = ENV["API_KEY"]
Transbank::Onepay::Base.shared_secret = ENV["SHARED_SECRET"]

Transbank::Onepay::Base.integration_type = :LIVE if ENV["API_KEY"]
