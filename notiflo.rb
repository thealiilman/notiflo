require 'trello'
require 'httparty'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

class Notiflo
  class << self
    def send_lunch_and_learn_notification
      new.send_lunch_and_learn_notification
    end
  end

  def send_lunch_and_learn_notification
    HTTParty.post(
      ENV['SLACK_WEBHOOK_URL'],
      body: body,
      headers: headers
    )
  end

  private

  def body
    {
      blocks: [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "Our next *L&L* session is on the #{card.name}!\nThese are our speaker(s)."
          }
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: card.members.map(&:full_name).join("\n")
          }
        }
      ]
    }.to_json
  end

  def headers
    {
      'Content-Type' => 'application/json'
    }
  end

  def card
    @card ||= list.cards.find do |card|
      year = Date.current.year
      day, month = card.name.split('/').map(&:to_i)
      lunch_and_learn_date = Date.new(Date.current.year, month, day)

      Date.current < lunch_and_learn_date
    end
  end

  def list
    @list ||= Trello::Board
      .find('0nSn14cA').lists.find { |list| list.name == 'L&L Schedule' }
  end
end

def lambda_handler(event:, context:)
  Notiflo.send_lunch_and_learn_notification
end
