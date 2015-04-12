Dir["tasks/**"].each do |file|
  url = "http://maproulette.org/api/admin/challenge/data-sa-gov-au-roads/tasks"

  %x{curl -vX POST #{url} -d #{file} --header 'Content-Type: application:json'}
end
