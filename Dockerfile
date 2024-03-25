FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app_test
WORKDIR /app_test 
ADD Gemfile /app_test/Gemfile
ADD Gemfile.lock /app_test/Gemfile.lock


RUN chown -R $USER:$USER /app_test
RUN chmod -R 755 /app_test

RUN /bin/sh -c bundle install
COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh

ADD . /app_test
