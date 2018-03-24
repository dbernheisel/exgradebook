defmodule ExgradebookWeb.PageControllerTest do
  use ExgradebookWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Welcome to Gradebook"
  end
end
