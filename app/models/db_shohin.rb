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

  # 3章メソッド
  def self.db_count
    # COUNT: テーブルのレコード数(行数)を教える
    # Railsの書き方
    all.count
    # SQLの直書
    find_by_sql("SELECT COUNT(*) FROM db_shohins").as_json
    # Railsの書き方
    select('shiire_tanka').count
    # SQLの直書
    find_by_sql("SELECT COUNT(shiire_tanka) FROM db_shohins").as_json
  end

  def self.db_sum
    # SUM: テーブルの数値列のデータを合計する
    # Railsの書き方
    all.sum {|h| h[:hanbai_tanka] }
    all.inject(0) {|sum, h| sum + h[:hanbai_tanka]}
    # SQLの直書
    find_by_sql("SELECT SUM(hanbai_tanka) FROM db_shohins").as_json
    # Railsの書き方
    all.sum {|s| s[:shiire_tanka] }
    # SQLの直書
    find_by_sql("SELECT SUM(shiire_tanka) FROM db_shohins").as_json
  end

  def self.db_avg
    # AVG: テーブルの数値列のデータを平均する
    # Railsの書き方
    select('AVG(hanbai_tanka)').as_json
    # SQLの直書
    find_by_sql("SELECT AVG(hanbai_tanka) FROM db_shohins").as_json
    # # Railsの書き方
    select('AVG(shiire_tanka)').as_json
    # # SQLの直書
    find_by_sql("SELECT AVG(shiire_tanka) FROM db_shohins").as_json
  end

  def self.max_min
    # MAX: テーブルの任意の列のデータの最大値を求める
    # MIN: テーブルの任意の列のデータの最小値を求める
    # Railsの書き方
    select('MAX(hanbai_tanka), MIN(shiire_tanka)').as_json
    # SQLの直書
    find_by_sql("SELECT MAX(hanbai_tanka), MIN(shiire_tanka) FROM db_shohins").as_json
    # Railsの書き方
    select('MAX(torokubi), MIN(torokubi)').as_json
    # SQLの直書
    find_by_sql("SELECT MAX(torokubi), MIN(torokubi) FROM db_shohins").as_json
  end

  def self.count_distinct
    # COUNTとDISTINCTと併用
    # Railsの書き方
    select('COUNT(DISTINCT shohin_bunrui)').as_json
    # SQLの直書
    find_by_sql("SELECT COUNT(DISTINCT shohin_bunrui) FROM db_shohins").as_json
  end

  def self.group
    # GROUP BY句で分類ごとにグループに分けることができる。
    # Railsの書き方
    select('shohin_bunrui, COUNT(*)').group('shohin_bunrui').as_json
    # SQLの直書
    find_by_sql("SELECT shohin_bunrui, COUNT(*) FROM db_shohins GROUP BY shohin_bunrui").as_json
    # Railsの書き方
    select('shiire_tanka, COUNT(*)').group('shiire_tanka').as_json
    # SQLの直書
    find_by_sql("SELECT shiire_tanka, COUNT(*) FROM db_shohins GROUP BY shiire_tanka").as_json
  end

  def self.group_where
    # GROUP BY と WHERE句
    # Railsの書き方
    select('shiire_tanka, COUNT(*)').where(shohin_bunrui: '衣服').group('shiire_tanka').as_json
    # 面白ポイント SQLでは普通where句とgroup by句の順番で書かないとエラーになる。
    # 理由はグループで絞ったあとに特定ができないから。ただRailsのgroupメソッドとwhereメソッドを逆に書いたとしても、
    # Railsが勝手に処理をして、正しい順番でSQLを発行してくれる。
    select('shiire_tanka, COUNT(*)').group('shiire_tanka').where(shohin_bunrui: '衣服').as_json
    # SQLの直書
    find_by_sql("SELECT shiire_tanka, COUNT(*) FROM db_shohins WHERE shohin_bunrui = '衣服' GROUP BY shiire_tanka").as_json
    # 下記はエラーになる。
    find_by_sql("SELECT shiire_tanka, COUNT(*) FROM db_shohins GROUP BY shiire_tanka WHERE shohin_bunrui = '衣服'").as_json
  end

  def self.having
    # HAVING句
    # Railsの書き方
    select('shohin_bunrui, COUNT(*)').group('shohin_bunrui').having('COUNT(*) = 2').as_json
    select('shohin_bunrui, AVG(hanbai_tanka)').group('shohin_bunrui').having('AVG(hanbai_tanka) >= 2500').as_json
    # SQLの直書
    find_by_sql("SELECT shohin_bunrui, COUNT(*) FROM db_shohins GROUP BY shohin_bunrui HAVING COUNT(*) = 2").as_json
    find_by_sql("SELECT shohin_bunrui, AVG(hanbai_tanka) FROM db_shohins GROUP BY shohin_bunrui HAVING AVG(hanbai_tanka) >= 2500").as_json
  end

  def self.order_by
    # 昇順と降順
    # Railsの書き方
    all.order(hanbai_tanka: :desc)
    all.order(:hanbai_tanka)
    # SQLの直書
    find_by_sql("SELECT * FROM db_shohins ORDER BY hanbai_tanka DESC").as_json
    find_by_sql("SELECT * FROM db_shohins ORDER BY hanbai_tanka").as_json
  end

  # 4章
  def self.sonyu
    # データの挿入
    # Railsの書き方
    create(shohin_mei: '圧力鍋',shohin_bunrui: 'キッチン用品', hanbai_tanka: 6800)
    # SQLの直書
    # find_by_sql("INSERT INTO db_shohins (shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka, created_at, updated_at) VALUES ('圧力鍋', 'キッチン用品', 6800, 5000, '2020-08-02 04:50:28', '2020-08-02 04:50:28')")
    # 上記は無理だということがわかった。理由はfind_by_sql自体がsqlを実行するメソッドだがレコードを検索のためのメソッドだから。
    # 色々調べると、ActiveRecord::Base.connection.execute(引数)で上手くいくことがわかった。
    # DbShohin.connection.execute("INSERT INTO db_shohins (shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka, created_at, updated_at) VALUES ('ナイフ', 'キッチン用品', 1000, 300, '2020-08-02 05:50:28', '2020-08-02 05:50:28')")
    # ただし面白いポイントとしては、null falseに指定してないtorokubiなどはnilで登録されるが、rails独自のcreated_atやupdated_atはnilが許容されないので、insert文を直接書く場合は絶対に定義しないといけない。
    # 一つのデータを作る場合
    sql = <<-"EOS"
    INSERT INTO db_shohins (shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka, created_at, updated_at) VALUES ('ナイフ', 'キッチン用品', 1000, 300, '2020-08-02 05:50:28', '2020-08-02 05:50:28')
    EOS
    # 複数のデータを作る場合
    sql = <<-"EOS"
    INSERT INTO db_shohins (shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka, created_at, updated_at)
    VALUES ('穴あけパンチ', '事務用品', 500, 320, '2020-08-02 05:50:28', '2020-08-02 05:50:28'),
           ('カッターシャツ', '衣服', 4000, 28000, '2020-08-02 05:50:28', '2020-08-02 05:50:28'),
           ('包丁', 'キッチン用品', 3000, 2800, '2020-08-02 05:50:28', '2020-08-02 05:50:28')
    EOS
    connection.execute(sql)
  end

  def self.table_create
    # テーブルの作成
    # sql = <<-"EOS"
    #   CREATE TABLE ShohinCopy (id int, shohin_mei varchar(255), shohin_bunrui varchar(255), hanbai_tanka int ,shiire_tanka int, torokubi date, created_at datetime, updated_at datetime)
    # EOS
    # ActiveRecord::Base.connection.execute(sql)
    # 上記でもできたが、以下の方が正しいらしい。
    ActiveRecord::Base.connection.create_table "shohin_copys" do |t|
      t.string :shohin_mei
      t.string :shohin_bunrui
      t.integer :hanbai_tanka
      t.integer :shiire_tanka
      t.date :torokubi
      t.timestamps
    end
  end

  def self.create_model(tabale_name)
    # モデルの作成
    klass = Class.new(ActiveRecord::Base) do |c|
      c.table_name = tabale_name
    end
    model_name = table_name.singularize.camelcase
    Object.const_set(model_name, klass)

    # 動的にファイルを作って、起動させたいが、ファイルはできるが上手く動かない
    # model_file = table_name.singularize
    # file = __dir__ + "/" + model_file + ".rb"
    # create_class = "class #{model_name} < ActiveRecord::Base; end"
    # IO.write(file, create_class)
    # model_path = __dir__ + "/" + model_name
    # require_relative model_path
  end

  def self.copy
    # データのコピー
    sql = <<-"EOS"
    INSERT INTO shohin_copys (id , shohin_mei , shohin_bunrui, hanbai_tanka, shiire_tanka, torokubi, created_at, updated_at )
    SELECT id, shohin_mei , shohin_bunrui, hanbai_tanka, shiire_tanka, torokubi, created_at, updated_at from db_shohins
    EOS
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.update_all
    # 全データの更新
    # SQLの直書
    sql = <<-"EOS"
    UPDATE db_shohins
    SET shohin_bunrui = '衣類'
    EOS
    ActiveRecord::Base.connection.execute(sql)

    # Railsの書き方
    all.update_all(shohin_bunrui: 'キッチン用品')
  end

  def self.update_row
    # 列データの更新
    # SQLの直書
    sql = <<-"EOS"
    UPDATE db_shohins
    SET hanbai_tanka = hanbai_tanka * 10
    WHERE shohin_bunrui = 'キッチン用品'
    EOS
    ActiveRecord::Base.connection.execute(sql)

    # Railsの書き方
    where(shohin_bunrui: 'キッチン用品').each do |n|
      n.update(hanbai_tanka: n.hanbai_tanka * 10 )
    end
  end

  def self.update_rows
    # 列データの複数の更新
    # SQLの直書
    sql = <<-"EOS"
    UPDATE db_shohins
    SET hanbai_tanka = hanbai_tanka * 10,
        shiire_tanka = shiire_tanka / 2
    WHERE shohin_bunrui = 'キッチン用品'
    EOS
    ActiveRecord::Base.connection.execute(sql)

    # Railsの書き方
    where(shohin_bunrui: 'キッチン用品').each do |n|
      if n.shiire_tanka
        n.update(hanbai_tanka: n.hanbai_tanka * 10, shiire_tanka: n.shiire_tanka / 2)
      end
    end
    # 当然かもしれないが、each文で回して一つ一つupdate処理しているので時間がかかる。10データぐらいで2場合時間がかかった。5msと10msの違いくらい
  end

  def self.sub_qery
    # SQLの直書
    find_by_sql('SELECT shohin_bunrui, cnt_shohin
                 FROM (SELECT shohin_bunrui, COUNT(*) AS cnt_shohin
                       FROM db_shohins
                       GROUP BY shohin_bunrui)
                 AS shohinsums')

    # Railsの書き方
    # 変数に収納パターン
    sq = select('shohin_bunrui, COUNT(*) AS cnt_shohin')
         .group('shohin_bunrui')
    select('shohin_bunrui, cnt_shohin').from("(#{sq.to_sql}) AS shohinsums")

    # いっぺんに書くパターン
    select('shohin_bunrui, cnt_shohin').from("(#{select('shohin_bunrui, COUNT(*) AS cnt_shohin').group('shohin_bunrui').to_sql}) AS shohinsums")
  end

  def self.sub_qery_nest
    # SQLの直書
    find_by_sql('SELECT shohin_bunrui, cnt_shohin
                 FROM (SELECT *
                        FROM (SELECT shohin_bunrui, COUNT(*) AS cnt_shohin
                              FROM db_shohins
                              GROUP BY shohin_bunrui) AS shohinsum
                        WHERE cnt_shohin < 4)
                 AS shohinsum2')

    # Railsの書き方
    # 変数に収納パターン
    shohinsum = select('shohin_bunrui, COUNT(*) AS cnt_shohin')
                .group('shohin_bunrui')

    shohinsum2 = select('*').from("(#{shohinsum.to_sql}) AS shohinsum").where('cnt_shohin < 4')

    select('shohin_bunrui, cnt_shohin').from("(#{shohinsum2.to_sql}) AS shohinsum2")

    # いっぺんに書くパターン
    select('shohin_bunrui, cnt_shohin')
    .from("(#{select('*')
      .from("(#{select('shohin_bunrui, COUNT(*) AS cnt_shohin')
        .group('shohin_bunrui').to_sql}) AS shohinsum")
      .where('cnt_shohin < 4').to_sql})
    AS shohinsum2")
  end

  def self.scala
    # SQLの直書
    find_by_sql('SELECT shohin_mei, hanbai_tanka
                 FROM db_shohins
                 WHERE hanbai_tanka > (SELECT AVG(hanbai_tanka) FROM db_shohins)')

    # Railsの書き方
    select('shohin_mei, hanbai_tanka').where("hanbai_tanka > (#{DbShohin.select('AVG(hanbai_tanka)').to_sql})")
  end

  def self.scala_having
    # SQLの直書
    find_by_sql('SELECT shohin_bunrui, AVG(hanbai_tanka)
                 FROM db_shohins
                 GROUP BY shohin_bunrui
                 having AVG(hanbai_tanka) > (SELECT AVG(hanbai_tanka) FROM db_shohins)')

    # Railsの書き方
    select('shohin_bunrui, AVG(hanbai_tanka)').group('shohin_bunrui')
    .having("AVG(hanbai_tanka) > (#{DbShohin.select('AVG(hanbai_tanka)').to_sql})")
  end

  def self.correlation
     # SQLの直書
    #  find_by_sql('SELECT shohin_bunrui, shohin_mei, hanbai_tanka
    #  FROM db_shohins AS s1
    #  WHERE hanbai_tanka > (SELECT AVG(hanbai_tanka)
    #  FROM db_shohins AS s2
    #  WHERE s1.shohin_bunrui = s2.shohin_bunrui
    #  GROUP BY shohin_bunrui)')

     # Railsの書き方
    #  sel = DbShohin.select('shohin_bunrui, shohin_mei, hanbai_tanka').from('db_shohins AS s1')
    #  grp = DbShohin.select('AVG(hanbai_tanka)').group('shohin_bunrui')
     select('shohin_bunrui, shohin_mei, hanbai_tanka').from('db_shohins AS s1')
     .where("hanbai_tanka > #{DbShohin.select('AVG(hanbai_tanka)').from('db_shohins AS s2')
     .where('s1.shohin_bunrui = s2.shohin_bunrui').group('shohin_bunrui').to_sql}")
  end

  def self.between
    # sqlの直書き
    find_by_sql("SELECT id, shohin_mei, hanbai_tanka FROM db_shohins WHERE hanbai_tanka BETWEEN 100 AND 1000")
    # railsの書き方
    select('id, shohin_mei, hanbai_tanka').where(hanbai_tanka: 100..1000)
  end

  def self.not_between
    # sqlの直書き
    find_by_sql("SELECT id, shohin_mei, hanbai_tanka FROM db_shohins WHERE hanbai_tanka > 100 AND hanbai_tanka < 1000")
    # railsの書き方
    select('id, shohin_mei, hanbai_tanka').where('hanbai_tanka > 100 AND hanbai_tanka < 1000')
  end

  def self.is_null
    # sqlの直書き
    find_by_sql('SELECT id, shohin_mei, shiire_tanka FROM db_shohins WHERE shiire_tanka IS NULL')
    # railsの書き方
    select('id, shohin_mei, shiire_tanka').where(shiire_tanka: nil)
  end

  def self.is_not_null
    # sqlの直書き
    find_by_sql('SELECT id, shohin_mei, shiire_tanka FROM db_shohins WHERE shiire_tanka IS NOT NULL')
    # railsの書き方
    select('id, shohin_mei, shiire_tanka').where.not(shiire_tanka: nil)
  end

  def self.in
    # sqlの直書き
    find_by_sql('SELECT id, shohin_mei, shiire_tanka FROM db_shohins WHERE shiire_tanka IN (320, 500, 5000)')
    # railsの書き方
    select('id, shohin_mei, shiire_tanka').where(shiire_tanka: [320, 500, 5000])
  end

  def self.in_sub
    # sqlの直書き
    find_by_sql("SELECT shohin_mei, hanbai_tanka FROM db_shohins WHERE id IN (SELECT shohin_id FROM tenposhohins WHERE code = '000C')")
    # railsの書き方
    select('shohin_mei,hanbai_tanka').where(id: Tenposhohin.select(:shohin_id).where(code: '000C'))
  end

  def self.exist
    # sqlの直書き
    find_by_sql("SELECT shohin_mei, hanbai_tanka FROM db_shohins AS s WHERE EXISTS (SELECT * FROM tenposhohins AS ts WHERE ts.code = '000C' AND ts.shohin_id = s.id)")
    # railsの書き方
    # railsにexist?関数はあるが、上記のようにサブクエリを使った存在確認はできない
  end

  def self.when
    # sqlの直書き
    find_by_sql("select shohin_mei,
      case when shohin_bunrui = '衣服' then CONCAT('A:', shohin_bunrui)
           when shohin_bunrui = '事務用品' then CONCAT('B:', shohin_bunrui)
           when shohin_bunrui = 'キッチン用品' then CONCAT('C:', shohin_bunrui)
           else null
           end as abc_shohin_bunrui
       from db_shohins")
    # rubyの書き方
    # all.each do |n|
    #   case
    #   when n.shohin_bunrui == '衣服' then p where(id: n.id).select("shohin_mei, CONCAT('A:','#{n.shohin_bunrui}') AS abc_shohin_bunrui")
    #   when n.shohin_bunrui == '事務用品' then p where(id: n.id).select("shohin_mei, CONCAT('B:','#{n.shohin_bunrui}') AS abc_shohin_bunrui")
    #   when n.shohin_bunrui == 'キッチン用品' then p where(id: n.id).select("shohin_mei, CONCAT('C:','#{n.shohin_bunrui}') AS abc_shohin_bunrui")
    #   else
    #   end
    # end

    all.each do |n|
      case
      when n.shohin_bunrui == '衣服' then p n.shohin_mei + '|' + 'A:' + n.shohin_bunrui
      when n.shohin_bunrui == '事務用品' then p n.shohin_mei + '|' + 'B:' + n.shohin_bunrui
      when n.shohin_bunrui == 'キッチン用品' then p n.shohin_mei + '|' + 'C:' + n.shohin_bunrui
      else
      end
    end
  end

  def union
    # sqlの直書き
    find_by_sql('SELECT id, shohin_mei FROM db_shohins UNION SELECT id, shohin_mei FROM db_shohin2s')
    # Railsの書き方
    # part1和集合
    union = DbShohin.select('id, shohin_mei').arel.union(DbShohin2.select('id, shohin_mei').arel).to_sql
     # part2whereで絞り込んだ和集合
    union = DbShohin.select('id, shohin_mei').where('shohin_bunrui =?','キッチン用品').arel.union(DbShohin2.select('id, shohin_mei').where('shohin_bunrui =?','キッチン用品').arel).to_sql
    # 上記で "( SELECT id, shohin_mei FROM `db_shohins` UNION SELECT id, shohin_mei FROM `db_shohin2s` )"な文字列が生成される
    DbShohin.from("#{union} db_shohins")
  end

  def union_all
    # sqlの直書き
    find_by_sql('SELECT id, shohin_mei FROM db_shohins UNION ALL SELECT id, shohin_mei FROM db_shohin2s')
    # Railsの書き方
    union = Arel::Nodes::UnionAll.new(DbShohin.select('id, shohin_mei').arel.ast,DbShohin2.select('id, shohin_mei').arel.ast).to_sql
    # 上記で"( SELECT id, shohin_mei FROM `db_shohins` UNION ALL SELECT id, shohin_mei FROM `db_shohin2s` )"な文字列が生成される
    DbShohin.from("#{union} db_shohins")
  end

  def intersect
    # mysqlにはintersectはない。inner joinを使う
    # sqlの直書き
    # Railsの書き方
  end
end

