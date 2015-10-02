module JenkinsModules
  module Pipeline
    def self.all_names
      file = File.join(Rails.root, 'lib', 'pipeline.yml')
      YAML::load(File.open(file))["pipelines"]
    end
  end
end
