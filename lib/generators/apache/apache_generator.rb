require 'rails/generators'

module Rops
  module Generators
    class ApacheGenerator < Rails::Generators::Base

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      attr_accessor :environment, :application_name, :server_name
      argument :environments, :type => :string, :default => "production,staging,qa"
      class_option :override, :type => :boolean, :default => false, :desc => "override the write protection"
      class_option :port, :type => :string, :default => "80", :desc => "port apache is to operate on"
      class_option :server_name, :type => :string, :default => "localhost", :desc => "domain name the site resolves too"

      def create_config
        if options.override or not File.exists? "services/apache/redirects"
          self.application_name = File.basename(Dir.getwd)
          environments.split(",").each do |e|
            self.environment = e
            template "apache.conf.erb", "services/apache/#{e}/apache"
            create_file "services/apache/#{e}/auth"
          end
          create_file "services/apache/redirects"
          template "common.conf.erb", "services/apache/common"
          template "ip.conf.erb", "services/apache/ip-restriction"
          template "headers.conf.erb", "services/apache/headers"
        else
          puts "You've already generated the apache config, you must pass the --override flag to overwrite it!"
        end
      end
    end
  end
end
