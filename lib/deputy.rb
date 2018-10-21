require_relative '../assets/pg'
require 'deputy'
class Deputy
  attr_reader :name, :surname, :patronymic, :position, :id, :photo_href

  def initialize(params)
    @id = params["id"]
    @name = params["name"].capitalize
    @surname = params["surname"].capitalize
    @patronymic = params["patronymic"].capitalize
    @position = params["current_position"].capitalize
    if params[:file]
      filename = params[:file][:filename].split(".")[0]
      filename = Digest::MD5.hexdigest filename
      format = params[:file][:filename].split(".")[1]
      tempfile = params[:file][:tempfile]
      target = "public/img/deputies/#{filename + "." + format}"
      path = "/img/deputies/#{filename + "." + format}"
      File.open(target, 'wb') do |f|
        f.write tempfile.read
      end
      @photo_href = path
    else
      @photo_href = params["photo_href"]
    end
  end

  def save_suggest
    save_in_db("deputy_suggest")
  end

  def save
    save_in_db("deputy")
  end

  private

  def save_in_db(tablename)
    DBInit.conn.exec(
        "INSERT INTO #{tablename}(name, surname, patronymic,current_position,photo_href) VALUES ('#{name}', '#{surname}', '#{patronymic}', '#{position}', '#{photo_href}')"
    )
  end
end
