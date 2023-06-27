class ChangePostsCaption < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :caption, :text, :limit => 65535
  end
end
