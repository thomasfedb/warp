module Warp
  module VERSION
    MAJOR = 1
    MINOR = 4
    PATCH = 0

    BETA = nil

    def self.to_s
      version_str = [MAJOR, MINOR, PATCH].map(&:to_s).join(".")
      version_str << ".beta#{BETA}" if BETA
      version_str
    end
  end
end
