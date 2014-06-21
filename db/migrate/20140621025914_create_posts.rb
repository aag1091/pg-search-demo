class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :short_description
      t.text :content
      t.references :category, index: true
      t.references :author, index: true

      t.timestamps
    end
  end
end
