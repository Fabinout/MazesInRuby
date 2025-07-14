class MazeEvent
  attr_reader :timestamp

  def initialize
    @timestamp = Time.now
  end

  def apply(maze)
    raise NotImplementedError, "Les sous-classes doivent implémenter apply"
  end

  def to_h
    { type: self.class.name, timestamp: @timestamp }
  end
end
