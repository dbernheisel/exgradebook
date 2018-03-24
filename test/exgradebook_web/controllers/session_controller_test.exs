defmodule ExgradebookWeb.SessionControllerTest do
  use ExgradebookWeb.ConnCase, async: true
  alias ExgradebookWeb.Session

  describe "delete" do
    test "removes user from session and logs out", %{conn: conn} do
      user = insert(:admin)
      conn = Session.login(conn, user)
      assert Session.get_current_user(conn)

      conn = delete conn, session_path(conn, :delete)

      assert redirected_to(conn) == "/"
      refute Session.get_current_user(conn)
    end
  end
end
