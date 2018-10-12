class ApplicationController < ActionController::Base
  def index
    @matches = Challonge::Match.find(:all, params: { state: :open, tournament_id: ENV["TOURNAMENT_ID"] }).sort_by(&:round)
    @servers = [
      { ip: '1.2.3.4', port: 27010 },
      { ip: '1.2.3.4', port: 27020 },
      { ip: '1.2.3.4', port: 27030 },
      { ip: '1.2.3.4', port: 27040 },
    ]
  end

  def start
    @match = Challonge::Match.find(params[:match_id], params: { tournament_id: ENV["TOURNAMENT_ID"] })
    @server = { ip: params[:server_ip].split(':').first, port: params[:server_ip].split(':').last }

    # TODO: Fix attachment with connect url
    #@match.attachments.create(link: "steam://connect/#{@server.hostname}/#{@server.password}")

    flash[:success] = system("rcon -H #{@server[:ip]} -p #{@server[:port]} get5_load_match_url http://spang.eu.ngrok.io/matches/#{@match.id}.json")
    redirect_back fallback_location: root_path
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
end
