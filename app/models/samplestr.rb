class Samplestr < ApplicationRecord
  def self.renketsu
    select('str1,str2,
    str1 || str2 as str_concat')
  end
end
