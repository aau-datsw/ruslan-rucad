module ChallongeMatches
  extend ActiveSupport::Concern

  def fetch_challonge_matches
    Rails.cache.fetch("challonge_matches_#{ENV['TOURNAMENT_ID']}", expires_in: 10.minutes) do
      Rails.logger.debug 'Fetching ChallongeMatches cache'
      Challonge::Match.find(:all, params: { state: :open, tournament_id: ENV['TOURNAMENT_ID'] }).sort_by(&:round)
      array = []
      Challonge::Match.find(:all, params: { state: :open, tournament_id: ENV['TOURNAMENT_ID'] }).each do |match|
        array << match.as_json['match'].merge(
          player1: match.player1.as_json['participant'],
          player2: match.player2.as_json['participant']
        )
      end

      array.map(&:with_indifferent_access)
    end
  end
end
