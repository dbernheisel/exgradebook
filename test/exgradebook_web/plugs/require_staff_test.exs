defmodule ExgradebookWeb.Plug.RequireStaffTest do
  use ExgradebookWeb.ConnCase, async: true
  alias ExgradebookWeb.Plug.RequireStaff

  describe "call" do
    test "if user logged in and is staff, then return conn", %{conn: conn} do
      staff = insert(:staff)
      conn =
        conn
        |> Plug.Conn.assign(:current_user, staff)
        |> RequireStaff.call([])

      refute conn.halted
    end

    test "if user is not staff, then halt the connection and redirect to root", %{conn: conn} do
      student = insert(:student)
      conn =
        conn
        |> Plug.Conn.assign(:current_user, student)
        |> RequireStaff.call([])

      assert conn.halted
      assert conn.status == 302
    end
  end
end
