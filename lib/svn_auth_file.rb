this_file = File.dirname(__FILE__)
$:.unshift(this_file) unless $:.include?(this_file) || $:.include?(File.expand_path(this_file))

require 'svn_auth_file/listener'
require 'svn_auth_file/parser'