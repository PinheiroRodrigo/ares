use Mix.Config

config :ares,
  ecto_repos: [Ares.Repo]

config :ares, Ares.Repo,
  database: "ares_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
