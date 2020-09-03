class CreateSamplemaths < ActiveRecord::Migration[5.2]
  def change
    create_table :samplemaths do |t|
      t.numeric :m
      t.integer :n
      t.integer :p

      t.timestamps
    end
  end
end
