module SvnAuthFile
  class Parser
    def initialize(text, listener)
      @text = text
      @listener = listener || DefaultListener.new
    end
    
    
  end
end
