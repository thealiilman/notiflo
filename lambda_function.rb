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
    if card && this_week?
      {
        blocks: [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: 'Our next *L&L* session is happening this coming Friday!'
            }
          },
          {
            type: 'image',
            title: {
              type: 'plain_text',
              text: 'the-office-its-happening',
              emoji: true
            },
            image_url: 'https://media0.giphy.com/media/14fnBD3MQslIGc/giphy.gif?cid=790b7611b51e6d4ea51f81296500cd041dedd08eb975fe89&rid=giphy.gif',
            alt_text: 'the-office-its-happening'
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: agenda
            }
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: speakers
            }
          }
        ]
      }.to_json
    elsif card && !this_week?
      {
        blocks: [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "Our next *L&L* session is on the #{card.name}!\n#{agenda}"
            }
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: speakers
            }
          }
        ]
      }.to_json
    else
      {
        blocks: [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "We don't have any upcoming L&Ls."
            }
          }
        ]
      }.to_json
    end
  end

  def headers
    {
      'Content-Type' => 'application/json'
    }
  end

  def agenda
    if label != 'Project Demos'
      'These are our speakers.'
    else
      'We will be having a demo of the following projects.'
    end
  end

  def this_week?
    year, month, day = card.name.split('-').map(&:to_i)
    lunch_and_learn_date = Date.new(year, month, day)

    (lunch_and_learn_date - Date.current).to_i <= 7
  end

  def speakers
    if card.members.any?
      card.members.map(&:full_name).join("\n")
    elsif label == 'Project Demos'
      checklist = card.checklists.find { |cl| cl.name == 'Projects' }
      checklist.check_items.map { |cl| cl['name'].split('-').first }.join("\n")
    elsif (checklist = card.checklists.find { |cl| cl.name == 'Speakers' })
      checklist.check_items.map { |item| item['name'] }.join("\n")
    else
      '_TBA_'
    end
  end

  def label
    card.labels.first&.name
  end

  def card
    @card ||= list.cards.last(5).find do |card|
      year, month, day = card.name.split('-').map(&:to_i)
      lunch_and_learn_date = Date.new(year, month, day)

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
