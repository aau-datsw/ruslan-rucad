class MatchesController < ApplicationController
  include ChallongeMatches

  before_action :set_servers

  def index
    @matches = fetch_challonge_matches
  end

  def show
    m = Challonge::Match.find(params[:id], params: { tournament_id: ENV['TOURNAMENT_ID'] })

    render json: {
      matchid: m.id.to_s,
      num_maps: 1,
      players_per_team: 1,
      side_type: :always_knife,
      maplist: %w[
        de_cache
        de_dust2
        de_inferno
        de_mirage
        de_nuke
        de_overpass
        de_train
      ],
      team1: {
        name: m.player1.display_name,
        tag: m.player1.display_name.gsub(' ', '_'),
        logo: 'v',
        flag: :DK,
        players: []
      },
      team2: {
        name: m.player2.display_name,
        tag: m.player2.display_name.gsub(' ', '_'),
        logo: 'v2',
        flag: :DK,
        players: []
      },
      cvars: {
        get5_check_auths: '0'
      }

    }.to_json
  end

  def start
    @match = Challonge::Match.find(params[:id], params: { tournament_id: ENV['TOURNAMENT_ID'] })
    @server = Server.find(params[:server_id])

    # TODO: Fix attachment with connect url
    # @match.attachments.create(link: "steam://connect/#{@server.hostname}/#{@server.password}")

    rcon = RconService.new(server: @server)
    rcon.run("get5_loadmatch_url #{ENV.fetch('PUBLIC_HOSTNAME', '')}/matches/#{@match.id}.json") do |_i, o, e, _t|
      flash[:success] = o.read.chomp
      flash[:error] = e.read.chomp
    end

    redirect_back fallback_location: root_path
  end

  def clear_cache
    Rails.cache.clear
    @matches = fetch_challonge_matches

    render partial: 'server_sending', layout: false
  end

private

  def set_servers
    @servers = Server.all
  end
end
