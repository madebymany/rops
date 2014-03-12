require 'test_helper'

class NginxGeneratorTest < Rails::Generators::TestCase
  attr_writer :service_dir, :environments, :common

  def service_dir
    @service_dir || "services/nginx"
  end

  def environments
    @environments || %w(production staging qa)
  end

  def common
    @common || %w(common)
  end

  tests Rops::Generators::NginxGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  setup do
    prepare_destination
  end

  test "Assert all files are properly created" do
    prepare_destination
    run_generator
    self.environments.each do |env|
      self.check_config("#{self.service_dir}/#{env}/nginx", "localhost")
    end
    self.common.each do |c|
      assert_file "#{self.service_dir}/#{c}"
    end
  end

  test "Assert all files are created when environments CLI variable is set" do
    prepare_destination
    run_generator %w(test)
    assert_file "#{self.service_dir}/test/nginx"
    self.common.each do |c|
      assert_file "#{self.service_dir}/#{c}"
    end
  end

  def check_config(file, host)
    match = /server_name #{host}/
    assert_file file, match
  end
end
