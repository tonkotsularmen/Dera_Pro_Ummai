class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, limit: 30
      t.text :caption, null: false, limit: 150
      t.timestamps
    end
  end
end
