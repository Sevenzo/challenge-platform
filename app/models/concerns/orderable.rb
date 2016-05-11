module Orderable
  extend ActiveSupport::Concern

  included do
    scope :order_by, lambda{ |ordering_criteria|
      if ordering_criteria.present?
        # Escape the default_scope's ordering, and order by the field provided
        unscope(:order).order(ordering_criteria)
      end
    }

    default_scope { order(featured: :desc, comments_count: :desc, published_at: :desc, id: :desc) }
  end

end
