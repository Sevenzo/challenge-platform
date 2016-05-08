class Step < ActiveRecord::Base
  default_scope { order('display_order asc, id asc') }

  belongs_to :steppable, polymorphic: true

  validates :description, presence: true

end
