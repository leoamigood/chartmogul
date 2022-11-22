FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \
    libvips42 \
    apt-utils \
    redis-tools \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/src/app
  
RUN gem update --system && gem install bundler -v 2.3.13

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3000
