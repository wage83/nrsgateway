require 'global_phone'
require 'net/https'

module NrsGateway 

  APIUri = URI.parse("https://gateway.nrsgateway.com/send.php")

  class << self

    @@login = ""
    @@password = ""
    @@from = ""

    def login=(username)
      @@login = username
    end

    def password=(secret)
      @@password = secret
    end

    def from=(sender)
      @@from = sender
    end

    # Send a petition to NrsGateway 
    # 
    # Example:
    #   >> NrsGateway.send_sms(:login => "login",
    #                          :password => "password", 
    #                          :from => "Sender",
    #                          :destination => "34600000001" || ["34600000001", "34600000002"],
    #                          :message => "Message with 160 chars maximum")
    def send_sms(options = {})
      # Check for login
      login = options[:login] || @@login
      raise ArgumentError, "Login must be present" unless login and not (login.strip.size == 0)

      # Check for password
      password = options[:password] || @@password
      raise ArgumentError, "Password must be present" unless password and not (password.strip.size == 0)

      from = options[:from] || @@from
      raise ArgumentError, "Sender length 11 characters maximum" if (from.size > 11)

      # Multiple destinations support
      options[:destination] = [options[:destination]] unless options[:destination].kind_of?(Array)

      destinations = []
      options[:destination].each do |phone|
        raise ArgumentError, "Recipient must be a telephone number with international format: #{phone.to_s}" unless parsed = GlobalPhone.parse(phone.to_s)
        destinations << parsed.international_string.gsub("+", "") # Remove + from international string
      end

      message = options[:message].to_s
      raise ArgumentError, "Message must be present" if message.nil? or (message.strip.size == 0)
      raise ArgumentError, "Message is 160 chars maximum" if message.size > 160

      uri = APIUri.dup
      params = { 'username' => login,
                 'password' => password,
                 'from' => from,
                 'to' => destinations.join(" "),
                 'text' => message,
                 'coding' => "0",
                 'trsec' => "1"}
      uri.query = URI.escape(params.map{ |k,v| "#{k}=#{v}" }.compact.join('&'))
      https = Net::HTTP.new(APIUri.host, APIUri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Get.new(uri.request_uri)

      response = https.start { |cx| cx.request(req) }
      if response.code == "200"
        begin
          match = response.body.match(/(\d+):\s((\s|\w)+)(\.\sID\s(\d+))?/i)
          if match
            result = {:code => match[1].to_i, :description => match[2], :id => match[5]}
          else
            result = {:code => response.body, :description => "Unknown error"}
          end
        rescue
          # Try to get petition result
          result = {:code => response.body}
        end
        return result
      else
        raise RuntimeError, "Server responded with code #{response.code}: #{response.body}"
      end
    end

  end
end
