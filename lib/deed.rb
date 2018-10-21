class Deed
  attr_reader :sign, :detriment, :punishment, :status, :deputy_id, :deputy, :proof_links, :region, :position, :date, :ru_region

  # TODO: нормальные запросы
  def initialize(params)
    @sign = params["sign"].capitalize
    @detriment = params["detriment"].capitalize
    @punishment = params["punishment"].capitalize
    @status = params["status"].capitalize
    @position = params["position"].capitalize
    @deputy_id = params["deputy_id"]
    @deputy = params["deputy"]
    @proof_links = params["proof_links"]
    @region = params["region"]
    @date = params["date"].split(" ")[0]
    @ru_region = params["ru_region"]
  end

  def save_suggest
    save_in_db("deed_suggest")
  end

  def save
    save_in_db("deed")
  end

  private

  def save_in_db(tablename)
    a = DBInit.conn.exec(
        "INSERT INTO #{tablename}(deputy_id, region, sign, detriment, punishment, status, position, date) VALUES ('#{deputy_id}', '#{region}', '#{sign}', #{detriment}, '#{punishment}', '#{status}', '#{position}', '#{date}') RETURNING *;"
    )
    proof_links.each do |value|
      DBInit.conn.exec(
          "INSERT INTO proof_links(deed_id, link) VALUES ('#{a[0]["deed_id"]}', '#{value}')"
      )
    end
  end

end