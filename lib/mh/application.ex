defmodule Mh.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MhWeb.Telemetry,
      Mh.Repo,
      {DNSCluster, query: Application.get_env(:mh, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mh.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mh.Finch},
      Mh.Performance.ScreenState,
      # Start a worker by calling: Mh.Worker.start_link(arg)
      # {Mh.Worker, arg},
      # Start to serve requests, typically the last entry
      MhWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MhWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
