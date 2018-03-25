defmodule ExgradebookWeb.Staff.UserControllerTest do
  use ExgradebookWeb.ConnCase, async: true

  describe "index" do
    test "lists all staff", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_user_path(conn, :index, as: admin.id)

      assert html_response(conn, 200) =~ "Staff Directory"
    end
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_user_path(conn, :new, as: admin.id)

      assert html_response(conn, 200) =~ "New Staff"
    end
  end

  describe "create" do
    test "redirects to show when data is valid", %{conn: conn} do
      admin = insert(:admin)
      params = params_for(:teacher) |> for_registration
      conn = post conn, staff_user_path(conn, :create, as: admin.id), staff: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == staff_user_path(conn, :show, id)

      conn = get conn, staff_user_path(conn, :show, id)
      assert html_response(conn, 200) =~ params.first_name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = insert(:admin)
      params = params_for(:teacher, role: "invalid") |> for_registration
      conn = post conn, staff_user_path(conn, :create, as: admin.id), staff: params

      assert html_response(conn, 200) =~ "New Staff"
    end
  end

  describe "edit" do
    test "renders form for editing chosen staff", %{conn: conn} do
      admin = insert(:admin)
      staff = insert(:teacher)
      conn = get conn, staff_user_path(conn, :edit, staff, as: admin.id)

      assert html_response(conn, 200) =~ "Edit #{staff.first_name} #{staff.last_name}"
    end
  end

  describe "update" do
    test "redirects when data is valid", %{conn: conn} do
      admin = insert(:admin)
      staff = insert(:teacher)
      params = params_for(:teacher, first_name: "new name") |> without_secrets
      conn = put conn, staff_user_path(conn, :update, staff, as: admin.id), staff: params
      assert redirected_to(conn) == staff_user_path(conn, :show, staff)

      conn = get conn, staff_user_path(conn, :show, staff, as: admin.id)
      assert html_response(conn, 200) =~ "new name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = insert(:admin)
      staff = insert(:teacher)
      params = params_for(:teacher, role: "invalid") |> without_secrets
      conn = put conn, staff_user_path(conn, :update, staff, as: admin.id), staff: params

      assert html_response(conn, 200) =~ "Edit #{staff.first_name} #{staff.last_name}"
    end
  end

  describe "delete" do
    test "deletes chosen staff", %{conn: conn} do
      admin = insert(:admin)
      staff = insert(:teacher)
      conn = delete conn, staff_user_path(conn, :delete, staff, as: admin.id)

      assert redirected_to(conn) == staff_user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, staff_user_path(conn, :show, staff)
      end
    end
  end

  defp without_secrets(params) do
    params
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
  end
end
