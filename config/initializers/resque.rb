require 'resque'
Dir['/app/workers/*.rb'].each { |file| require file }