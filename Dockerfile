FROM ruby:2.2.3
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y build-essential 
RUN apt-get install -y libpq-dev 
RUN apt-get install -y nodejs
WORKDIR /admin
ADD . /admin
RUN bundle install

CMD ["./script/admin.sh"]
