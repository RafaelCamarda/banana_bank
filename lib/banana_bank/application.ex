defmodule BananaBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BananaBankWeb.Telemetry,
      # Start the Ecto repository
      BananaBank.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BananaBank.PubSub},
      # Start the Endpoint (http/https)
      BananaBankWeb.Endpoint
      # Start a worker by calling: BananaBank.Worker.start_link(arg)
      # {BananaBank.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BananaBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BananaBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
