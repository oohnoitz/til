# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason

# General application configuration
config :til,
  ecto_repos: [Til.Repo]

# Configures the endpoint
config :til, TilWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cDWwdT0MXe1ptKM9Qr8q1OMDpI3rByRdxkyDrrGii/B6i96gv1hVOoBGQlS6yWrE",
  render_errors: [view: TilWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Til.PubSub,
  live_view: [
    signing_salt: "ewwsJ/6p"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rollbax,
  enabled: false,
  environment: "dev"

config :til, Til.Mailer, adapter: Bamboo.LocalAdapter

config :bamboo, :json_library, Jason

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :til, jwt_secret: "secret"

# see releases.exs for production config
config :til, cluster_topologies: []

config :til, email: {"TIL", "til@0x0.pt"}

config :til, :pow,
  user: Til.User,
  repo: Til.Repo,
  web_module: TilWeb,
  mailer_backend: Til.Mailer,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_mailer_module: TilWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
