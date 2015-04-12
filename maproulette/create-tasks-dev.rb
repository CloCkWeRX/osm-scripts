Dir["tasks/**"].each do |file|
  puts File.read(file)
  url = "http://dev.maproulette.org/api/admin/challenge/data-sa-gov-au-roads/task/#{file.split("/").last}"
  
  puts "curl -vX PUT #{url} -d #{file} --header 'Content-Type: application:json'"  
end
