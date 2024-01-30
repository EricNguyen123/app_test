
FROM ruby:3.2.2
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app_test
WORKDIR /app_test
ADD Gemfile /app_test/Gemfile
ADD Gemfile.lock /app_test/Gemfile.lock
ENV BUNDLE_PATH /gems
RUN bundle install
COPY . /app_test

ENTRYPOINT [ "bin/rails" ]
CMD [ "s", "-b", "0.0.0.0" ]
EXPOSE 3000


