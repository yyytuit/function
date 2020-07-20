class DbShohin < ApplicationRecord

  # 2章メソッド
  def self.select_all
    # 全量検索
    # 通常
    all

    #直書き
    find_by_sql("SELECT  `db_shohins`.* FROM `db_shohins`")

    # selectメソッドを使う書き方
    select('id,shohin_mei,shohin_bunrui,hanbai_tanka,shiire_tanka,torokubi')
  end

  def self.naming
    # selectメソッドを使う書き方
    select('id AS ID, shohin_mei AS 商品名, hanbai_tanka AS 販売単価').as_json
    #直書き
    find_by_sql("SELECT id AS ID, shohin_mei AS 商品名, hanbai_tanka AS 販売単価 FROM `db_shohins`").as_json
  end

  def self.teisu
    a = find_by_sql("SELECT '商品' AS mojiretsu, 38 AS kazu, '2020-01-01' AS hizuke, id, shohin_mei FROM `db_shohins`")
    puts a[0][:shohin_mei]
    puts a[0][:mojiretsu]
    puts a[0][:kazu]
    puts a[0][:hizuke]
  end

  def self.matome
  end
end
