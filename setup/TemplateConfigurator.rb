require 'fileutils'
require 'colored2'

module Pod
  class TemplateConfigurator

    attr_reader :pod_name, :pods_for_podfile, :prefixes, :test_example_file, :username, :email

    def initialize(pod_name)
      @pod_name = pod_name
      @pods_for_podspec_test_spec = ['Nimble']
      @test_framework = "xctest"
      @prefixes = []
      @message_bank = MessageBank.new(self)
    end

    #----------------------------------------#

    def ask(question)
      answer = ""
      loop do
        puts "\n#{question}?"

        @message_bank.show_prompt
        answer = gets.chomp

        break if answer.length > 0

        print "\nYou need to provide an answer."
      end
      answer
    end

    def ask_with_answers(question, possible_answers)

      print "\n#{question}? ["

      print_info = Proc.new {

        possible_answers_string = possible_answers.each_with_index do |answer, i|
           _answer = (i == 0) ? answer.underlined : answer
           print " " + _answer
           print(" /") if i != possible_answers.length-1
        end
        print " ]\n"
      }
      print_info.call

      answer = ""

      loop do
        @message_bank.show_prompt
        answer = gets.downcase.chomp

        answer = "yes" if answer == "y"
        answer = "no" if answer == "n"

        # default to first answer
        if answer == ""
          answer = possible_answers[0].downcase
          print answer.yellow
        end

        break if possible_answers.map { |a| a.downcase }.include? answer

        print "\nPossible answers are ["
        print_info.call
      end

      answer
    end

    #----------------------------------------#

    def run
      @message_bank.welcome_message

      ConfigureSwift.perform(configurator: self)

      delete_configuration_files
      rename_template_files
      replace_variables_in_files
      replace_test_file_with_template
      rename_pod_sources_folder
      reinitialize_git_repo

      @message_bank.farewell_message
    end

    #----------------------------------------#

    def delete_configuration_files
        ["./**/.gitkeep", "configure", "_CONFIGURE.rb", "LICENSE", "setup"].each do |asset|
            `rm -rf #{asset}`
        end
    end

    def rename_template_files
        FileUtils.mv "POD_README.md", "README.md"
        FileUtils.mv "POD_LICENSE", "LICENSE"
        FileUtils.mv "NAME.podspec", "#{pod_name}.podspec"
        FileUtils.mv "Tests/POD_Tests.swift", "Tests/#{pod_name}Tests.swift"
    end

    def replace_variables_in_files
        file_names = ['LICENSE', 'README.md', podspec_path]
        file_names.each do |file_name|
            text = File.read(file_name)
            text.gsub!("${POD_NAME}", @pod_name)
            text.gsub!("${REPO_NAME}", @pod_name.gsub('+', '-'))
            text.gsub!("${USER_NAME}", user_name)
            text.gsub!("${USER_EMAIL}", user_email)
            text.gsub!("${YEAR}", year)
            text.gsub!("${DATE}", date)
            File.open(file_name, "w") { |file| file.puts text }
        end
    end

    def replace_test_file_with_template
        content_path = "setup/test_examples/" + @test_framework + ".swift"
        tests_path = "Tests/#{pod_name}Tests.swift"
        tests = File.read tests_path
        tests.gsub!("${TEST_EXAMPLE}", File.read(content_path) )
        File.open(tests_path, "w") { |file| file.puts tests }
    end

    def rename_pod_sources_folder
        FileUtils.mv "Pod", @pod_name
    end

    def add_test_spec_dependency dep
        @pods_for_podspec_test_spec << dep
    end

    def add_dependencies_to_podspec_test_spec
        podspec_file = File.read podspec_path
        podspec_file_content = @pods_for_podspec_test_spec.map do |pod|
            "ts.dependency '" + pod + "'"
        end.join("\n    ")
        podspec_file.gsub!("${INCLUDED_TEST_DEPS}", podspec_file_content)
        File.open(podspec_path, "w") { |file| file.puts podspec_file }
    end

    def add_line_to_pch line
      @prefixes << line
    end

    def set_test_framework(test_type)
        @test_framework == test_type
    end

    def reinitialize_git_repo
      `rm -rf .git`
      `git init`
      `git add -A`
    end

    def validate_user_details
        return (user_email.length > 0) && (user_name.length > 0)
    end

    #----------------------------------------#

    def user_name
      (ENV['GIT_COMMITTER_NAME'] || github_user_name || `git config user.name` || `<GITHUB_USERNAME>` ).strip
    end

    def github_user_name
      github_user_name = `security find-internet-password -s github.com | grep acct | sed 's/"acct"<blob>="//g' | sed 's/"//g'`.strip
      is_valid = github_user_name.empty? or github_user_name.include? '@'
      return is_valid ? nil : github_user_name
    end

    def user_email
      (ENV['GIT_COMMITTER_EMAIL'] || `git config user.email`).strip
    end

    def year
      Time.now.year.to_s
    end

    def date
      Time.now.strftime "%m/%d/%Y"
    end

    def podspec_path
        "#{pod_name}.podspec"
    end

    #----------------------------------------#
  end
end
