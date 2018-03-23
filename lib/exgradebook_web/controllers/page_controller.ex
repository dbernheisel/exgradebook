defmodule ExgradebookWeb.PageController do
  use ExgradebookWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
