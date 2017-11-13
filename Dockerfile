FROM ruby:2.3

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    && rm -rf /var/lib/apt/listss

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD rails server -b 0.0.0.0