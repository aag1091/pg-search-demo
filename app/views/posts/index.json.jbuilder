json.array!(@posts) do |post|
  json.extract! post, :id, :title, :short_description, :content, :category_id, :author_id
  json.url post_url(post, format: :json)
end
