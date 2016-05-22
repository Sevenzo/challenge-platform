module Sortable
  extend ActiveSupport::Concern

  included do
    scope :order_by, -> (ordering) { unscope(:order).order(ordering) if ordering }
  end

end
