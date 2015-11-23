defmodule Queerlink.Router do
  use Sugar.Router
  plug Sugar.Plugs.HotCodeReload

  if Sugar.Config.get(:sugar, :show_debugger, false) do
    use Plug.Debugger, otp_app: :queerlink
  end

  plug Plug.Static, at: "/static", from: :queerlink

  # Uncomment the following line for session store
  # plug Plug.Session, store: :ets, key: "sid", secure: true, table: :session

  # Define your routes here
  get "/", Queerlink.Controllers.Main, :index

  put "/shorten/:format", Queerlink.Controllers.Main, :shorten
  get  "/expand/:format/:uid",  Queerlink.Controllers.Main, :expand
  get  "/:uid", Queerlink.Controllers.Main, :url_redirect
end
