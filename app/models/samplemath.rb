class Samplemath < ApplicationRecord
  def self.abs
    select('m, ABS(m) AS abs_col')

    # rubyっぽくかくなら以下
    # all.each do |i|
    #   unless i.m.nil?
    #     p i.m.abs
    #   end
    # end
  end

  def self.mod
    select('n, p, MOD(n, p) AS mod_col')
  end

  def self.round
    select('m, n, Round(m, n) AS mod_col')
  end
end
