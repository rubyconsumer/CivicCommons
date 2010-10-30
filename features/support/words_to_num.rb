require 'linguistics'

module WordsToNum


  def words_to_num(word)
    num_words[word]
  end


  private


  def num_words
    return @num_words || build_num_words
  end

  def build_num_words
    @num_words =
      (1..1000).to_a.inject({}) do |acc, num|
        word = Linguistics::EN.numwords(num, group: 0)
        acc[word] = num
        acc
      end
  end


end
