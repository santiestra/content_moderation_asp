require 'sinatra'
require 'json'
require 'bunny'

bad_words = ['hola', 'spam', 'test']

conn = Bunny.new('amqp://guest:guest@localhost:5672')
conn.start

channel = conn.create_channel
exchange = channel.fanout('aspost.moderation')
x = channel.default_exchange

channel.queue('listen.moderation', :auto_delete => true)
  .bind(exchange).subscribe do |delivery_info, metadata, payload|
  content = JSON.parse(payload)['content']

  contains_bad_words = false

  bad_words.each do |word|
    contains_bad_words = content.include?(word) unless contains_bad_words
  end

  p content
  puts contains_bad_words

  if contains_bad_words
    body = { contains_bad_words: contains_bad_words }.to_json
    x.publish(body)
  end
end

# post '/api/v1/moderations' do
#   content_type :json

#   bad_words = ['hola', 'spam', 'test']

#   data = JSON.parse(request.body.read.to_s)


# end


