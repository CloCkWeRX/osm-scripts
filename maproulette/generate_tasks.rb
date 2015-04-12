require 'json'

require 'nokogiri'

file = File.new "sample.osm"
doc = Nokogiri::XML::Reader(file)
nodes = {}
ways = {}
nd = {}
tags = {}
current_way_id = 0

doc.each do |node|
  next if node.name == "#text"

  if node.name == "node"
    nodes[node.attribute("id")] ||= {
      visible: node.attribute('visible'),
      lat: node.attribute('lat'),
      lon: node.attribute('lon')
    }
  elsif node.name == "way"
    ways[node.attribute("id")] ||= {
      nodes: [],
      tags: {}
    }
    current_way_id = node.attribute("id").to_s
  elsif node.name == "nd"
    ways[current_way_id][:nodes] << nodes[node.attribute("ref")]
  elsif node.name == "tag"
    ways[current_way_id][:tags][node.attribute("k")] ||= node.attribute("v")
  elsif node.name == "osm"
  else
    p node.name
    p node.attribute_nodes
  end
end

tasks = []
ways.each do |id, way|
  nodes = way[:nodes].collect {|node|
    [node[:lat], node[:lon]]
  }

  properties = {
    osmid: id # This is probably wrong
  }

  tasks << {
    geometries: {
      type: "FeatureCollection",
      features: [{
        type: "Feature",
        properties: way[:tags],
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

tasks.each do |task|
  File.open(task[:geometries][:identifier], 'w') { |file| file.write(JSON.pretty_generate(task)) }
  puts JSON.pretty_generate(task)
end
