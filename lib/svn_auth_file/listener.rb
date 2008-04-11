module SvnAuthFile
  module Listener
    def start_group_section
    end
    
    def end_group_section
    end
    
    def start_group(group_name)
    end
    
    def end_group
    end
    
    def start_group_membership(group, member)
    end
    
    def end_group_membership
    end
    
    def start_path(path, repository_name = nil)
    end
    
    def end_path
    end
    
    def start_permission(assignee, permission)
    end
    
    def end_permission
    end
  end
  
  class DefaultListener
    include Listener
  end
end