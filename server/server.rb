class Reversi < Sinatra::Base
  Tilt.register :erb, Tilt[:erubis]

  # Shows the login page
  get '/' do
    erubis :index
  end

  post '/' do
    redirect to("/#{generate_name}")
  end

  get %r(\w{4}$) do
    @teste = "abc"
    erubis :room
  end

  protected

  # Generates a new room name
  def generate_name
    (0...4).map{ ('a'..'z').to_a[rand(26)] }.join
  end
end
