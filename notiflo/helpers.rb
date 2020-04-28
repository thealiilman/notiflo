module Notiflo
  module Helpers
    def label
      card.labels.first&.name
    end
  end
end
