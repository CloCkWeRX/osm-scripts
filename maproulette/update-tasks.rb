Dir["tasks/**"].each do |file|
  puts File.read(file)
  url = "http://maproulette.org/api/admin/challenge/data-sa-gov-au-roads/task/#{file.split("/").last}"

  puts "curl -vX POST #{url} -d #{file} --header 'Content-Type: application:json'"  
end
