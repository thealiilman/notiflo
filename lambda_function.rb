require 'trello'
require 'httparty'
require_relative 'notiflo/send_notification'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

def lambda_handler(event:, context:)
  Notiflo::SendNotification.run
end
