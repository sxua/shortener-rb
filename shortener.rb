class Shortener < Sinatra::Base
  URL_REGEX = %r{^http(s)?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$}

  before do
    @alpha = [("a".."z"), ("A".."Z"), ("0".."9")].map(&:to_a).flatten
    redis_options = {host: "localhost", port: 6379}
    unless ENV["REDISTOGO_URL"].nil?
      uri = URI.parse(ENV["REDISTOGO_URL"])
      redis_options = {host: uri.host, port: uri.port, password: uri.password}
    end
    @redis = Redis.new redis_options
  end

  helpers do
    def url path = ""
      ["http://#{request.host_with_port}", path].join("/")
    end
  
    def code_for id
      code, base = "", @alpha.length
      while id > 0
        code << @alpha[id % base]
        id /= base
      end
      code.reverse
    end
  
    def get_url code
      id = 0
      code.to_s.each_char { |c| id = id * @alpha.length + @alpha.index(c) }
      @redis.get "shortener:id:#{id}"
    end
  
    def get_visits code
      @redis.get "shortener:newcode:#{code}"
    end

    def put_url url
      existing_code = @redis.get("shortener:url:#{url}")
      unless existing_code
        id = next_free_id
        code = code_for(id)
        @redis.set "shortener:id:#{id}", url
        @redis.set "shortener:url:#{url}", code
        code
      else
        existing_code
      end
    end
  
    def next_free_id
      id = rand(@alpha.length ** 6)
      @redis.get("shortener:id:#{id}") ? next_free_id : id
    end
  end

  get "/" do
    erb :index, layout: :application
  end

  get "/:code+" do
    erb :stat, layout: :application
  end

  get "/:code" do
    @redis.incr "shortener:code:#{params[:code]}"
    redirect get_url(params[:code])
  end

  post "/u" do
    erb :url
  end
end
