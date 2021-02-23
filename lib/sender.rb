# frozen_string_literal: true
require 'json'
require 'net/http'
require 'uri'

# heavily based on https://github.com/shivamb/opsgenie-gem/blob/master/lib/opsg-api.rb
module OpsGenie
  class Sender
    def initialize(api_key)
      @api_key = api_key
    end

    def send(alert)
      raise 'Alert must be an instance of OpsGenie::Alert!' unless alert.is_a?(OpsGenie::Alert)

      uri = URI('https://api.opsgenie.com/v2/alerts')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      begin
        res = https.post(
          uri.path,
          JSON.generate(alert.to_hash),
          {
            'Authorization': "GenieKey #{@api_key}",
            'Content-Type': 'application/json',
            'User-Agent': "oggem/0.1 (#{RUBY_ENGINE} #{RUBY_VERSION}p#{RUBY_PATCHLEVEL}-rev#{RUBY_REVISION}) #{RUBY_PLATFORM}"
          }
        )

        if res.is_a?(Net::HTTPSuccess)
          return JSON.parse(res.body)
        end

        return false
      rescue
        return false
      end
    end
  end
end