# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :live_view_counter, LiveViewCounterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s0e+LZ/leTtv3peHaFhnd2rbncAeV5qlR1rNShKXDMSRbVgU2Aar8nyXszsQrZ1p",
  render_errors: [view: LiveViewCounterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveViewCounter.PubSub,
  live_view: [signing_salt: "iluKTpVJp8PgtRHYv1LSItNuQ1bLdR7c"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Necessary to tell OpenTelemetry what repository to report traces for
config :geometrics, :ecto_prefix, [:my_app, :repo]

# Configuring a custom logger Geometrics.OpenTelemetry.Logger to help export process crashes to OpenTelemetry, which aren't reported by default
config :logger,
       backends: [
         :console,
         Geometrics.OpenTelemetry.Logger
       ]

# The service name will show up in each span in your metrics service (i.e. Honeycomb)
config :opentelemetry, :resource,
       service: [
         name: "app counter backend"
       ]

# Configure with the endpoint accessible by the clients browser
config :geometrics, :collector_endpoint, "http://127.0.0.1:55681/v1/trace"

config :opentelemetry,
       processors: [
         otel_batch_processor: %{
           exporter: {
             :opentelemetry_exporter,
             %{endpoints: [{:http, '0.0.0.0', 55_681, []}]}
           }
         }
       ]
