# URL shortener based on Sinatra + Redis
This is an example of URL shortener service in Ruby.

## Dependencies
* Redis 1.2+ (if you have and older version you need to comment out this lines):

```ruby
require 'hiredis' # speeds up the redis, works only with Redis 1.2+
require 'redis/connection/hiredis' # defining Hiredis backend for redis-rb
```
* Ruby with this gems:

```ruby
gem install sinatra
gem install redis
gem install hiredis
gem install json (optional)
```

## Running
Just exec `ruby shortener.rb` and point your browser to `http://localhost:4567/` for shortener form.

    $ ruby shortener.rb
    [2011-12-05 18:40:46] INFO  WEBrick 1.3.1
    [2011-12-05 18:40:46] INFO  ruby 1.8.7 (2011-02-18) [i686-darwin11.2.0]
    == Sinatra/1.3.1 has taken the stage on 4567 for development with backup from WEBrick
    [2011-12-05 18:40:46] INFO  WEBrick::HTTPServer#start: pid=36997 port=4567

## JSON
If you want to get response as JSON, add `require 'json'` at the top of `shortener.rb` and

```ruby
post '/u' do
  content_type :json
  {:url_or_whatever => put_url(params[:url])}
end
```

instead of similar block at the bottom.