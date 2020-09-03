class CreateSamplestrs < ActiveRecord::Migration[5.2]
  def change
    create_table :samplestrs do |t|
      t.string :str1, limit: 40
      t.string :str2, limit: 40
      t.string :str3, limit: 40

      t.timestamps
    end
  end
end
