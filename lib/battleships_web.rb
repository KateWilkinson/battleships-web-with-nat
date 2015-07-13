require 'sinatra/base'
require 'battleships'
#require 'ship'

class BattleshipsWeb < Sinatra::Base

  enable :sessions

  set :views, proc { File.join(root, '..', 'views')}

  get '/' do
    erb :index
  end

  get '/Start' do

    erb :start
  end

  get '/Welcome' do
    @name = params[:name]
    session[:name] = @name
    if $game
      session[:player] = 'player_2'
    else
      session[:player] = 'player_1'
    end
    erb :welcome
  end

  get '/New_Game' do
    $game = Game.new Player, Board
    @name = params[:name]
    p session[:player]
    erb :new_game
  end

  post '/New_Game' do
    @ship = params[:ship]
    @coordinates = params[:coordinates]
    @orientation = params[:orientation]
    begin
      session_player.place_ship Ship.new(@ship), @coordinates, @orientation
    rescue RuntimeError => @error
    end
    erb :new_game
  end

  post '/Gameplay' do

    @fire = params[:fire]
    if session_player.winner?
      redirect '/winner'
    end
    if @fire
      begin
      session_player.shoot @fire.to_sym
      rescue RuntimeError => @error
      end
    end
    erb :gameplay
  end

  get '/winner' do
    erb :winner
  end

  def session_player
    if session[:player] == 'player_1'
      $game.player_1
    else
      $game.player_2
    end
  end

  run! if app_file == $0
end
