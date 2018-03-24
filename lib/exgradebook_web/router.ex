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
    plug NavigationHistory.Tracker,
      excluded_paths: ["/logout", ~r/\/login/]
  end

  pipeline :staff do
    plug RequireLogin
    plug :put_layout, {ExgradebookWeb.LayoutView, "staff.html"}
  end

  pipeline :student do
    plug RequireLogin
    plug :put_layout, {ExgradebookWeb.LayoutView, "student.html"}
  end

  scope "/", ExgradebookWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/staff/login", Staff.SessionController, :new, as: :staff_session
    post "/staff/login", Staff.SessionController, :create, as: :staff_session
    delete "/logout", SessionController, :delete
    get "/student/login", Student.SessionController, :new, as: :student_session
    post "/student/login", Student.SessionController, :create, as: :student_session
  end

  scope "/student", ExgradebookWeb.Student, as: :student do
    pipe_through [:browser, :student]
    #resources "/courses", StudentController
  end

  scope "/staff", ExgradebookWeb.Staff, as: :staff do
    pipe_through [:browser, :staff]
    resources "/users", UserController
    #resources "/students", StudentController
    #resources "/semesters", StudentController
    #resources "/courses", StudentController
  end
end
