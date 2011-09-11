module DeterminesLevelOfIndentation
  MaximumIndentationLevel = 2

  def further_indented?
    level_of_indentation < MaximumIndentationLevel
  end

  def level_of_indentation
    if number_of_ancestors > MaximumIndentationLevel
       MaximumIndentationLevel 
    else 
      number_of_ancestors
    end
  end

  private

  def number_of_ancestors
    number_of_ancestors = 0
    current_ancestor = parent
    until current_ancestor == nil do 
      number_of_ancestors += 1
      current_ancestor = current_ancestor.parent
    end
    number_of_ancestors
  end

end
