# URL shortener based on Sinatra + Redis
This is an example of URL shortener service in Ruby.

## Dependencies
* Redis 1.2+ (if you have and older version you need to comment out this lines):

```ruby
require "hiredis" # speeds up the redis, works only with Redis 1.2+
require "redis/connection/hiredis" # defining Hiredis backend for redis-rb
```
* Ruby with this gems:

```ruby
bundle install
```

## Running
Just exec `rackup` and point your browser to `http://localhost:9292/` for shortener form.

## JSON
If you want to get response as JSON, add `require 'json'` at the top of `shortener.rb` and

```ruby
post "/u" do
  content_type :json
  {url_or_whatever: put_url(params[:url])}
end
```

instead of similar block at the bottom.