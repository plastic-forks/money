import Config

config :ex_money, Money.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "kip",
  database: "money_dev",
  hostname: "localhost",
  pool_size: 10

config :ex_money, ecto_repos: [Money.Repo]

config :ex_money,
  default_cldr_backend: Test.Cldr,
  exchange_rates: [
    api_module: Money.ExchangeRates.Api.Test,
    retrieve_every: :never,
    log_level_success: nil,
    log_level_failure: nil,
    log_level_info: nil
  ],
  open_exchange_rates_app_id: {:system, "OPEN_EXCHANGE_RATES_APP_ID"}
