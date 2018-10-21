require 'sinatra'
require 'deeds'
require 'deputy'
require 'deputies'
require 'region'
require 'json'
require 'digest'

# TODO: Как разгрузить класс?
get('/region') do
  if params[:region] != ""
    result = Hash.new
    puts params[:region]
    result["region_name"] = Region.get_region_by_code(params[:region])
    result["deeds"] = Deeds.get_by_region_code(params[:region])
    return result.to_json
  end
end

get('/region/deeds') do
  result = Hash.new
  Region.all.each do |value|
    result[value["region"]] = Deeds.get_count_by_region_code(value["region"])
  end
  return result.to_json

end

get('/') do
  @title = "Примеры коррупции чиновников"
  erb :index
end


post('/deputy/suggest/create') do
  # TODO: куда вынести сохранение картинки? Как узнать размер картинки?
  deputy = Deputy.new(params)
  deputy.save
  redirect('/')
  #TODO: подтверждения, что запрос прошел успешно без редиректа

end

get('/deputy/suggest') do
  @title = "Предложить нового чиновника"
  erb :deputyform
end

get('/deputy/:id') do
  @deputy = Deputies.get_by_id(params[:id])
  @deeds = Deeds.get_by_deputy_id(params[:id])
  erb :deputy
end

get('/deputies') do
  @title = "Существующие депутаты"
  @deputies = Deputies.all
  erb :deputies
end

get('/deed/suggest') do
  @title = "Предложить правонарушение"
  @regions = Region.all
  erb :deedform
end

post('/deed/suggest/create') do
  links = []
  params.each do |key, value|
    if key.include? "proof_link"
      links << value
    end
  end
  params["proof_links"] = links
  deed = Deed.new(params)
  deed.save
  redirect('/')
end


