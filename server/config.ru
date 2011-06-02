require 'rubygems'
require 'bundler'
require 'pstore'

Bundler.require
Pusher.app_id = '5854'
Pusher.key = '61be5260c07cf1d9e396'
Pusher.secret = '7d911d31825d0801812b'

require './server'
run Reversi
