class CreateShohinsums < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
    CREATE VIEW shohinsums(shohin_bunrui,cnt_shohin)
    AS
    SELECT shohin_bunrui, COUNT(*)
    FROM db_shohins
    GROUP BY shohin_bunrui
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW shohinsums
    SQL
  end
end
