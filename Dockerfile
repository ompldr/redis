FROM redis

WORKDIR /redis/modules

RUN apt-get update \
  && apt-get install -qq -y curl git build-essential \
  && curl https://sh.rustup.rs -sSf -o rustinstall \
  && sh rustinstall -y \
  && . $HOME/.cargo/env \
  && git clone https://github.com/brandur/redis-cell.git \
  && cd redis-cell \
  && cargo build --release \
  && cp target/release/libredis_cell.so /redis/modules \
  && cd /redis/modules && rm -rf /redis/modules/redis-cell \
  && apt-get remove --purge -qq -y curl git build-essential \
  && apt-get autoremove -qq -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /redis/modules/rustinstall \
  && rm -rf $HOME/.cargo/registry

COPY redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
