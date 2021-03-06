require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "grake"
    gem.summary = %Q{A simple GTK2 interface for rake}
    gem.description = %Q{grake automatically generates a graphical user interface for your project's rake tasks}
    gem.email = "logan@logankoester.com"
    gem.homepage = "http://github.com/logankoester/grake"
    gem.authors = ["Logan Koester"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency "tree", ">= 0"
    gem.files << 'lib/grake/rakefile.rb'
    gem.files << 'lib/grake/tasktree.rb'
    gem.files << 'glade/grake-icon.png'
    gem.files << 'glade/grake_root_window_tall.glade'
    gem.files << 'glade/grake_root_window_wide.glade'
    gem.files << 'glade/grake_window.glade'
    gem.files << 'default_preferences.yml' 
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "grake #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
