class Reversi < Sinatra::Base
  set :static, true
  set :public, 'public'

  Tilt.register :erb, Tilt[:erubis]

  # Shows the login page
  get '/' do
    erubis :index
  end

  # Creates a new room_id
  post '/' do
    db = connect_db
    room_id = generate_name

    db.transaction do
      db[room_id] = []
      db[room_id] << { :color => params[:color], :board => new_board, :id => room_id }
    end

    redirect to("/#{room_id}")
  end

  # Builds a new board
  get %r{(\w{4})$} do |room_id|
    @room = load_room_if_possible room_id
    erubis :room
  end

  # Make a move
  post %r{(\w{4})\/play$} do |room_id|
    db = connect_db
    @room = load_room_if_possible db, room_id

    # If isnt your time, you wont play
    return @room[:board] if @room[:color] == params[:color]

    make_move @room[:board], @params[:move]
  end

  protected

  def load_room_if_possible(db, room_id)
    db = connect_db unless db
    @room = {}
    db.transaction do
      @room = db[room_id] ? db[room_id].last : {}
    end

    redirect to("/") if @room.empty?

    return @room
  end

  # Generates a new room name
  def generate_name
    (0...4).map{ ('a'..'z').to_a[rand(26)] }.join
  end

  # Generates a new board
  def new_board
    `reversi-cmd ""`.to_json
  end

  # Makes a move on the given board
  def make_move(board, move)
    `reversi-cmd #{board} #{move}`
  end

  # Database setup
  def connect_db
    db = PStore.new("reversi.db")
  end
end
