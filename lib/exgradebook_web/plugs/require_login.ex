defmodule ExgradebookWeb.Plug.RequireLogin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if Doorman.logged_in?(conn) do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:danger, "Please log in")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt
    end
  end
end
