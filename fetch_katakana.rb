# coding: utf-8
require 'yaml'
require 'open-uri'
require 'nokogiri'

uris = [
  "https://ja.wikipedia.org/wiki/%E3%82%AE%E3%83%AA%E3%82%B7%E3%82%A2%E7%A5%9E%E8%A9%B1%E3%81%AE%E5%9B%BA%E6%9C%89%E5%90%8D%E8%A9%9E%E4%B8%80%E8%A6%A7",
]
#user_agent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

arr = []
uris.each do |uri|
  doc = Nokogiri::HTML(open(uri).read)
  arr += doc.text.scan(/[\p{katakana}][\p{katakana}ー－～ 　・]+/) # カタカナ
  #arr = doc.text.scan(/[\p{hiragana}][\p{hiragana}ー－～ 　・]+/) # ひらがな
  #arr = doc.text.scan(/[一-龠々][一-龠々 　]+/) # 漢字
end

arr.each do |str|
  str.gsub!(/[\s 　]+/, '')
  str.gsub!(/・$/, '')
end

File.open("katakana.yml", "w") do |f|
  YAML.dump(arr.uniq, f)
end
