class CreateFunctionAndTriggerForFillingSearchVectorOfPosts < ActiveRecord::Migration
  
  def up
    execute <<-EOS
      CREATE OR REPLACE FUNCTION fill_search_vector_for_post() RETURNS trigger LANGUAGE plpgsql AS $$
      declare
        post_author record;
        post_tags record;
        post_category record;

      begin
        select first_name, last_name into post_author from authors where id = new.author_id;
        select string_agg(tags.name, ' ') as names into post_tags from tags joins INNER JOIN taggings ON taggings.taggable_id = new.id AND (taggings.context = ('tags')) AND taggings.taggable_type = 'Post' INNER JOIN tags ON tags.id = taggings.tag_id;
        select name into post_category from categories where id = new.category_id;
        new.search_vector :=
          setweight(to_tsvector('pg_catalog.english', coalesce(new.title, '')), 'A')                  ||
          setweight(to_tsvector('pg_catalog.english', coalesce(new.content, '')), 'B')                ||
          setweight(to_tsvector('pg_catalog.english', coalesce(new.short_description, '')), 'B')                ||
          setweight(to_tsvector('pg_catalog.english', coalesce(post_author.first_name, '')), 'B')        ||
          setweight(to_tsvector('pg_catalog.english', coalesce(post_author.last_name, '')), 'B')        ||
          setweight(to_tsvector('pg_catalog.english', coalesce(post_category.name, '')), 'B');
 
        return new;
      end
      $$;
    EOS

    execute <<-EOS
      CREATE TRIGGER posts_search_content_trigger BEFORE INSERT OR UPDATE
        ON posts FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_post();
    EOS

    Post.find_each(&:touch)
  end

  def down
    execute <<-EOS
      DROP FUNCTION fill_search_vector_for_acticle();
      DROP TRIGGER posts_search_content_trigger ON posts;
    EOS
  end

end