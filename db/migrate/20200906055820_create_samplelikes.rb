class CreateSamplelikes < ActiveRecord::Migration[5.2]
  def change
    create_table :samplelikes do |t|
      t.string :strcol, null: false

      t.timestamps
    end
  end
end
