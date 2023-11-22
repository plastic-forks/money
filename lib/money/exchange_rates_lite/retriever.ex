defmodule Money.ExchangeRatesLite.Retriever do
  @moduledoc """
  Specification of the exchange rates retriever.
  """

  alias Money.ExchangeRatesLite.Retriever.Config

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts], unquote: true do
      @schema_options opts[:schema_options] || []

      @behaviour unquote(__MODULE__)

      def schema_options(), do: @schema_options
    end
  end

  @type exchange_rates :: %{Money.currency_code() => Decimal.t()}
  @type reason :: any()
  @type result :: {:ok, exchange_rates()} | {:ok, :not_modified} | {:error, reason()}

  @doc """
  Gets the the latest exchange rates.
  """
  @callback get_latest_rates(Config.t()) :: result()

  @doc """
  Gets the historic exchange rates.
  """
  @callback get_historic_rates(Config.t(), Date.t()) :: result()

  @callback schema_options() :: NimbleOptions.schema()

  @doc false
  @spec get_latest_rates(Config.t()) :: result()
  def get_latest_rates(%Config{} = config) do
    config.adapter.get_latest_rates(config)
  end

  @doc false
  @spec get_historic_rates(Config.t(), Date.t()) :: result()
  def get_historic_rates(%Config{} = config, %Date{} = date) do
    config.adapter.get_historic_rates(config, date)
  end
end
