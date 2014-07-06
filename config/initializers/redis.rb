uri = URI.parse(ENV['redis://redistogo:e386ea66cddba54d88d815e28b8b5ee9@grouper.redistogo.com:10058/'] )
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)