require 'rails/generators'

module Rops
  module Generators
    class NginxGenerator < Rails::Generators::Base

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      attr_accessor :environment, :application_name, :server_name
      argument :environments, :type => :string, :default => "production,staging,qa"
      class_option :override, :type => :boolean, :default => false, :desc => "override the write protection"
      class_option :port, :type => :string, :default => "80", :desc => "port apache is to operate on"
      class_option :server_name, :type => :string, :default => "localhost", :desc => "domain name the site resolves too"
      class_option :server_aliases, :type => :string, :default => "localhost", :desc => "a list of server aliases seperated by a , e.g. 'www.example.org,subdomain.example.org'"

      def create_config
        if options.override or not File.exists? "services/nginx/common"
          self.application_name = File.basename(Dir.getwd)
          environments.split(",").each do |e|
            self.environment = e
            template "nginx.conf.erb", "services/nginx/#{e}/nginx"
          end
          template "common.conf.erb", "services/nginx/common"
        else
          puts "You've already generated the apache config, you must pass the --override flag to overwrite it!"
        end
      end
    end
  end
end
