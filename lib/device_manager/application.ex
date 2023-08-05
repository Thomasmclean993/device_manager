defmodule DeviceManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DeviceManagerWeb.Telemetry,
      # Start the Ecto repository
      DeviceManager.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DeviceManager.PubSub},
      # Start Finch
      {Finch, name: DeviceManager.Finch},
      # Start the Endpoint (http/https)
      DeviceManagerWeb.Endpoint
      # Start a worker by calling: DeviceManager.Worker.start_link(arg)
      # {DeviceManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DeviceManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DeviceManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
