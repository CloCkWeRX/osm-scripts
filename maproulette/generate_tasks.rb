require 'json'

require 'nokogiri'

file = File.new "sample.osm"
doc = Nokogiri::XML(file)

tasks = []
doc.xpath("//way").each do |way|
  nodes = way.xpath("nd").collect {|nd|
    node = doc.xpath("//node[@id='#{nd[:ref]}']").first

    [node[:lat], node[:lon]]
  }

  name    = way.xpath("tag[@k='name']").first[:v]
  surface = way.xpath("tag[@k='surface']").first[:v] rescue nil
  highway = way.xpath("tag[@k='highway']").first[:v] rescue nil

  properties = {
    osmid: way[:id] # This is probably wrong
  }
  properties[:name] = name if name
  properties[:surface] = surface if surface
  properties[:highway] = highway if highway

  tasks << {
    geometries: {
      type: "FeatureCollection",
      features: [{
        type: "Feature",
        properties: properties,
        geometry: {
          type: "LineString",
          coordinates: nodes
        }
      }],
      identifier: "data.sa.gov.au-roads-#{way[:id]}", # TODO Generate uniqueid
      instruction: "Is this way present, misspelt or other?"
    }
  }

end

puts JSON.generate tasks
# puts JSON.pretty_generate tasks