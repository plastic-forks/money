defmodule Money.ExchangeRates.Config do
  @moduledoc """
  Defines the configuration for the exchange rates.
  """
  @type t :: %__MODULE__{
          api_module: module() | nil,
          callback_module: module() | nil,
          cache_module: module() | nil,
          auto_start: boolean(),
          retrieve_every: non_neg_integer | nil,
          retriever_options: map() | nil,
          preload_historic_rates: Date.t() | Date.Range.t() | {Date.t(), Date.t()} | nil,
          log_levels: map(),
          verify_peer: boolean()
        }

  defstruct api_module: nil,
            callback_module: nil,
            cache_module: nil,
            auto_start: true,
            retrieve_every: nil,
            retriever_options: nil,
            preload_historic_rates: nil,
            log_levels: %{},
            verify_peer: true

  @default_api_module Money.ExchangeRates.OpenExchangeRates
  @default_callback_module Money.ExchangeRates.Callback
  @default_cache_module Money.ExchangeRates.Cache.Ets
  @default_auto_start true
  @default_retrieve_every :never

  @doc """
  Returns the configuration for the exchange rates.
  """
  def new() do
    %__MODULE__{
      api_module: get_env(:api_module, @default_api_module, :module),
      callback_module: get_env(:callback_module, @default_callback_module, :module),
      cache_module: get_env(:cache_module, @default_cache_module, :module),
      auto_start: get_env(:auto_start, @default_auto_start, :boolean),
      retrieve_every: get_env(:retrieve_every, @default_retrieve_every, :maybe_integer),
      preload_historic_rates: get_env(:preload_historic_rates, nil),
      log_levels: %{
        success: get_env(:log_level_success, nil),
        failure: get_env(:log_level_failure, :warning),
        info: get_env(:log_level_info, :info)
      },
      verify_peer: get_env(:verify_peer, true, :boolean)
    }
  end

  defp get_env(key, default), do: Money.get_env(:exchange_rates, key, default)
  defp get_env(key, default, type), do: Money.get_env(:exchange_rates, key, default, type)
end
