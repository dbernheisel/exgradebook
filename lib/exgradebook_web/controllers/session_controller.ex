defmodule ExgradebookWeb.SessionController do
  use ExgradebookWeb, :controller
  alias ExgradebookWeb.Session

  def delete(conn, _params) do
    conn
    |> Session.logout
    |> put_flash(:info, gettext("Logged out"))
    |> redirect(to: "/")
  end
end
