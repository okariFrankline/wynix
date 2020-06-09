# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wynix,
  ecto_repos: [Wynix.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :wynix, WynixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b/VBDDJn6luW8xGNJrs3LN5zJBKhq8FN1tPZg/cIY1SieD6VKfeTJKiRxkL2w+dc",
  render_errors: [view: WynixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Wynix.PubSub,
  live_view: [signing_salt: "J6Azkyfa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
