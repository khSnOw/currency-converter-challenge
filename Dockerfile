# the official image for ruby
FROM ruby:2.5

# setting the working directory
WORKDIR /usr/src/app

# install bundler and update
RUN gem update --system
RUN gem install bundler
# copy all files
COPY . .
# install dependencies
RUN bundle install
# for dev env to watch rb files
RUN gem install rerun

# expose this port to avoid confusion i choosed this number 8484
EXPOSE 8484