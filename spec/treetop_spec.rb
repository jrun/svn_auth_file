require File.dirname(__FILE__) + '/spec_helper'

require 'rubygems'
require 'treetop'
Treetop.load File.dirname(__FILE__) + '/../lib/svn_auth_file_grammar'

describe "Treetop Grammar" do
  before(:each) do
    @parser = SvnAuthFileGrammarParser.new
  end
  
  def puts_tree(node, depth = 0)
    if node.elements
      node.elements.each do |e|
        puts "#{'*' * depth} #{e.text_value}"
        puts_tree e, depth + 1
      end
    end
  end
  
  it "should output groups" do
    tree = @parser.parse file_examples[:full]
    
    tree.should_not be_nil
    tree.elements.size.should > 0

    puts_tree tree
  end
end