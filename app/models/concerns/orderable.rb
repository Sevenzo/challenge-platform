module Orderable
  extend ActiveSupport::Concern

  included do
    scope :order_by, -> (ordering) { unscope(:order).order(ordering) if ordering }
    default_scope { order(featured: :desc, comments_count: :desc, published_at: :desc, id: :desc) }
  end

end
