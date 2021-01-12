class CreateTenposhohins < ActiveRecord::Migration[5.2]
  def change
    create_table :tenposhohins do |t|
      t.integer :db_shohin_id, null: false
      t.string :code, null: false
      t.string :tenpo_mei, null: false
      t.integer :suryo, null: false

      t.timestamps
    end
  end
end
