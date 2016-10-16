class Cycle
  class Log < ::Log
    def tag!(tags)
      tags << :cycle
      tags << :library
      tags << :verbose
    end
  end
end
