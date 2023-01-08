FROM ruby:latest
WORKDIR /app
COPY . .
ENTRYPOINT [ "ruby", "dirbreaker.rb"]