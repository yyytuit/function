class Samplelike < ApplicationRecord
  def self.mae
    # sqlの直書き
    find_by_sql("SELECT * FROM samplelikes WHERE strcol LIKE 'ddd%'")
    # railsの書き方
    where('strcol like ?', 'ddd%')
  end

  def self.ushiro
    # sqlの直書き
    find_by_sql("SELECT * FROM samplelikes WHERE strcol LIKE '%ddd'")
    # railsの書き方
    where('strcol like ?', '%ddd')
  end

  def self.mannaka
    # sqlの直書き
    find_by_sql("SELECT * FROM samplelikes WHERE strcol LIKE '%ddd%'")
    # railsの書き方
    where('strcol like ?', '%ddd%')
  end

  def self.ander
    # sqlの直書き
    find_by_sql("SELECT * FROM samplelikes WHERE strcol LIKE 'abc__'")
    # railsの書き方
    where('strcol like ?', 'abc__')
  end
end
