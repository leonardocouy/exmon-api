# FROM elixir:latest

# RUN apt-get update && \
#   apt-get install -y postgresql-client

# # Create app directory and copy the Elixir projects into it.
# RUN mkdir /app
# COPY . /app
# WORKDIR /app

# # Install Hex package manager.
# # By using `--force`, we don’t need to type “Y” to confirm the installation.
# RUN mix local.hex --force

# # Compile the project.
# RUN mix do compile





FROM hexpm/elixir:1.13.3-erlang-24.2.2-alpine-3.15.0

WORKDIR /app

COPY mix.exs mix.lock

RUN mix local.hex --force && \
  mix local.rebar --force

RUN apk update \
  && apk add --no-cache bash postgresql-client ca-certificates inotify-tools \
  && update-ca-certificates

COPY . .

RUN mix do compile

CMD ["/app/entrypoint.sh"]
