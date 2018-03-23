defmodule ExgradebookWeb.Staff.SessionController do
  use ExgradebookWeb, :controller
  alias ExgradebookWeb.Users.Staff
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
    else
      conn
      |> put_flash(:error, gettext("Incorrect email or password"))
      #|> redirect(to: staff_session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> Session.logout
    #|> redirect(to: staff_sesion_path(conn, :new))
  end
end
