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
