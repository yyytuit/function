class DbShohin < ApplicationRecord

  # 2章メソッド
  def self.select_all
    # 全量検索
    # 通常
    all

    # 直書き
    find_by_sql("SELECT  `db_shohins`.* FROM `db_shohins`")

    # selectメソッドを使う書き方
    select('id,shohin_mei,shohin_bunrui,hanbai_tanka,shiire_tanka,torokubi')
  end

  def self.naming
    # selectメソッドを使う書き方
    select('id AS ID, shohin_mei AS 商品名, hanbai_tanka AS 販売単価').as_json
    # 直書き
    find_by_sql("SELECT id AS ID, shohin_mei AS 商品名, hanbai_tanka AS 販売単価 FROM `db_shohins`").as_json
  end

  def self.teisu
    # 定数の出力
    a = find_by_sql("SELECT '商品' AS mojiretsu, 38 AS kazu, '2020-01-01' AS hizuke, id, shohin_mei FROM `db_shohins`")
    puts a[0][:shohin_mei]
    puts a[0][:mojiretsu]
    puts a[0][:kazu]
    puts a[0][:hizuke]
  end

  def self.matome
    # 重複データのまとめ distinct
    # Railsのdistinctメソッドを使う書き方
    select('shohin_bunrui').distinct
    # SQLの直書
    find_by_sql('SELECT DISTINCT shohin_bunrui FROM `db_shohins`')
  end

  def self.some_matome
    # 複数の重複データのまとめ
    # Railsの書き方
    select('shohin_bunrui, torokubi').distinct
    # SQLの直書
    find_by_sql('SELECT DISTINCT shohin_bunrui, torokubi FROM `db_shohins`')
  end

  def self.search
    # where句でレコードを条件で選択
    # Railsの書き方
    select('shohin_mei, shohin_bunrui').where(shohin_bunrui: '衣服')
    # SQLの直書
    find_by_sql("SELECT shohin_mei, shohin_bunrui FROM `db_shohins` WHERE shohin_bunrui = '衣服'")
  end

  def self.calculation
    # 算術演算
    # Railsの書き方
    select('shohin_mei, hanbai_tanka, hanbai_tanka * 2 AS hanbai_tanka_x2').as_json
    # SQLの直書
    find_by_sql("SELECT shohin_mei, hanbai_tanka, hanbai_tanka * 2 AS hanbai_tanka_x2 FROM db_shohins").as_json
  end

  def self.hikaku
    # 比較演算
    # Railsの書き方
    select('shohin_mei, shohin_bunrui, hanbai_tanka').where.not(hanbai_tanka: 1000).as_json
    # SQLの直書
    find_by_sql("SELECT shohin_mei, shohin_bunrui, hanbai_tanka FROM db_shohins  WHERE hanbai_tanka <> 1000").as_json
  end

  def self.where_kesan
    # WHERE区の条件式に計算式を書く
    # Railsの書き方
    select('shohin_mei, hanbai_tanka, shiire_tanka').where("hanbai_tanka - shiire_tanka >= 500").as_json
    # SQLの直書
    find_by_sql("SELECT shohin_mei, hanbai_tanka, shiire_tanka FROM db_shohins  WHERE hanbai_tanka - shiire_tanka >= 500").as_json
  end

  def self.nil
    # WHERE区の条件式に計算式を書く
    # SQLの直書
    # find_by_sql("SELECT * FROM db_shohins  WHERE shiire_tanka = nil").as_json

    # = nilは上手く行かないので、IS NULLをつかう
    # Railsの書き方
    where.(shiire_tanka: nil).as_json
    # SQLの直書
    find_by_sql("SELECT * FROM db_shohins  WHERE shiire_tanka IS NULL").as_json
  end

  def self.not_nil
    # Railsの書き方
    where.not(shiire_tanka: nil).as_json
    # SQLの直書
    find_by_sql("SELECT * FROM db_shohins  WHERE shiire_tanka IS NOT NULL").as_json
  end

  def self.and_or
    # AND演算子とOR演算子
    # AND
    # Railsの書き方
    where("shohin_bunrui =? AND hanbai_tanka >=? ", 'キッチン用品', 3000).as_json
    where(shohin_bunrui: 'キッチン用品').where("hanbai_tanka >= 3000").as_json
    # SQLの直書
    find_by_sql("SELECT * FROM db_shohins  WHERE shohin_bunrui = 'キッチン用品' AND hanbai_tanka >=3000").as_json
    # OR
    # Railsの書き方
    DbShohin.where("shohin_bunrui =? OR hanbai_tanka >=? ", 'キッチン用品', 3000).as_json
    DbShohin.where("shohin_bunrui = 'キッチン用品'").or(DbShohin.where("hanbai_tanka >= 3000")).as_json
    # # SQLの直書
    find_by_sql("SELECT * FROM db_shohins  WHERE shohin_bunrui = 'キッチン用品' OR hanbai_tanka >=3000").as_json
  end
end
