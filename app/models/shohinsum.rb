class Shohinsum < ApplicationRecord
  def self.view_select
    select('shohin_bunrui, cnt_shohin').as_json
  end
end
