require 'open3'

class ApplicationController < ActionController::Base
  before_action :set_servers, only: [:index, :clear_cache]

  def index
    @matches = fetch_challonge_matches
  end

  def start
    @match = Challonge::Match.find(params[:match_id], params: { tournament_id: ENV["TOURNAMENT_ID"] })
    @server = { ip: params[:server_ip].split(':').first, port: params[:server_ip].split(':').last }

    # TODO: Fix attachment with connect url
    #@match.attachments.create(link: "steam://connect/#{@server.hostname}/#{@server.password}")

    Open3.popen3("rcon -H #{@server[:ip]} -p #{@server[:port]} get5_load_match_url http://spang.eu.ngrok.io/matches/#{@match.id}.json") {|i,o,e,t|
      flash[:success] = o.read.chomp
      flash[:error] = e.read.chomp
    }

    redirect_back fallback_location: root_path
  end

  def clear_cache
    Rails.cache.clear
    @matches = fetch_challonge_matches

    render partial: 'server_sending'
  end

  def match
    @match = Challonge::Match.find(params[:match_id], params: { tournament_id: ENV["TOURNAMENT_ID"] })

    render json: {
      matchid: @match.id.to_s,
      num_maps: 1,
      players_per_team: 5,
      maplist: [
        "de_cache",
        "de_dust2",
        "de_inferno",
        "de_mirage",
        "de_nuke",
        "de_overpass",
        "de_train"
      ],
      team1: {
        name: @match.player1.name,
        tag: @match.player1.name,
        players: []
      },
      team2: {
        name: @match.player2.name,
        tag: @match.player2.name,
        players: []
      },
      cvars: {
        get5_check_auths: "0"
      }

    }.to_json
  end

  private

  def fetch_challonge_matches
    Rails.cache.fetch("challonge_matches_#{ENV["TOURNAMENT_ID"]}", expires_in: 10.minutes ) do
      Rails.logger.debug "Fetching Cache"
      Challonge::Match.find(:all, params: { state: :open, tournament_id: ENV["TOURNAMENT_ID"] }).sort_by(&:round)
      array = []
      Challonge::Match.find(:all, params: { state: :open, tournament_id: ENV["TOURNAMENT_ID"] }).each do |match|
        array << match.as_json["match"].merge(
          player1: match.player1.as_json["participant"],
          player2: match.player2.as_json["participant"]
        )
      end

      array.map(&:with_indifferent_access)
    end
  end

  def set_servers
    @servers = [
      { name: 'RUSLAN#1', ip: '127.0.0.1', port: 27010 },
      { name: 'RUSLAN#2', ip: '127.0.0.1', port: 27020 },
      { name: 'RUSLAN#3', ip: '127.0.0.1', port: 27030 },
      { name: 'RUSLAN#4', ip: '127.0.0.1', port: 27040 },
    ]
  end
end
