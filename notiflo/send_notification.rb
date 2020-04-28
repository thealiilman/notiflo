require_relative 'generate_notification_body'
require_relative 'retrieve_card'

module Notiflo
  class SendNotification
    def self.run
      new.run
    end

    def run
      HTTParty.post(
        ENV['SLACK_WEBHOOK_URL'],
        body: GenerateNotificationBody.run(card),
        headers: headers
      )
    end

    private

    def card
      RetrieveCard.run
    end

    def headers
      {
        'Content-Type' => 'application/json'
      }
    end
  end
end
