require File.dirname(__FILE__) + '/spec_helper'

describe SvnAuthFile::Parser do
  it "should use the default listener when one isn't given" do
    SvnAuthFile::Parser.new('').listener.should be_instance_of(SvnAuthFile::DefaultListener)
  end
  
  describe 'parsing the group section' do
    # noitce the varying whitespace, make sure it doesn't affect parsing
    def group_section
      <<-EOF
[groups]
awesome-autobots = prime, ironhide, hound
evil-decepticons=Megatron,overkill,shockwave

everyone = @awesome-autobots, @evil-decepticons
EOF
    end

    before(:each) do
      @listener = stub_everything :lisener
      @parser = SvnAuthFile::Parser.new group_section, @listener
    end
    
    it "should notify the listener at the start of the groups section" do
      @listener.should_receive(:group_section_start)
      @parser.parse      
    end
    
    it "should notify the listener at the end of the groups section" do
      @listener.should_receive(:group_section_end)
      @parser.parse
    end
    
    it "should notify the listener for each group" do
      listener = mock :lisener, :group_section_end => '', :group_section_start => ''
      parser = SvnAuthFile::Parser.new group_section, listener
      listener.should_receive(:group).with('awesome-autobots', ['prime', 'ironhide', 'hound'])
      listener.should_receive(:group).with('evil-decepticons', ['Megatron', 'overkill', 'shockwave'])
      listener.should_receive(:group).with('everyone', ['@awesome-autobots', '@evil-decepticons'])      
      parser.parse
    end
    
  end
end