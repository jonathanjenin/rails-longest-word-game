class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split

    # Check word and collect data from dictionary
    input_data = {}
    if @word.upcase.chars.all? { |letter| @word.upcase.chars.count(letter) <= @letters.count(letter) }
      file_path = "https://wagon-dictionary.herokuapp.com/#{@word}"
      serialized_data = URI.open(file_path).read
      input_data = JSON.parse(serialized_data)
    else
      input_data = { 'found' => 'nig' }
    end

    # Compute score
    @score = {}
    case input_data['found']
    when true
      @score[:score] = input_data['length'] * 10
      @score[:message] = 'Well done!'
    else
      @score[:score] = 0
      input_data['found'] == false ? @score[:message] = "#{@word} is not an english word" : @score[:message] = "#{@word} is not in the grid"
    end
  end
end
