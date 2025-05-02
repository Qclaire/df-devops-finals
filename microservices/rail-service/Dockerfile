
FROM ruby:3.2-slim


RUN apt-get update -qq && apt-get install -y build-essential


WORKDIR /app


RUN mkdir -p tmp/pids log app/controllers config/environments


COPY Gemfile* ./
RUN bundle install


COPY . .


RUN chmod +x bin/*


EXPOSE 3000


CMD ["bin/rails", "server", "-b", "0.0.0.0"]