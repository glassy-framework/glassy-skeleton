FROM crystallang/crystal:latest

RUN apt-get update \
    && apt-get install -y libmongoc-dev libmongoc-1.0-0 libmongoclient-dev wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN cd /tmp \
    && wget https://github.com/watchexec/watchexec/releases/download/1.14.0/watchexec-1.14.0-x86_64-unknown-linux-gnu.tar.xz \
    && tar -xf watchexec-1.14.0-x86_64-unknown-linux-gnu.tar.xz \
    && mv watchexec-1.14.0-x86_64-unknown-linux-gnu/watchexec /usr/bin \
    && rm -rf watchexec-1.14.0-x86_64-unknown-linux-gnu && rm watchexec-1.14.0-x86_64-unknown-linux-gnu.tar.xz

WORKDIR /code
