# Rubyのバージョンを指定した公式イメージをベースに使用
FROM ruby:3.2.3
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN curl -sL https://deb.nodesource.com/setup_19.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs yarn

# コンテナの作業ディレクトリを指定
RUN mkdir /myapp
WORKDIR /myapp

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY yarn.lock /myapp/yarn.lock

RUN gem install bundler

# bundle installを実行
RUN bundle install
RUN yarn install

# カレントディレクトリのファイルをコンテナにコピー
COPY . /myapp

# コンテナ起動時に実行されるスクリプトをコピーして実行可能にする
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# コンテナが外部に公開するポート番号を指定
EXPOSE 3000

# コンテナ起動時に実行されるメインプロセスを指定
CMD ["rails", "server", "-b", "0.0.0.0"]