require 'rubygems'
require 'sinatra'
require 'hiredis' # speeds up the redis, works only with 1.2+
require 'redis/connection/hiredis' # defining Hiredis backend for redis-rb
require 'redis'

ALPHA = %w(D A S C X 7 s t 8 z P W M 3 L R G B c T d x I 1 F p 5 m n r 9 Y K 2 k O q v o Q E g U f e V i H u j y J N a b Z h l 6 4 0 w)
# ALPHA is shuffled [a-zA-Z0-9] array (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.map(&:to_s)
REDIS = Redis.new
HOST = 'localhost:4567'
# Where's your shortener hosted?

def code_for id
  return ALPHA.first if id == 0
  code, base = '', ALPHA.length
  while id > 0
    code << ALPHA[id % base]
    id /= base
  end
  code.reverse
end

def get_url code
  code, id, base = code.to_s, 0, ALPHA.length
  code.each_char {|c| id = id * base + ALPHA.index(c)}
  REDIS.get "shorturl:#{code}:#{id}"
end

def put_url url
  id = REDIS.incr "url.shortener.id"
  code = code_for(id)
  REDIS.set "shorturl:#{code}:#{id}", url
  code
end

get '/' do
  erb :index
end

get '/c/:code' do
  redirect get_url(params[:code])
end

post '/u' do
  html = params[:html] || false
  code = put_url(params[:url])
  html ? %Q{<p>Here's your URL: <a href="http://#{HOST}/c/#{code}">http://#{HOST}/c/#{code}</a></p>} : "http://#{HOST}/c/#{code}"
end