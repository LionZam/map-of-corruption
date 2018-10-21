require 'deputies'
require 'deed'
require_relative '../assets/pg'
require 'json'

class Deeds
  def self.get_by_region_code(code)
=begin
    query_result = DBInit.conn.exec(
        "SELECT deed.*, region.ru_region FROM deed
          JOIN region ON deed.region = region.region
          WHERE region.region = '#{code}';"
    )
    deputy = Deputies.get_by_id(query_result[0]["deputy_id"])
    deeds = []
    query_result.each do |map|
      deeds << Deed.new({
                           :sign => map["sign"],
                           :detriment => map["detriment"],
                           :punishment => map["punishment"],
                           :status => map["status"],
                           :deputy_id => map["deputy_id"],
                           :deputy => deputy
                       })
    end
    deeds
=end
#Получаем все дела и их авторов
    query_result = DBInit.conn.exec(
        "SELECT deputy.name, deputy.surname, deputy.patronymic, deputy.current_position, deputy.photo_href, d_r.*
          FROM deputy
          LEFT JOIN (SELECT deed.*, region.ru_region FROM deed
          JOIN region ON deed.region = region.region) as d_r
          ON d_r.deputy_id = deputy.id WHERE region = '#{code}';"
    )
    result = Hash.new
    query_result.each do |map|
      links_query = DBInit.conn.exec(
          "SELECT *
          FROM proof_links
          WHERE deed_id = '#{map["deed_id"]}';"
      )
      map["date"] = map["date"].split(" ")[0]
      links = ""
      links_query.each do |val|
        links += val.values[1]
      end
      map["proof_links"] = links
      result[map["deed_id"]] = map.to_json
    end
    result.to_json
  end

  def self.get_by_deputy_id(id)
=begin
    deed_query = DBInit.conn.exec(
        "SELECT deputy.name, deputy.surname, deputy.patronymic, deputy.current_position, deputy.photo_href, d_r.*
          FROM deputy
          LEFT JOIN (SELECT deed.*, region.ru_region FROM deed
          JOIN region ON deed.region = region.region) as d_r
         ON d_r.deputy_id = deputy.id WHERE id = #{id};"
    )
    proofs = DBInit.conn.exec(
        "SELECT * FROM proof_links WHERE = '#{deed_query[0]["deed_id"]}'"
    )
=end
    deed_query = DBInit.conn.exec(
        "SELECT deed.*, region.ru_region
          FROM deed
          JOIN region ON deed.region = region.region
          WHERE deed.deputy_id = '#{id}';"
    )
    deeds = deed_query.map do |map|
      links_query = DBInit.conn.exec(
          "SELECT *
          FROM proof_links
          WHERE deed_id = '#{map["deed_id"]}';"
      )
      map["proof_links"] = links_query.map do |link|
        link["link"]
      end
      i = 1
      Deed.new(map)
    end
    deeds
  end

  def self.get_count_by_region_code (code)
    query = DBInit.conn.exec("SELECT count(*) FROM deed WHERE region = '#{code}'")
    query[0]["count"]
  end

#TODO: вывод в JSON'е вынести в отдельный класс
=begin
  def self.get_json_by_region_code(code)
    result = Hash.new
    get_by_region_code(code).each do |deputy|
      result[deputy.deputy_id] = JSON.parse deputy
    end
    result
  end
=end
end