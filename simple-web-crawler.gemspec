Gem::Specification.new do |s|
  s.name        = 'simple-web-crawler'
  s.version     = '0.0.1'
  s.date        = '2018-12-31'
  s.summary     = 'A simple web crawler'
  s.description = 'How is this different than summary...'
  s.authors     = ['Will Dengler']
  s.email       = 'navyhockey56@gmail.com'
  s.files       = Dir['lib/**/*.rb']

  s.add_development_dependency 'pry'
  s.add_dependency 'nokogiri'
end
