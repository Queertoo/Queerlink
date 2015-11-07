# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :queerlink,
  host: "http://localhost"

config :sugar,
  router: Queerlink.Router

config :sugar, Queerlink.Router,
  https_only: false,
  http: [ port: 4000, ip: {127,0,0,1} ],
  https: false

config :queerlink, Queerlink.Repo,
  adapter: Sqlite.Ecto,
  database: "priv/links.sqlite3"
