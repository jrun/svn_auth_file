module SvnAuthFile
  module Listener
    def group_section_start
    end
    
    def group_section_end
    end
    
    def group(group, members)
    end
    
    def path_start(path, repository = nil)
    end
    
    def path_end
    end
    
    def permission(permission, assignee)
    end
    
    def group_permission(permission, group)
    end
    
    def comment_line(comment)
    end
    
    def empty_line
    end
  end
  
  class DefaultListener
    include Listener
  end
end