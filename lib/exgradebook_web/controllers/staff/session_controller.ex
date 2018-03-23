defmodule ExgradebookWeb.Staff.SessionController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Users.Staff
  alias ExgradebookWeb.Session

  def new(conn, _params) do
    conn
    |> render(:new)
  end

  def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    if user = Doorman.authenticate(Staff, email, pass) do
      conn
      |> Session.login(user)
      |> put_flash(:notice, gettext("Successfully signed in"))
      |> redirect(to: staff_user_path(conn, :index))
    else
      conn
      |> put_flash(:error, gettext("Incorrect email or password"))
      |> redirect(to: staff_session_path(conn, :new))
    end
  end
end
