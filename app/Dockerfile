FROM elixir:1.17.3-otp-27-alpine

RUN apk update && \
    apk add --no-cache build-base npm git

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN mix deps.get && \
    mix compile

# RUN mix ecto.migrate

RUN mix phx.digest

EXPOSE 4000

CMD ["mix", "phx.server"]
