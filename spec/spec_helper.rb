begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require 'yaml'
    
$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'svn_auth_file'

module SpecHelper
  def null_mock(name, options = {})
    mock name, options.merge(:null_object => true)
  end
  
  alias :null_stub :null_mock
  
  def file_examples
    @data ||= YAML::load_file(File.dirname(__FILE__) + '/svn_auth_examples.yaml')
  end
end
 
Spec::Runner.configure do |config|
  config.include(SpecHelper)
end