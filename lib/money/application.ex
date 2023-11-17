defmodule Money.Application do
  use Application
  alias Money.ExchangeRates
  require Logger

  @auto_start :auto_start_exchange_rate_service

  def start(_type, args) do
    children = [
      Money.ExchangeRates.Supervisor
    ]

    opts =
      if args == [] do
        [strategy: :one_for_one, name: Money.Supervisor]
      else
        args
      end

    supervisor = Supervisor.start_link(children, opts)

    if start_exchange_rate_service?() do
      ExchangeRates.Supervisor.start_retriever()
    end

    supervisor
  end

  # Default is to not start the exchange rate service
  defp start_exchange_rate_service? do
    maybe_log_deprecation()

    start? = Money.get_env(@auto_start, true, :boolean)
    api_module = ExchangeRates.default_config().api_module
    api_module_present? = Code.ensure_loaded?(api_module)

    if !api_module_present? do
      Logger.error(
        "[ex_money] ExchangeRates api module #{api_module_name(api_module)} could not be loaded. " <>
          "Does it exist?"
      )

      Logger.warning("ExchangeRates service will not be started.")
    end

    start? && api_module_present?
  end

  defp api_module_name(name) when is_atom(name) do
    name
    |> Atom.to_string()
    |> String.replace_leading("Elixir.", "")
  end

  @doc false
  def maybe_log_deprecation do
    handle_removed_env(:delay_before_first_retrieval)
    handle_updated_env(:exchange_rate_service, :auto_start_exchange_rate_service)
  end

  defp handle_removed_env(old) do
    case Application.fetch_env(:ex_money, old) do
      {:ok, _} ->
        Logger.warning(
          "[ex_money] Configuration option #{inspect(old)} is deprecated. " <>
            "Please remove it from your configuration."
        )

        Application.delete_env(:ex_money, old)

      :error ->
        nil
    end
  end

  defp handle_updated_env(old, new) when is_atom(new) do
    case Application.fetch_env(:ex_money, old) do
      {:ok, env} ->
        Logger.warning(
          "[ex_money] Configuration option #{inspect(old)} is deprecated " <>
            "in favour of #{inspect(new)}. " <>
            "Please update your configuration."
        )

        Application.put_env(:ex_money, new, env)
        Application.delete_env(:ex_money, old)

      :error ->
        nil
    end
  end

  defp handle_updated_env(old, {scope, new}) do
    case Application.fetch_env(:ex_money, old) do
      {:ok, env} ->
        Logger.warning(
          "[ex_money] Configuration option #{inspect(old)} is deprecated " <>
            "in favour of #{scope}: [#{new}: ...]. " <>
            "Please update your configuration."
        )

        updated_envs =
          :ex_money
          |> Application.get_env(scope, [])
          |> Keyword.put(new, env)

        Application.put_env(:ex_money, scope, updated_envs)
        Application.delete_env(:ex_money, old)

      :error ->
        nil
    end
  end
end
