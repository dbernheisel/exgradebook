defmodule ExgradebookWeb.SessionController do
  use ExgradebookWeb, :controller
  alias ExgradebookWeb.Session
  alias Exgradebook.Users.Staff
  alias Exgradebook.Users.Student

  def new(conn, _params) do
    case Session.get_current_user(conn) do
      %Staff{} ->
        conn
        |> redirect(to: staff_user_path(conn, :index))

      %Student{} ->
        conn
        |> redirect(to: student_dashboard_path(conn, :show))

      nil ->
        conn
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> Session.logout
    |> put_flash(:info, gettext("Logged out"))
    |> redirect(to: "/")
  end
end
