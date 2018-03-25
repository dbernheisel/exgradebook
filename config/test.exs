use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :exgradebook, ExgradebookWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test

if System.get_env("VERBOSE") == "true" do
  config :logger, :console, format: "[$level] $message\n"
else
  config :logger, level: :warn
end

# Configure your database
config :exgradebook, Exgradebook.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  database: "exgradebook_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 30000,
  pool_size: :erlang.system_info(:schedulers_online),
  pool_overflow: :erlang.system_info(:schedulers_online)

config :wallaby,
  tmp_dir_prefix: "wallaby-exgradebook"
