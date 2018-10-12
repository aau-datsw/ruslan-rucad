FROM ruby:2.5.1-slim
MAINTAINER Frederik Spang <frederik at progras.dk>

RUN apt-get update \
  && apt-get install -qq -y build-essential curl git gnupg unzip cmake check libglib2.0-dev --fix-missing --no-install-recommends \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update \
  && apt-get install -qq -y nodejs --no-install-recommends

ADD https://github.com/n0la/rcon/archive/master.zip rcon.zip
RUN unzip rcon.zip -d . \
  && cd rcon-master \
  && mkdir build \
  && cd build \
  && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DINSTALL_BASH_COMPLETION=OFF \
  && make \
  && make install

RUN mkdir -p /app
WORKDIR /app

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 5

COPY . ./

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
