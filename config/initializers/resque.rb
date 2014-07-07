require 'resque/server'
Dir['/app/workers/*.rb'].each { |file| require file }