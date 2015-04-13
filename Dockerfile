FROM rails:onbuild

ADD . /rails/medirectory
WORKDIR /rails/medirectory

RUN bundle install
RUN rake db:migrate

EXPOSE 3000
