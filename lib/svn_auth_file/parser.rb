module SvnAuthFile
  class Parser
    class SyntaxError < StandardError
    end

    attr_reader :text, :listener
    
    def initialize(text, listener = nil)
      @text = text
      @listener = listener || DefaultListener.new
    end
    
    def parse
      in_groups, in_path = false, false
      
      @text.split($/).each do |line|        
        case line
          
        # TODO: Confirm that the group section must be before paths  
        when /^\s?\[groups\]\s?$/
          in_groups = true
          @listener.group_section_start
          
        # TODO: confirm group names may only start with letters, 
        # it may allow alpha-numeric          
        when /^[a-zA-Z].*$/ 
          raise SyntaxError, 'outside groups section' unless in_groups
          @listener.group *parse_group_line(line)
          
        when /^\s?\[([a-zA-Z0-9\-\_]*)\:?(\/.*)\]\s?$/
          if in_groups
            @listener.group_section_end
            in_groups = false
          end
          
          in_path = true
          @listener.path_start $2, $1
        when /^\#.*$/
          @listener.comment line          
        when /^\s$/, //
          @listener.empty_line
        else
          raise SyntaxError, "dont understand #{line}"
        end
      end
      
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
