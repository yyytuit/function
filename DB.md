# ゼロから始めるデータベース操作を Rails を使って再現する。

## なぜやろうと思ったのか？

- DB の勉強はしたあと、ログに出てくる SQL を見てこのデータは正しそうとか、正しくなさそうとういうのはすごくわかった。

  ただ、「ゼロから始めるデータベース操作」の本を読んだけど、正直サブクエリとかは実際に SQL のコードを書かないかぎり Rails では使わない。

  また、どうしても直接 SQL で書きたいときに、Rails で SQL を直書きする方法が今一分かっていない。

  なので、本書の内容を実際に Rails で直書きすることで再現してみようと思った。

# 環境

- MySQL

  本書は PostgreSQL だが、Rails でのセットアップが面倒なのと、本書には MySQL での書き方が書かれているので、MySQL を使用した。

# 準備

## 1.model の作成

- DbShohin モデルを作成。(このリポジトリでは他にもいくつか機能をつくりたいので、あえて Db という接頭語をつけた)

## 2.サンプル作成

- 以後様々な function を作る際に書くサンプルを実装すると考え、seed ファイルを分割した。

1. touch lib/tasks/seed.rake で rake ファイルを作成

   ```
   Dir.glob(File.join(Rails.root, 'db', 'seeds', '*.rb')).each do |file|
     desc "Load the seed data from db/seeds/#{File.basename(file)}."
     task "db:seed:#{File.basename(file).gsub(/\..+$/, '')}" => :environment do
       load(file)
     end
   end
   ```

1. db/seeds/db_shohin.rb ファイルの作成

1. seeds.rb に require './db/seeds/実行したい seed ファイル名.rb'

   上記で rails db:seed コマンドを打つと seed が作成される。

   また、各 seed ごとにファイルを実行する場合は bundle exec rake db:seed:db_shohin などになる

   また seed を入れ直す場合は rails db:migrate:reset db:seed を参考にする。

1. 1 章完了

# 2 章検索の基本

- 参考

  [Active Record クエリインターフェイス](https://railsguides.jp/active_record_querying.html)

  [直書き](https://qiita.com/natsuokawai/items/7bc330e9a6f6f4ef0359)

  [ActiveRecord 入門](https://qiita.com/tfrcm/items/80625a75959591c2b7cd)

  [AS 句を使う書き方](https://qiita.com/k-shimoji/items/7d71b3d5aa5892700b6c)

  [テーブルの挿入](https://madogiwa0124.hatenablog.com/entry/2017/08/28/000127)

  [テーブルの作成(動的 1)](http://tech.feedforce.jp/modelless-table-on-rails.html)

  [テーブルの作成(動的 2)](http://tech.feedforce.jp/modelless-table-on-rails.html)

  [RDBMS の VIEW を使って Rails のデータアクセスをいい感じにする](https://techracho.bpsinc.jp/morimorihoge/2019_06_21/76521)

  - 以下は view を作る際に参考にした。

  [DB の View を作ったら Rails プログラムが綺麗になった話](http://319ring.net/blog/archives/2892/)

  [【Ruby on Rails】change と up・down の使い分けについて](https://qiita.com/tkr_ld/items/f1c0b3bad6a49bd7894a)

  [Rails で MySQL VIEW を使うには?](https://qiita.com/skyriser/items/6503a9f245a26a46dc6d)

- サブクエリで参考にした。

  [ActiveRecord を使って FROM 句のサブクエリを書く方法](https://qiita.com/Y_uuu/items/558d4a2b8017ef8e2780)

# VIEW 作成の手順

1. まず view を定義する為にマイグレーションファイルの作成

   ```
   $ rails g migration CreateShohinsum
   ```

1. 次に migration ファイルの定義

   ```db/migrate/20200815114613_create_shohinsum.rb
    class CreateShohinsum < ActiveRecord::Migration[5.2]
      def up
        execute <<-SQL
        CREATE VIEW shohinsum(shohin_bunrui,cnt_shohin)
        AS
        SELECT shohin_bunrui, COUNT(*)
        FROM db_shohins
        GROUP BY shohin_bunrui
        SQL
      end

      def down
        execute <<-SQL
          DROP VIEW shohinsum
        SQL
      end
    end
   ```

1. 次に view を作成する

   ```
   $ rake db:migrate
   ```

1. これで view が完成。実際に rais dbconsole でコマンドを叩いてみる

   ```sql
   mysql> select shohin_bunrui,cnt_shohin
   -> from shohinsum;
     +--------------------+------------+
     | shohin_bunrui      | cnt_shohin |
     +--------------------+------------+
     | キッチン用品       |          4 |
     | 事務用品           |          2 |
     | 衣服               |          2 |
     +--------------------+------------+
     3 rows in set (0.00 sec)
   ```

1. ただしスキーマには表示されていない。

# view から view の生成

1. rails g migration CreateShohinsumjim

1. マイグレーションファイルの定義

   ```db/migrate/20200815124407_create_shohinsumjim.rb
   class CreateShohinsumjim < ActiveRecord::Migration[5.2]
     def up
       execute <<-SQL
       CREATE VIEW shohinsumjim(shohin_bunrui, cnt_shohin)
       AS
       SELECT shohin_bunrui, cnt_shohin
       FROM shohinsum
       WHERE shohin_bunrui = '事務用品';
       SQL
     end

     def down
      execute <<-SQL
        DROP VIEW shohinsumjim cascade
      SQL
     end
   end
   ```

   上記のように多段ビューを Drop する場合は cascade をつける

1. rake db:migrate

1. これで view が完成。実際に rais dbconsole でコマンドを叩いてみる

   ```mysql
   select shohin_bunrui, cnt_shohin
    -> from shohinsumjim;
    +---------------+------------+
    | shohin_bunrui | cnt_shohin |
    +---------------+------------+
    | 事務用品      |          2 |
    +---------------+------------+
    1 row in set (0.00 sec)
   ```

# ビューの更新

FROM 句に複数テーブルある場合や、集約されたものはビューでは更新ができない

```sql
insert into shohinsum values ('電化製品', 5);
ERROR 1471 (HY000): The target table shohinsum of the INSERT is not insertable-into
```

集約なしのビューであれば更新できるので、集約なしのビューを作成し、更新する。

1. rails g migration CreateShohinjim

1. マイグレーションファイルの定義
   ちなみに sql を直接書いてテーブルを作成しているので、id や cteated_at, updated_at も定義する必要がある。

   ```db/migrate/20200815130758_create_shohinjim.rb
   class CreateShohinjim < ActiveRecord::Migration[5.2]
     def up
       execute <<-SQL
       CREATE VIEW shohinjim(id,shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka, torokubi, cteated_at, updated_at)
       AS
       SELECT *
       FROM db_shohins
       WHERE shohin_bunrui = '事務用品'
       SQL
     end

     def down
        execute <<-SQL
          DROP VIEW shohinjim
        SQL
     end
   end
   ```

1. rake db:migrate

1. これで view が完成。実際に rais dbconsole でコマンドを叩いてみる

   ```sql
       mysql> select * from shohinjim;
     +----+--------------------+---------------+--------------+--------------+------------+---------------------+---------------------+
     | id | shohin_mei         | shohin_bunrui | hanbai_tanka | shiire_tanka | torokubi   | cteated_at          | updated_at          |
     +----+--------------------+---------------+--------------+--------------+------------+---------------------+---------------------+
     |  2 | 穴あけパンチ       | 事務用品      |          500 |          320 | 2009-09-01 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  8 | ボールペン         | 事務用品      |          100 |         NULL | 2009-11-11 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     +----+--------------------+---------------+--------------+--------------+------------+---------------------+---------------------+
     2 rows in set (0.00 sec)

     INSERT INTO shohinjim VALUES(9,'印鑑','事務用品',95,19,'2009-11-30','2020-08-11 21:17:38', '2020-08-11 21:17:38');
     Query OK, 1 row affected (0.00 sec)

     mysql> select * from shohinjim;
     +----+--------------------+---------------+--------------+--------------+------------+---------------------+---------------------+
     | id | shohin_mei         | shohin_bunrui | hanbai_tanka | shiire_tanka | torokubi   | cteated_at          | updated_at          |
     +----+--------------------+---------------+--------------+--------------+------------+---------------------+---------------------+
     |  2 | 穴あけパンチ       | 事務用品      |          500 |          320 | 2009-09-01 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  8 | ボールペン         | 事務用品      |          100 |         NULL | 2009-11-11 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  9 | 印鑑               | 事務用品      |           95 |           19 | 2009-11-30 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     +----+--------------------+---------------+--------------+--------------+------------+---------------------+---------------------+
     3 rows in set (0.00 sec)

     mysql> select * from db_shohins;
     +----+-----------------------+--------------------+--------------+--------------+------------+---------------------+---------------------+
     | id | shohin_mei            | shohin_bunrui      | hanbai_tanka | shiire_tanka | torokubi   | created_at          | updated_at          |
     +----+-----------------------+--------------------+--------------+--------------+------------+---------------------+---------------------+
     |  1 | Tシャツ               | 衣服               |         1000 |          500 | 2009-09-20 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  2 | 穴あけパンチ          | 事務用品           |          500 |          320 | 2009-09-01 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  3 | カッターシャツ        | 衣服               |         4000 |         2800 | NULL       | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  4 | 包丁                  | キッチン用品       |         3000 |         2800 | 2009-09-20 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  5 | 包丁鍋                | キッチン用品       |         6800 |         5000 | 2009-01-15 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  6 | フォーク              | キッチン用品       |          500 |         NULL | 2009-09-20 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  7 | おろしがね            | キッチン用品       |          880 |          790 | 2009-04-28 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  8 | ボールペン            | 事務用品           |          100 |         NULL | 2009-11-11 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     |  9 | 印鑑                  | 事務用品           |           95 |           19 | 2009-11-30 | 2020-08-11 21:17:38 | 2020-08-11 21:17:38 |
     +----+-----------------------+--------------------+--------------+--------------+------------+---------------------+---------------------+
     9 rows in set (0.00 sec)
   ```

   上記のよううに DbShoin テーブルにも更新されていることがわかる。

## テーブル作成での注意(初歩的なミス)

以下のような Shouhinsum モデルを作成し、rails コンソールから Shohinsum.first など打った時に怒られた。

```shohinsum.rb
class Shohinsum < ApplicationRecord
end
```

```
 Shohinsum.first
  Shohinsum Load (0.7ms)  SELECT  `shohinsums`.* FROM `shohinsums` ORDER BY `shohinsums`.`id` ASC LIMIT 1
        1: from (irb):5
ActiveRecord::StatementInvalid (Mysql2::Error: Table 'function_development.shohinsums' doesn't exist: SELECT  `shohinsums`.* FROM `shohinsums` ORDER BY `shohinsums`.`id` ASC LIMIT 1)
irb(main):006:0> reload!
Reloading...
=> true
```

マイグレーションファイルを確認すると以下のように書いていた。

```db/migrate/20200819163105_create_shohinsums.rb

class CreateShohinsum < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
    CREATE VIEW shohinsum(shohin_bunrui,cnt_shohin)
    AS
    SELECT shohin_bunrui, COUNT(*)
    FROM db_shohins
    GROUP BY shohin_bunrui
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW shohinsum
    SQL
  end
end
```

SQL では SELECT shohinsums を呼び出しているが、マイグレーションファイルでは Shohinsum と定義されているので、呼び出すには

```SQL
select * from shohinsum;
```

としなければならない。

なので、一度マイグレーションファイルを以下のように作成し直した。

```db/migrate/20200819163105_create_shohinsums.rb

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
```

すると、コンソールで上手く表示された

```
> Shohinsum.first
  Shohinsum Load (0.4ms)  SELECT  `shohinsums`.* FROM `shohinsums` LIMIT 1
=> #<Shohinsum shohin_bunrui: "キッチン用品", cnt_shohin: 4>
```

# サブクエリ

サブクエリは使い捨てのビュー(select 文)。

まず作成したビューである Shohinsum で select 文を書く。

```shohinsum.rb
def self.view_select
  select('shohin_bunrui, cnt_shohin').as_json
end
```

結果は以下のように表示される。

```
> Shohinsum.view_select
  Shohinsum Load (0.3ms)  SELECT shohin_bunrui, cnt_shohin FROM `shohinsums`
=> [{"shohin_bunrui"=>"キッチン用品", "cnt_shohin"=>4}, {"shohin_bunrui"=>"事務用品", "cnt_shohin"=>2}, {"shohin_bunrui"=>"衣服", "cnt_shohin"=>2}]
```

上記と同じことを DbShohin モデルで再現させる。

```db_shohin.rb
 def self.sub_qery_1
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
```
