require File.dirname(__FILE__) + '/spec_helper'

describe SvnAuthFile::Parser do
  it "should use the default listener when one isn't given" do
    SvnAuthFile::Parser.new('').listener.should be_instance_of(SvnAuthFile::DefaultListener)
  end
    
  it "should notify the listener at the start of the groups section" do
    listener = mock :listener, :group => '', :group_section_end => '', :path_start => '', :empty_line => '' 
    listener.should_receive(:group_section_start)
    parser = SvnAuthFile::Parser.new file_examples[:full], listener
    parser.parse
  end

  it "should notify the listener at the end of the groups section" do
    listener = mock :listener, :group => '', :group_section_start => '', :path_start => '', :empty_line => ''
    listener.should_receive(:group_section_end)
    parser = SvnAuthFile::Parser.new file_examples[:full], listener
    parser.parse
  end
      
  it "should notify the listener for each group" do
    listener = mock :listener, :group_section_end => '', :group_section_start => '', :empty_line => ''
    parser = SvnAuthFile::Parser.new file_examples[:groups_section], listener
    listener.should_receive(:group).with('awesome-autobots', ['prime', 'ironhide', 'hound'])
    listener.should_receive(:group).with('evil-decepticons', ['Megatron', 'overkill', 'shockwave'])
    listener.should_receive(:group).with('everyone', ['@awesome-autobots', '@evil-decepticons'])      
    parser.parse
  end

  it "should notify the listenr of a comment" do
    listener = mock :listener
    listener.should_receive(:comment).with('# comment line 1')
    listener.should_receive(:comment).with('# comment line 2')    
    SvnAuthFile::Parser.new(file_examples[:with_comments], listener).parse    
  end
  
  it "should notify the listener of empty lines" do
    listener = mock :listener
    listener.should_receive(:empty_line)
    SvnAuthFile::Parser.new(" ", listener).parse
  end  
  
  describe "parsing paths" do
    before(:each) do
      @listener = mock :listener, :group_section_start => '', :group_section_end => '', :group => '', :empty_line => ''
    end
    
    it "should notify the listener at the start of a root path" do
      @listener.should_receive(:path_start).with('/', '')      
      parser = SvnAuthFile::Parser.new file_examples[:root_path], @listener
      parser.parse
    end
    
    it "should notify the listener at the start of a simple path" do
      @listener.should_receive(:path_start).with('/trunk', 'metroplex')      
      parser = SvnAuthFile::Parser.new file_examples[:simple_path], @listener
      parser.parse
    end
    
    it "should notify the listener at the start of path with interesting characters" do
      @listener.should_receive(:path_start).with('/tags/rel-1.0.0', 'slammer')      
      parser = SvnAuthFile::Parser.new file_examples[:path_with_interesting_characters], @listener
      parser.parse
    end
  end
end