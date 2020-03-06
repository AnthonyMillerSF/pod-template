module Pod

  class ConfigureSwift
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform
      keep_example = configurator.ask_with_answers("Would you like to include an example application with your library", ["Yes", "No"]).to_sym

      use_quick = configurator.ask_with_answers("Will you use Quick for testing?", ["Yes", "No"]).to_sym
      if use_quick == :yes
          configurator.add_test_spec_dependency "Quick"
          configurator.set_test_framework "quick"
      else
          configurator.set_test_framework "xctest"
      end

      snapshots = configurator.ask_with_answers("Would you like to include snapshot tests", ["Yes", "No"]).to_sym
      case snapshots
        when :yes
          configurator.add_test_spec_dependency "iOSSnapshotTestCase", '~> 6.2'
          configurator.add_test_spec_dependency "Nimble-Snapshots", '~> 8.1'

          if keep_example == :no
              puts " Putting example application back in, you cannot include snapshot tests without a host application."
              keep_example = :yes
          end
      end

      configurator.set_keep_example(keep_example == :yes)

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :example_source_path => "Example/",
        :prefix => ""
      }).run

      # There has to be a single file in the Classes dir
      # or a framework won't be created
      `touch Pod/Sources/ReplaceMe.swift`      
    end
  end

end
