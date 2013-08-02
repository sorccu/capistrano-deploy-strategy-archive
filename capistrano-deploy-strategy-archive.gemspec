# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "capistrano-deploy-strategy-archive"
  gem.version       = "0.1.2"
  gem.authors       = ["Simo Kinnunen"]
  gem.email         = ["simo@shoqolate.com"]
  gem.homepage      = "https://github.com/sorccu/capistrano-deploy-strategy-archive"
  gem.summary       = %q{Archive deploy strategy for Capistrano.}
  gem.description   = %q{Provides an :archive deploy strategy for Capistrano. It takes an existing, pre-built archive and deploys it as-is. Useful when you've got a server making builds for you, which you then later deploy.}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('capistrano', '>=2.1.0')
end
