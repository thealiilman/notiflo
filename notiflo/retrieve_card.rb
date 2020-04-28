require_relative 'retrieve_list'

module Notiflo
  class RetrieveCard
    def self.run
      new.run
    end

    def run
      list.cards.find do |card|
        year, month, day = card.name.split('-').map(&:to_i)
        lunch_and_learn_date = Date.new(year, month, day)
  
        Date.current < lunch_and_learn_date
      end
    end

    private

    def list
      RetrieveList.run(board_id: ENV['TRELLO_BOARD_ID'])
    end
  end
end
