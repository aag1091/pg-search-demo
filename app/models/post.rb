class Post < ActiveRecord::Base

  include PgSearch

  belongs_to :category
  belongs_to :author

  acts_as_taggable

  # pg_search_scope :search, :against => [ :title, :short_description, :content]

  # pg_search_scope :search, 
  #   :against => [ :title, :short_description, :content],
  #   :associated_against => {
  #     :category => [:name],
  #     :tags => [:name],
  #     :author => [:first_name, :last_name]
  #   }

  # pg_search_scope :search,
  #   against: :search_vector,
  #   using: {
  #     tsearch: {
  #       dictionary: 'english',
  #       any_word: true,
  #       prefix: true,
  #       tsvector_column: 'search_vector'
  #     }
  #   }

end
