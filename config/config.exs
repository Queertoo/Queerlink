# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :sugar,
  router: Queerlink.Router

config :sugar, Queerlink.Router,
  https_only: false,
  http: [ port: System.get_env("PORT") || 4000 ],
  https: false
