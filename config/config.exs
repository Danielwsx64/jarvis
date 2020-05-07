use Mix.Config

# Configure Mix tasks and generators
config :jarvis,
  ecto_repos: [Jarvis.Repo]

config :jarvis_web,
  ecto_repos: [Jarvis.Repo],
  generators: [context_app: :jarvis, binary_id: true]

# Configures the endpoint
config :jarvis_web, JarvisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C7dhcwGV4q57QPyyS/TQxNoAyPWLXpH0z+4XIk/zFxP5L/ZcL+S+CgzPew6R5a5f",
  render_errors: [view: JarvisWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Jarvis.PubSub,
  live_view: [signing_salt: "CoS0sFY6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
