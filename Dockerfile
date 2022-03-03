FROM ruby:3.0.2-alpine
RUN apk update \
      && apk add --no-cache gcc make libc-dev g++ mariadb-dev tzdata nodejs~=14 yarn 
WORKDIR /studylog
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --jobs=2
COPY . /studylog
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundole","exec","rails", "server", "-b", "0.0.0.0"]