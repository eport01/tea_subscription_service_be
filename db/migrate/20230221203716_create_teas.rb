class CreateTeas < ActiveRecord::Migration[5.2]
  def change
    create_table :teas do |t|
      t.string :title
      t.integer :temperature
      t.string :brew_time

      t.timestamps
    end
  end
end
