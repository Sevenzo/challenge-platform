module Orderable
  extend ActiveSupport::Concern

  included do
    default_scope { order(featured: :desc, comments_count: :desc, published_at: :desc, id: :desc) }
  end

end
