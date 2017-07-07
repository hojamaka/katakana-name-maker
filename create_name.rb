# coding: utf-8
require 'yaml'

FIRST = -1
LAST = -2

arr = YAML.load_file("katakana.yml")
chars = []
arr.each do |str|
  str.split(//).each do |c|
    chars << c unless chars.include?(c)
  end
end

start_table = {}
table = {}
arr.each do |chrs|
  prev_idx = nil
  schars = chrs.split(//)
  schars.each_with_index do |c, i|
    idx = chars.index(c)
    unless idx
      next
      prev_idx = idx
    end
    if i == 0
      start_table[idx] ||= 0
      start_table[idx] += 1
    else
      table[prev_idx] ||= {}
      table[prev_idx][idx] ||= 0
      table[prev_idx][idx] += 1
    end
    if i == schars.size - 1
      table[idx] ||= {}
      table[idx][LAST] ||= 0
      table[idx][LAST] += 1
    end
    prev_idx = idx
  end
end

20.times do
  idxs = []
  sum = start_table.values.inject(0) {|sum, v| sum += v }
  r = rand * sum
  target = nil
  sum = 0
  start_table.each do |k, v|
    sum += v
    if sum >= r
      target = k
      break
    end
  end
  #start_table.each do |k, v|
  #  puts chars[k]
  #end
  #raise
  idxs << target

  co = 0
  loop do
    co += 1
    break if co == 100
    tbl = table[idxs.last]
    break if idxs.size >= 6 && tbl.has_key?(LAST)
    sum = tbl.values.inject(0) {|sum, v| sum += v}
    r = rand * sum
    target = nil
    sum = 0
    tbl.each do |k, v|
      sum += v
      if sum >= r
        target = k
        break
      end
    end
    redo if target == LAST && idxs.size == 1
    break if target == LAST
    idxs << target
  end
  #p idxs
  str = ""
  idxs.each do |idx|
    str += chars[idx]
  end
  puts str
end
