class ChangeCommentsComment < ActiveRecord::Migration[6.1]
  def change
    change_column :comments, :comment, :text, :limit => 65535
  end
end
