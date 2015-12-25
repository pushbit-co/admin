FROM ruby:latest
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
WORKDIR /admin
ADD . /admin
RUN bundle install

CMD ["./script/admin.sh"]
