defmodule ExgradebookWeb.Plug.RequireStaff do
  alias ExgradebookWeb.Session
  alias Exgradebook.Users.Staff
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Session.get_current_user(conn) do
      %Staff{} ->
        conn
      _ ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> halt
    end
  end
end
