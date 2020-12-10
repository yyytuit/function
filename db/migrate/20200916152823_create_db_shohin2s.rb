class CreateDbShohin2s < ActiveRecord::Migration[5.2]
  def change
    create_table :db_shohin2s do |t|
      t.string :shohin_mei, null: false
      t.string :shohin_bunrui, null: false
      t.integer :hanbai_tanka
      t.integer :shiire_tanka
      t.date :torokubi

      t.timestamps
    end
  end
end
