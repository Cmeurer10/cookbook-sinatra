class View
  def self.list(cookbook)
    # "test"
    arr = []
    cookbook.each_with_index do |recipe, ind|
      # puts "Test"
      arr << "#{ind + 1}. [#{recipe.tested}] name: #{recipe.name} (prep: #{recipe.prep_time}, cook: #{recipe.cooking_time})"
    end
    return arr
  end

  def self.query(meth, addendum = nil)
    puts "What recipe would you like to #{meth}?"
  end

  def self.display(str)
    puts str
  end
end
