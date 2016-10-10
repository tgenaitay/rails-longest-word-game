class GameController < ApplicationController
  def play
    alphabet = ('A'..'Z').to_a
    @grid = Array.new(15) { alphabet.sample }
  end

  def score
    @start_time = params[:start_time].to_i
    @grid = params[:grid]
    @attempt = params[:attempt]
    @end_time = Time.now
    @result = run_game(@attempt, @grid, @start_time, @end_time)
    p @result[:time].to_i
    p @result[:score]
  end

  MESSAGES = {
    message1: "not in the grid",
    message2: "not an english word",
    message3: "well done"
  }

  def parser(input)
    platform = "https://api-platform.systran.net/translation/text/"
    key = "5410a8ff-dba7-402c-b917-d874f4f83e81"
    url = "#{platform}translate?source=en&target=fr&key=#{key}&input=#{input}"
    translation_serialized = open(url).read
    translation = JSON.parse(translation_serialized)
    translation["outputs"][0]["output"]
  end

  def build_result1(result)
    result[:message] = MESSAGES[:message1]
    result[:score] = 0
    return result
  end

  def build_result2(result)
    result[:message] = MESSAGES[:message2]
    result[:score] = 0
    result[:translation] = nil
    return result
  end

  def build_result3(result, word_translated, start_time, end_time, attempt)
    result[:message] = MESSAGES[:message3]
    result[:translation] = word_translated
    result[:time] = (end_time - start_time).to_i / 1000000
    result[:score] = attempt.length
    return result
  end

  def run_game(attempt, grid, start_time, end_time)
    word_translated = parser(attempt)
    result = {}
    if !attempt.upcase.split("").all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
      result = build_result1(result)
    elsif attempt == word_translated
      result = build_result2(result)
    else
      result = build_result3(result, word_translated, start_time, end_time, attempt)
    end
    return result
  end

end
