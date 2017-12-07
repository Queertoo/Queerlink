use Mix.Config

# General application configuration
config :queerlink,
  ecto_repos: [Queerlink.Repo]

# Configures the endpoint
config :queerlink, QueerlinkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lJ45LkYUsB2FxQQWWQATztvbln4TyZZSPtm/esGoCdMN5nHxleKP1CVwTIkLW48I",
  render_errors: [view: QueerlinkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Queerlink.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
