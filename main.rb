require_relative 'services/proper_thursday'
require_relative 'app'

file = File.open('tmp/added_pluses.json')
plus_records = JSON.load(file)
return if plus_records.include?(ProperThursday.new.call)
file.close

App.new.call
