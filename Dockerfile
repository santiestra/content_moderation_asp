FROM ruby:2.5.5

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
ENV RACK_ENV production
RUN gem install bundler -v 2.0.2
RUN bundle install --system

ADD . /app
RUN bundle install --system

EXPOSE 4567

CMD ["ruby", "main.rb"]
