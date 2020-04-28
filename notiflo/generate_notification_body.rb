require_relative 'helpers'
require_relative 'retrieve_speakers'

module Notiflo
  class GenerateNotificationBody
    include Helpers
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def self.run(card)
      new(card).run
    end

    def run
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

    private

    def speakers
      RetrieveSpeakers.run(card)
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
  end
end
