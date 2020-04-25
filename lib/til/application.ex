defmodule Til.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    setup()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Til.PubSub},
      # Start the Ecto repository
      supervisor(Til.Repo, []),
      # Start the endpoint when the application starts
      supervisor(TilWeb.Endpoint, []),
      # Start your own worker by calling: Til.Worker.start_link(arg1, arg2, arg3)
      # worker(Til.Worker, [arg1, arg2, arg3]),
      {Cluster.Supervisor, [cluster_topologies(), [name: Til.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Til.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TilWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp cluster_topologies do
    enabled = Application.get_env(:til, :cluster_enabled)
    topologies = Application.get_env(:til, :cluster_topologies)

    if enabled, do: topologies, else: []
  end

  defp setup do
    TilWeb.PipelineInstrumenter.setup()
    TilWeb.Repo.Instrumenter.setup()
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    TilWeb.MetricsExporter.setup()

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [:til, :repo, :query],
        &TilWeb.Repo.Instrumenter.handle_event/4,
        %{}
      )
  end
end
