class Player 

  attr_accessor(:score, :name, :token)

  def initialize(name, token)
    @name = name
    @token = token
    @score = 0
  end
  
end