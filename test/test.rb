require '../assets/pg'

def add
  File.open('../assets/Region names.txt').each do |line|
    line.chop!
    region_code = line[0..line.index(' ') - 1]
    region_value = line[line.index(' ') + 1..line.size - 1]
    DBInit.conn.exec(
        "INSERT INTO region(region, ru_region) VALUES ('%s','%s')" % [region_code, region_value]
    )
  end
end

add

=begin
def try
  line = File.open('../assets/Region names.txt').first
  line.chop!
  region_code = line[0..line.index(' ')-1]
  region_value = line[line.index(' ')+1..line.size-1]

  DBInit.conn.exec(
      "INSERT INTO region(region, ru_region) VALUES ('%s','%s')" % [region_code , region_value]
  )
end
=end


