defmodule ExgradebookWeb.Student.SessionController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Users.Student
  alias ExgradebookWeb.Session

  def new(conn, _params) do
    conn
    |> render(:new)
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    if user = Doorman.authenticate(Student, email, pass) do
      conn
      |> Session.login(user)
      |> put_flash(:info, gettext("Successfully signed in"))
      |> redirect(to: student_dashboard_path(conn, :show))
    else
      conn
      |> put_flash(:danger, gettext("Incorrect email or password"))
      |> render(:new)
    end
  end
end
