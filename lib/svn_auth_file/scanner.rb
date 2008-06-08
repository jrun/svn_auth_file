require 'strscan'

module SvnAuthFile
  class Scanner < StringScanner
    # used to get the starting position of the match
		def matched_start_pos
			self.pos - self.matched_size
		end
		
		def scan_to_newline
			self.scan(/#{$/}/)
		end
  end
end