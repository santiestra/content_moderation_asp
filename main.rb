require 'sinatra'
require 'json'

post '/api/v1/moderations' do
  content_type :json

  bad_words = ['hola', 'spam', 'test']

  data = JSON.parse(request.body.read.to_s)

  content = data['content']

  contains_bad_words = false

  bad_words.each do |word|
    contains_bad_words = content.include?(word) unless contains_bad_words
  end

  { contains_bad_words: contains_bad_words }.to_json
end
