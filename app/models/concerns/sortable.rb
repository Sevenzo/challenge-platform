module Sortable
  extend ActiveSupport::Concern

  included do
    scope :order_by, -> (ordering) { reorder(ordering) if ordering }
  end

end
