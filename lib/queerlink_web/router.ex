defmodule QueerlinkWeb.Router do
  use QueerlinkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QueerlinkWeb do
    pipe_through :api

    post "/s",       LinkController, :shorten
    get  "/l/:hash", LinkController, :expand 
  end

  scope "/", QueerlinkWeb do
    pipe_through :browser # Use the default browser stack

    get  "/",       PageController, :index
    post "/create", PageController, :create
  end
end
