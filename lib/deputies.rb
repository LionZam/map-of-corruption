require_relative '../assets/pg'
require 'deputy'
class Deputies
  def self.get_by_id(id)
    query_result = DBInit.conn.exec(
        "SELECT *
          FROM deputy
          WHERE id = '#{id}';"
    )
    if query_result.cmd_tuples == 0
      raise Sinatra::NotFound
    end
    Deputy.new(query_result[0])
  end

  def self.all
    query_result = DBInit.conn.exec(
        "SELECT * FROM deputy ORDER BY id;"
    )
    deputies = query_result.map do |value|
      Deputy.new(value)
    end
    deputies
  end

end