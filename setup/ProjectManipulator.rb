require 'xcodeproj'

module Pod

  class ProjectManipulator
    attr_reader :configurator, :example_source_path, :string_replacements, :prefix

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @example_source_path = options.fetch(:example_source_path)
      @configurator = options.fetch(:configurator)            
      @prefix = options.fetch(:prefix)
    end

    def run
      @string_replacements = {
        "PROJECT_OWNER" => @configurator.user_name,
        "TODAYS_DATE" => @configurator.date,
        "TODAYS_YEAR" => @configurator.year,
        "PROJECT" => @configurator.pod_name,
        "PREFIX" => @prefix
      }
      replace_internal_project_settings
    end

    def replace_internal_project_settings
        Dir.glob(@example_source_path + "/**/**/**/**").each do |name|
            next if Dir.exists? name
            text = File.read(name)

            for find, replace in @string_replacements
                text = text.gsub(find, replace)
            end

            File.open(name, "w") { |file| file.puts text }
        end
    end

  end

end
