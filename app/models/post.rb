class Post < ActiveRecord::Base

  belongs_to :category
  belongs_to :author

  acts_as_taggable

end
