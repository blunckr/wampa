require 'pry'
desc 'Get the latest schema from swapi.co'
task :scrape_schema do
  FileUtils.rm_rf(Dir.glob('data/*'))

  resources_schema = Wampa.make_request
  File.write('data/resources.yml', resources_schema.to_yaml)

  resources_schema.keys.each do |resource_name|
    resource_schema = Wampa.make_request("#{resource_name}/schema")
    File.write("data/#{resource_name}.yml", resource_schema.to_yaml)
  end
end
