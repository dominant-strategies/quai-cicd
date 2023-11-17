FROM elixir:1.12

WORKDIR /app

COPY ./ .

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

CMD ["mix", "run"]

