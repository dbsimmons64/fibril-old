defmodule Filament.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FilamentWeb.Telemetry,
      Filament.Repo,
      {DNSCluster, query: Application.get_env(:filament, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Filament.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Filament.Finch},
      # Start a worker by calling: Filament.Worker.start_link(arg)
      # {Filament.Worker, arg},
      # Start to serve requests, typically the last entry
      FilamentWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Filament.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FilamentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
