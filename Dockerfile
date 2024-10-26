FROM ghcr.io/gleam-lang/gleam:v1.5.1-erlang-alpine

# Add project code
COPY . /build/

# Compile the project
RUN cd /build \
  && gleam export erlang-shipment \
  && mv build/erlang-shipment /app \
  && rm -r /build

WORKDIR /app
COPY priv/static priv/static

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
