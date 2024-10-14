# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :app,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hh4TNfjvaX9BbWOvhz7h4vOjwom1T6HIvSLqXgm1dd6tYyqDZYN/qsB3ELf9JQgb",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "yvN71r0P"]

# Configure swagger
config :app, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: AppWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: AppWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

config :phoenix, :json_library, Jason # Use Jason for JSON parsing in Phoenix

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure the Cors
config :cors_plug,
  origin: ["http://localhost:5173", "http://34.163.87.178:5173", "http://time-manager.io:80", "*"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
