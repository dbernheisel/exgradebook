defmodule ExgradebookWeb.Plug.RequireLoginTest do
  use ExgradebookWeb.ConnCase, async: true
  alias ExgradebookWeb.Plug.RequireLogin

  describe "call" do
    test "if user logged in, then return conn", %{conn: conn} do
      staff = insert(:staff)
      conn =
        conn
        |> Plug.Conn.assign(:current_user, staff)
        |> RequireLogin.call([])

      refute conn.halted
    end

    test "if user is not logged in, then halt the connection and flash message", %{conn: conn} do
      conn =
        conn
        |> RequireLogin.call([])

      assert conn.halted

    end
  end
end
