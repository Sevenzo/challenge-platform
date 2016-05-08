module Likeable
  extend ActiveSupport::Concern

  def default_like
    DEFAULT_LIKE
  end

end
