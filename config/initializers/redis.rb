uri = URI.parse(ENV[URI.encode('redis://redistogo:e386ea66cddba54d88d815e28b8b5ee9@grouper.redistogo.com:10058')])
REDIS = Redis.new(:url => ENV['redis://redistogo:e386ea66cddba54d88d815e28b8b5ee9@grouper.redistogo.com:10058'])