class Recipe
  attr_reader :name, :description, :difficulty, :prep_time, :cooking_time, :tested
  def initialize(name, description, difficulty = nil, prep_time = nil, cooking_time = nil, tested = ' ')
    @name = name
    @description = description
    @difficulty = difficulty
    @prep_time = prep_time
    @cooking_time = cooking_time
    @tested = tested
  end

  def tested!
    @tested = "X"
  end
end
