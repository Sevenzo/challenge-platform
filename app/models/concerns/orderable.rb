module Orderable
  extend ActiveSupport::Concern

  included do
    scope :latest, -> {
      # Escape the default_scope
      unscoped.order(created_at: :desc)
    }

    default_scope {
      order(featured: :desc, comments_count: :desc, created_at: :desc, id: :desc)
    }
  end

end
