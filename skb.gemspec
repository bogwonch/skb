# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'skb', 'version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'skb'
  s.version = Skb::VERSION
  s.author = 'Joseph Hallett'
  s.email = 'J.Hallett@sms.ed.ac.uk'
  s.homepage = 'https://skbfe.inf.ed.ac.uk/login'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Command line interface to the App Guarden SKB'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'skb.rdoc']
  s.rdoc_options << '--title' << 'skb' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'skb'

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('rubocop')

  s.add_runtime_dependency('gli', '2.12.2')
  s.add_runtime_dependency 'escort', '~> 0.4.0'
  s.add_runtime_dependency 'rickshaw', '~> 0.2.0'
  s.add_runtime_dependency 'mime-types', '~> 2.4.0'
  s.add_runtime_dependency 'xdg', '~> 2.2.3'
  s.add_runtime_dependency 'ruby-filemagic', '~> 0.6.1'
  s.add_runtime_dependency 'nokogiri', '~> 1.6.3.1'
  s.add_runtime_dependency 'parallel', '~> 1.3.3'

end
