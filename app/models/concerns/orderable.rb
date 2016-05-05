module Orderable
  extend ActiveSupport::Concern

  included do
    scope :order_by, lambda{ |field|
      if (field)
        # Escape the default_scope's ordering, and order by the field provided
        unscope(:order).order(field)
      end
    }

    default_scope {
      order(featured: :desc, comments_count: :desc, created_at: :desc, id: :desc)
    }
  end

end
