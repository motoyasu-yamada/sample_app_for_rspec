FROM ruby:2.6.4
ADD . /runteq
WORKDIR /runteq
SHELL ["/bin/bash", "-c"]
ENTRYPOINT [ "/bin/bash" ]
EXPOSE 3000
# https://maku77.github.io/docker/term-error.html
ENV DEBIAN_FRONTEND noninteractive

# WORKING USER
ARG DOCKER_UID=1000
ARG DOCKER_USER=runteq
ARG DOCKER_PASSWORD=runteq
RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd
# USER ${DOCKER_USER}

# INIT
RUN apt-get -y update
RUN apt-get -y install build-essential git-core apt-utils vim

# bundler
RUN apt-get install -y bundler
RUN gem install bundler:2.1.4

# YARN
RUN apt-get -y remove cmdtest
RUN apt-get -y remove yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update 
RUN apt-get -y install yarn

# rbenv
RUN apt-get remove rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN source ~/.bashrc
RUN ~/.rbenv/bin/rbenv init -
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN mkdir -p ~/.rbenv/plugins
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

# nodeenv
RUN apt-get remove nodeenv
RUN git clone https://github.com/OiNutter/nodenv /usr/local/nodenv
RUN echo 'export NODENV_ROOT=/usr/local/nodenv' >> ~/.bashrc
RUN echo 'export PATH=$NODENV_ROOT/bin:$PATH' >> ~/.bashrc
RUN source ~/.bashrc
RUN echo 'eval "$(nodenv init -)"'  >> ~/.bashrc
RUN mkdir -p /usr/local/nodenv/plugins
RUN git clone https://github.com/OiNutter/node-build /usr/local/nodenv/plugins/node-build

# Google chrome
RUN /bin/bash -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# sqlite3
RUN apt-get install -y sqlite3
