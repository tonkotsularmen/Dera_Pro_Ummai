class ChangeUsersGoalIntroduction < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :goal, :text, :limit => 65535
    change_column :users, :introduction, :text, :limit => 65535
  end
end
