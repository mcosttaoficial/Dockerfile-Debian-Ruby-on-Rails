# Install base image
FROM debian:latest

# Update and install dependencies
RUN apt-get update
RUN apt-get install ruby-full -y
RUN apt-get install build-essential libssl-dev libreadline-dev zlib1g-dev libyaml-dev git -y  puma

# Create user app
RUN adduser --disabled-password --gecos "" app
RUN chmod -R 777 /var/lib/gems/ && chmod -R 777 /usr/local/bin/

# Defina o ambiente
ENV RAILS_ENV=development
ENV RACK_ENV=development

# Install Ruby on Rails
USER app
RUN gem install bundler
RUN gem install rails

# Config server rails
RUN mkdir -p /home/app/myapp
WORKDIR /home/app/myapp
USER root
RUN rails new app
WORKDIR /home/app/myapp/app
RUN bundle install
RUN gem update
RUN bundle update --bundler
RUN rails db:create
RUN rails db:migrate

# Expose port 3000
EXPOSE 3000

# Start Server Rails
CMD ["rails", "server", "-b", "0.0.0.0"]