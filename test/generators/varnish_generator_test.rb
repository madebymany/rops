require 'test_helper'

class VarnishGeneratorTest < Rails::Generators::TestCase
  attr_writer :service_dir, :environments, :common

  def service_dir
    @service_dir || "services/varnish"
  end

  def environments
    @environments || %w(production staging qa)
  end
  
  def common
    @common || %w(miss deliver error pipe hash hit finish receive fetch init backends)
  end

  tests Rops::Generators::VarnishGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  setup do
    prepare_destination
  end

  test "Assert all files are properly created" do
    prepare_destination
    run_generator
    self.environments.each do |env|
      assert_file "#{self.service_dir}/#{env}/config"
    end
    self.common.each do |c|
      assert_file "#{self.service_dir}/#{c}"
    end
  end

  test "Assert the backend port is set correctly via the CLI option --backend-port" do
    prepare_destination
    run_generator ["--backend-port=81"]
    match = /.port = "81";/
    self.environments.each do |env|
      assert_file "#{self.service_dir}/#{env}/config", match
    end
  end

  test "Assert grace period is is set correctly via the CLI option --grace" do
    prepare_destination
    run_generator ["--grace=20"]
    match = /set req.grace = 20s;/
    assert_file "#{self.service_dir}/receive", match
    match = /set beresp.grace = 20s;/
    assert_file "#{self.service_dir}/fetch", match
  end
end
