Dir["tasks/**"].each do |file|
  file = 'tasks/test.json'
  puts File.read(file)
  url = "http://dev.maproulette.org/api/admin/challenge/data-sa-gov-au-roads/tasks"
  puts %x{curl -vX POST #{url} -d @./#{file} --header 'Content-Type: application:json'}
  exit
end
