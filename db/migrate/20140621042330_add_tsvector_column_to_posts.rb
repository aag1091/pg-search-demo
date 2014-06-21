class AddTsvectorColumnToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :search_vector, :tsvector

    execute <<-EOS
      CREATE INDEX posts_search_vector_idx ON posts USING gin(search_vector);
    EOS
  end

  def down
    remove_column :posts, :search_vector
  end
end
