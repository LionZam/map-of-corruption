require_relative '../assets/pg'

class Region
  def self.get_region_by_code(code)
    query_result = DBInit.conn.exec(
        "SELECT * FROM region WHERE region = '%s'" % code
    )
    if query_result.cmd_tuples == 0
      raise Sinatra::NotFound
    end
    query_result[0]["ru_region"]
  end

  def self.all
    DBInit.conn.exec(
        "SELECT * FROM region ORDER BY ru_region;"
    )
  end
end