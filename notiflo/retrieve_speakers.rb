require_relative 'helpers'

module Notiflo
  class RetrieveSpeakers
    include Helpers
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def self.run(card)
      new(card).run
    end

    def run
      if card.members.any?
        card.members.map(&:full_name).join("\n")
      elsif label == 'Project Demos'
        checklist = card.checklists.find do |checklist|
          checklist.name == 'Projects'
        end

        checklist.check_items.map do |check_item|
          check_item['name'].split('-').first
        end.join("\n")
      elsif (checklist = card.checklists.find { |cl| cl.name == 'Speakers' })
        checklist.check_items.map { |check_item| check_item['name'] }.join("\n")
      else
        '_TBA_'
      end
    end
  end
end
