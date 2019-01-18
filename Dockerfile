FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
RUN mkdir -p /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
