Gem::Specification.new do |s|
  s.name          = 'nrsgateway'
  s.version       = '0.0.1'
  s.date          = '2015-07-22'
  s.summary       = 'NRSGateway SMS send through HTTP'
  s.description   = 'A gateway to send SMS using HTTP, through NRSGateway, written in ruby'
  s.files         = ['lib/nrs_gateway.rb']
  s.require_path  ='lib'
  s.author        = 'Angel García Pérez'
  s.email         = 'wage83@gmail.com'
  s.homepage      = 'http://nrsgateway.com/http_api_peticion.php'
  s.has_rdoc      = false

  s.add_dependency('global_phone', '~>1.0.1')
  s.add_development_dependency('rake', '~> 0.8.7')
  s.add_development_dependency('rspec', '>1.3.1')
  s.add_development_dependency('json')
end
