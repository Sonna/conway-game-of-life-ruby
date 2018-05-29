module ConwayGameOfLife
  class Cell
    def initialize(alive = (rand.round == 0))
      @alive = alive
    end

    def ==(other)
      self.class == other.class && self.alive? == other.alive?
    end

    def alive!
      @alive = true
    end

    def alive?
      @alive
    end

    def dead!
      @alive = false
    end

    def dead?
      !alive?
    end

    def render
      alive? ? "*" : "."
    end
  end
end
