defmodule ExgradebookWeb.StaffControllerTest do
  use ExgradebookWeb.ConnCase

  describe "index" do
    test "lists all staff", %{conn: conn} do
      conn = get conn, staff_path(conn, :index)

      assert html_response(conn, 200) =~ "Listing Staff"
    end
  end

  describe "new staff" do
    test "renders form", %{conn: conn} do
      conn = get conn, staff_path(conn, :new)

      assert html_response(conn, 200) =~ "New Staff"
    end
  end

  describe "create staff" do
    test "redirects to show when data is valid", %{conn: conn} do
      params = params_for(:teacher) |> without_secrets
      conn = post conn, staff_path(conn, :create), staff: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == staff_path(conn, :show, id)

      conn = get conn, staff_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Staff"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = params_for(:teacher, role: "invalid") |> without_secrets
      conn = post conn, staff_path(conn, :create), staff: params

      assert html_response(conn, 200) =~ "New Staff"
    end
  end

  describe "edit staff" do
    test "renders form for editing chosen staff", %{conn: conn} do
      staff = insert(:teacher)
      conn = get conn, staff_path(conn, :edit, staff)

      assert html_response(conn, 200) =~ "Edit Staff"
    end
  end

  describe "update staff" do
    test "redirects when data is valid", %{conn: conn} do
      staff = insert(:teacher)
      params = params_for(:teacher, first_name: "new name") |> without_secrets
      conn = put conn, staff_path(conn, :update, staff), staff: params
      assert redirected_to(conn) == staff_path(conn, :show, staff)

      conn = get conn, staff_path(conn, :show, staff)
      assert html_response(conn, 200) =~ "new name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      staff = insert(:teacher)
      params = params_for(:teacher, role: "invalid") |> without_secrets
      conn = put conn, staff_path(conn, :update, staff), staff: params

      assert html_response(conn, 200) =~ "Edit Staff"
    end
  end

  describe "delete staff" do
    test "deletes chosen staff", %{conn: conn} do
      staff = insert(:teacher)
      conn = delete conn, staff_path(conn, :delete, staff)

      assert redirected_to(conn) == staff_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, staff_path(conn, :show, staff)
      end
    end
  end

  defp without_secrets(params) do
    params
    |> Map.delete(:password)
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
  end
end
