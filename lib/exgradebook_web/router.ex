defmodule ExgradebookWeb.Router do
  use ExgradebookWeb, :router
  alias ExgradebookWeb.Plug.RequireLogin

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ExgradebookWeb.Plug.TestSessionBackdoor
    plug ExgradebookWeb.Session
  end

  scope "/", ExgradebookWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/staff/login", Staff.SessionController, :new, as: :staff_session
    post "/staff/login", Staff.SessionController, :create, as: :staff_session
    delete "/logout", SessionController, :delete
    #get "/student/login", Student.SessionController, :new
    #post "/student/login", Student.SessionController, :create
    #delete "/student/logout", Student.SessionController, :delete
  end

  scope "/student", ExgradebookWeb.Student, as: :student do
    pipe_through [:browser, RequireLogin]
    #resources "/courses", StudentController
  end

  scope "/staff", ExgradebookWeb.Staff, as: :staff do
    pipe_through [:browser, RequireLogin]
    resources "/users", UserController
    #resources "/students", StudentController
    #resources "/semesters", StudentController
    #resources "/courses", StudentController
  end
end
