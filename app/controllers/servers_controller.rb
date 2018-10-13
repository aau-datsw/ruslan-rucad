class ServersController < ApplicationController
  before_action :find_server, only: [:edit, :update, :destroy]

  def index
    @servers = Server.all
  end

  def new
    @server = Server.new
  end

  def edit
  end

  def create
    @server = Server.create!(server_params)
    redirect_to servers_path(@server)
  end

  def update
    @server.update!(server_params)
    redirect_to servers_path(@server)
  end

  def destroy
    @server.destroy
    redirect_to servers_path(@server)
  end

  private

  def find_server
    @server = Server.find(params[:id]) if params[:id]
  end

  def server_params
    params.require(:server).permit(:name, :ip, :port, :tv_port)
  end
end
