defmodule TestDeployWeb.Router do
  use TestDeployWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TestDeployWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestDeployWeb do
    pipe_through :browser

    live "/", HomeLive, :index

    live "/items", ItemLive.Index, :index
    live "/items/new", ItemLive.Form, :new
    live "/items/:id", ItemLive.Show, :show
    live "/items/:id/edit", ItemLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TestDeployWeb do
  #   pipe_through :api
  # end
end
