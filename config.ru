# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# http://angularonrails.wpengine.com/deploy-angular-cli-webpack-project-heroku/
# use Rack::Rewrite do
#   rewrite %r{^(?!.*(api|\.)).*$}, '/index.html'
# end
 
# require ::File.expand_path('../config/environment',  __FILE__)

use Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000', 'localhost:4200',
            /\Ahttp:\/\/192\.168\.0\.\d{1,3}(:\d+)?\z/
            # regular expressions can be used here

    resource '/file/list_all/', :headers => 'x-domain-token'
    resource '/file/at/*',
        :methods => [:get, :post, :delete, :put, :patch, :options, :head],
        :headers => 'x-domain-token',
        :expose  => ['Some-Custom-Response-Header'],
        :max_age => 600
        # headers to expose
  end

  allow do
    origins '*'
    resource '/public/*', :headers => :any, :methods => :get
  end
end

ActionCable.server.config.disable_request_forgery_protection = true

run Rails.application
