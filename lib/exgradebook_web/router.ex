defmodule ExgradebookWeb.Router do
  use ExgradebookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ExgradebookWeb.Session
  end

  scope "/", ExgradebookWeb do
    pipe_through :browser
    resources "/staff", StaffController

    get "/", PageController, :index
  end
end
