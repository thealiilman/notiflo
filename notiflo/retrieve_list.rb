module Notiflo
  class RetrieveList
    attr_reader :board_id

    def initialize(board_id)
      @board_id = board_id
    end

    def self.run(board_id:)
      new(board_id).run
    end

    def run
      Trello::Board.find(board_id).lists.find do |list|
        list.name == 'L&L Schedule'
      end
    end
  end
end
