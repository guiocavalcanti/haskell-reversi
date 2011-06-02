class Reversi < Sinatra::Base
  set :static, true
  set :public, 'public'

  Tilt.register :erb, Tilt[:erubis]

  @@symbol = { "black" => "X", "white" => "O", "empty" => "E" }
  @@color = { "X" => "black", "O" => "white", "E" => "empty" }

  # Shows the login page
  get '/' do
    erubis :index
  end

  # Creates a new room_id
  post '/' do
    db = connect_db
    room_id = generate_name
    color = @@symbol[params[:color]]

    db.transaction do
      db[room_id] = []
      db[room_id] << { :color => color,
                       :board => new_board, :id => room_id, :first => true }
    end

    redirect to("/#{room_id}")
  end

  # Builds a new board
  get %r{(\w{4})$} do |room_id|
    db = connect_db
    @room = load_room_if_possible room_id, db

    if @room.fetch(:first, false)
      db.transaction do
        opposite = (@room[:color].eql? "X") ? "O" : "X"
        db[room_id] << @room.merge({:first => false, :color => opposite })
      end
    end

    erubis :room
  end

  # Make a move
  post %r{(\w{4})\/play$} do |room_id|
    db = connect_db
    @room = load_room_if_possible room_id, db

    make_move params[:board], params[:move]
  end

  protected

  def load_room_if_possible(room_id, db = nil)
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
    result = `reversi-cmd play '#{board}' '#{move}'`
    result
  end

  # Database setup
  def connect_db
    db = PStore.new("reversi.db")
  end
end
