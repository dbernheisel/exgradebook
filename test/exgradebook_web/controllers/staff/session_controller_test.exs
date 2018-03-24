defmodule ExgradebookWeb.Staff.SessionControllerTest do
  use ExgradebookWeb.ConnCase, async: true
  alias Exgradebook.Users
  alias ExgradebookWeb.Session

  describe "new" do
    test "renders form", %{conn: conn} do
      conn = get conn, staff_session_path(conn, :new)

      assert html_response(conn, 200) =~ "Sign In"
    end
  end

  describe "create" do
    test "when successful sign-in, redirects to user index", %{conn: conn} do
      password = "password"
      {:ok, admin} =
        params_for(:admin, password: password)
        |> for_registration
        |> Users.create_staff
      params = %{"email" => admin.email, "password" => password}

      conn = post conn, staff_session_path(conn, :create), login: params

      assert get_flash(conn, :info) == "Successfully signed in"
      assert redirected_to(conn) == staff_user_path(conn, :index)
      assert Session.get_current_user(conn).id == admin.id
    end

    test "renders errors when login is invalid", %{conn: conn} do
      password = "password"
      {:ok, admin} =
        params_for(:admin, password: password)
        |> for_registration
        |> Users.create_staff
      params = %{"email" => admin.email, "password" => "invalid password"}

      conn = post conn, staff_session_path(conn, :create), login: params

      assert get_flash(conn, :error) == "Incorrect email or password"
      assert html_response(conn, 200) =~ "Sign In"
      refute Session.get_current_user(conn)
    end
  end
end
