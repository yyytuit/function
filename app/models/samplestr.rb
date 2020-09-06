class Samplestr < ApplicationRecord
  def self.renketsu
    # sqlでの書き方
    select('str1,str2, CONCAT(str1, str2) as str_concat').as_joson

    # rubyっぽく書く
    where.not(str1: nil, str2: nil).each do |i|
      p i.str1 + i.str2
    end
  end

  def self.renketsu_3
    # sqlで直書き
    find_by_sql("SELECT str1,str2, str3, CONCAT(str1, str2, str3) AS str_concat FROM samplestrs WHERE str1 = '山田'").as_joson

    # rubyっぽく書く
    a = Samplestr.find_by(str1: '山田')
    puts a.str1 + a.str2 + a.str3
  end

  def self.mojicho
    # sqlでの書き方
    select('str1, length(str1) as len_str').as_joson

    # rubyっぽく書く
    where.not(str1: nil).each do |i|
      p i.str1.length
    end
  end

  def self.lower
    # sqlで直書き
    find_by_sql("SELECT str1, LOWER(str1) AS low_str FROM samplestrs WHERE str1 in ('ABC','aBC','abc','山田')").as_json

    # rubyっぽく書く
    where( str1: ['ABC','aBC','abc','山田']).each { |i| p i.str1.downcase }
  end

  def self.upper
    # sqlでの書き方
    select('str1, UPPER(str1) AS low_str').as_json

    # rubyっぽく書く
    where.not(str1: nil).each { |i| p i.str1.upcase}
  end

  def self.replace_to
    # sqlでの直書き
    find_by_sql('SELECT str1, str2, str3, REPLACE(str1,str2,str3) AS rep_str FROM samplestrs').as_json

    # rubyっぽく書く
    where.not(str1: nil, str2: nil, str3: nil).each do |i|
      a = i.str1
      a.gsub!(/#{i.str2}/, "#{i.str3}")
    end
  end

  def self.substirng
    # sqlでの直書き
    find_by_sql('SELECT str1, SUBSTRING(str1 FROM 3 FOR 2) AS sub_str FROM samplestrs').as_json
    # rubyっぽく書く
    where.not(str1: nil).each { |i| p i.str1[2,2] }
  end

  def self.substirng_all
    # sqlでの直書き
    find_by_sql('SELECT str1, SUBSTRING(str1 FROM 3) AS sub_str FROM samplestrs').as_json

    # rubyっぽく書く
    where.not(str1: nil).each do |i|
      a = i.str1
      a.slice!(0..1)
      p a
    end
  end

  def self.current_date
    # sqlでの直書き
    find_by_sql('SELECT current_date').as_json

    # rubyで書く
    Date.today
  end

  def self.current_time
    # sqlでの直書き
    find_by_sql('SELECT current_time').as_json
    # rubyで書く
    DateTime.now
  end

  def self.current_timestamp
    # sqlでの直書き
    find_by_sql('SELECT current_timestamp').as_json
    # rubyで書く
    DateTime.now.to_time
  end

  def self.extract
    # sqlでの直書き
    find_by_sql('SELECT current_timestamp,
                 EXTRACT(month from current_timestamp) AS month,
                 EXTRACT(day from current_timestamp) AS day,
                 EXTRACT(hour from current_timestamp) AS hour,
                 EXTRACT(minute from current_timestamp) AS minute,
                 EXTRACT(second from current_timestamp) AS second').as_json
    # rubyで書く
    a = DateTime.now
    DateTime._strptime(a.to_s)
  end

  def self.cast
    # sqlでの直書き
    find_by_sql("SELECT CAST('0001' AS SIGNED INTEGER) AS int_col").as_json
    find_by_sql("SELECT CAST('2009-12-14' AS DATE) AS date_col").as_json
    # ruby
    p '0001'.to_i
    p '2009-12-14'.to_date
  end

  def self.coalesce
    # sqlでの直書き
    find_by_sql("SELECT COALESCE(null, 1) as col_1,
                 COALESCE(null,'test',null) as col_2,
                 COALESCE(null,null,'2009-11-01') as col_3")
    select("str2, COALESCE(str2, 'nullです') AS coa_col")

    # rubyっぽく書く
    all.each { |i| p i.str2.present? ? i.str2 : 'nullです' }
  end

  
end
