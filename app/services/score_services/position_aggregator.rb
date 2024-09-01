module ScoreServices
  class PositionAggregator 
    
    def initialize(player_scores)
      @player_scores = player_scores
    end

    def determine_positions
      position = 1
      position_hash = {}
      position_array = @player_scores.chunk_while{ |i, j| i[1] == j[1] }.to_a
      position_array.each do |p|
        position_hash["#{position}"] = p
        position +=p.count
      end
      position_hash
    end
  end
end
