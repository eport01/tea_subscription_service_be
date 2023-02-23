class ChangeDefaultStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :subscriptions , :status, "Active" 
  end
end
