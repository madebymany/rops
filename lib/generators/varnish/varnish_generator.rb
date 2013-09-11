require 'rails/generators'

module Rops
  module Generators
    class VarnishGenerator < Rails::Generators::Base

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      attr_accessor :environment, :application_name
      argument :environments, :type => :string, :default => "production,staging,qa"
      class_option :backend_port, :type => :string, :default => "80", :desc => "backend_port to forward requests to"
      class_option :override, :type => :boolean, :default => false, :desc => "override the write protection"
      class_option :host, :type => :string, :default => "127.0.0.1", :desc => "backend hostname to forward traffic to"
      class_option :grace, :type => :numeric, :default => "10", :desc => "grace period to serve stale objects for while the back-end is offline"

      def create_config
        if options.override or not Dir.exists? "services/varnish"
          self.application_name = File.basename(Dir.getwd)
          environments.split(",").each do |e|
            template "varnish.vcl.erb", "services/varnish/#{e}/config"
          end
          template "hit.vcl.erb", "services/varnish/hit"
          template "hash.vcl.erb", "services/varnish/hash"
          template "init.vcl.erb", "services/varnish/init"
          template "backends.vcl.erb", "services/varnish/backends"
          template "deliver.vcl.erb", "services/varnish/deliver"
          template "receive.vcl.erb", "services/varnish/receive"
          template "finish.vcl.erb", "services/varnish/finish"
          template "pipe.vcl.erb", "services/varnish/pipe"
          template "fetch.vcl.erb", "services/varnish/fetch"
          template "miss.vcl.erb", "services/varnish/miss"
          template "error.vcl.erb", "services/varnish/error"

        else
          puts "You've already generated the varnish config, you can't override it!"
        end
      end
    end
  end
end
