module SvnAuthFile
  class Parser
    class Regex
      # TODO: Confirm that the group section must be before paths
      GROUP_SECTION = /\[groups\]/
      # TODO: confirm group names may only start with letters, 
      # it may allo alpha-numeric
      GROUP_LINE = /(^\s[a-zA-Z].*$)|(^$)/
      
      PATH_LINE = /^\s\[(.*:)+\/.*\]\s$/
    end
    
    attr_reader :text, :listener
    
    def initialize(text, listener = nil)
      @text = text
      @listener = listener || DefaultListener.new
    end
    
    def parse(scanner = nil)
      scanner ||= Scanner.new @text
      scanner.skip_until Regex::GROUP_SECTION
      
      @listener.group_section_start
      
      while ! (group_line = scanner.scan Regex::GROUP_LINE).nil?
        if group_line
          @listener.group *parse_group_line(group_line)
          e
      end

      @listener.group_section_end
      
    end
    
    private
    # Parses a group definition.
    #
    # === Parameters
    # line<String>:: The line of text declaring a group and its members.
    #
    # === Examples
    #
    # parse_group_line("autobots = Ratchet, Wheeljack, Mirage")
    # => ["autobots", ["Rachet", "Wheeljack", "Mirage"]]
    #
    def parse_group_line(line)
      name, groups = line.split('=')
      [name.strip, groups.split(',').map {|g| g.strip } ]
    end
  
    # Parses the permission line into the assignee and assigned permission.
    #
    # === Parameters
    # line<String>:: The permission line to parse.
    #
    # === Examples
    #
    # parse_permission_line("Grapple = rw")
    # => ["Grapple", "rw"]
    #
    def parse_permission_line(line)
      line.split('=').map {|s| s.strip }
    end
  end
end
