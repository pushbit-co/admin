#!/bin/bash -e

if [ $RACK_ENV = "development" ]
then
  bundle check || bundle install
fi

bundle exec rake db:migrate
bundle exec rackup -p ${1:-8081}


