import Config

config :ex_money,
  default_cldr_backend: Money.Cldr,
  json_library: Jason,
  exchange_rates: [
    api_module: Money.ExchangeRates.OpenExchangeRates,
    callback_module: Money.ExchangeRates.Callback,
    cache_module: Money.ExchangeRates.Cache.Dets,
    auto_start: false,
    retrieve_every: 300_000,
    # preload_historic_rates: {~D[2017-01-01], ~D[2017-01-02]},
    log_level_success: :info,
    log_level_failure: :warning,
    log_level_info: :info,
    verify_peer: true
  ],
  open_exchange_rates_app_id: {:system, "OPEN_EXCHANGE_RATES_APP_ID"}

config :ex_cldr,
  default_backend: Money.Cldr
