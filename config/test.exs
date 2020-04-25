use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :til, TilWeb.Endpoint,
  http: [port: 4001],
  server: true

config :til, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :til, Til.Repo,
  username: "postgres",
  password: "postgres",
  database: "til_test",
  hostname: "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool: Ecto.Adapters.SQL.Sandbox,
  types: Til.PostgresTypes

config :til, Til.Mailer, adapter: Bamboo.TestAdapter

config :til,
  s3_signer: Til.S3Signer.Mock

  config :hound,
  driver: "selenium",
  browser: "chrome",
  app_port: 4001,
  genserver_timeout: 480_000

config :cabbage,
  features: "test/integration/feature_files/"
