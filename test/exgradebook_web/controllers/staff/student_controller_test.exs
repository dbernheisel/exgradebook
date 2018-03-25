defmodule ExgradebookWeb.Staff.StudentControllerTest do
  use ExgradebookWeb.ConnCase, async: true

  describe "index" do
    test "lists all students", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_student_path(conn, :index, as: admin.id)

      assert html_response(conn, 200) =~ "Student Directory"
    end
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_student_path(conn, :new, as: admin.id)

      assert html_response(conn, 200) =~ "New Student"
    end
  end

  describe "create" do
    test "redirects to show when data is valid", %{conn: conn} do
      admin = insert(:admin)
      params = params_for(:student) |> for_registration
      conn = post conn, staff_student_path(conn, :create, as: admin.id), student: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == staff_student_path(conn, :show, id)

      conn = get conn, staff_student_path(conn, :show, id)
      assert html_response(conn, 200) =~ params.first_name
    end
  end

  describe "edit" do
    test "renders form for editing chosen student", %{conn: conn} do
      admin = insert(:admin)
      student = insert(:student)
      conn = get conn, staff_student_path(conn, :edit, student, as: admin.id)

      assert html_response(conn, 200) =~ "Edit #{student.first_name} #{student.last_name}"
    end
  end

  describe "update" do
    test "redirects when data is valid", %{conn: conn} do
      admin = insert(:admin)
      student = insert(:student)
      params = params_for(:student, first_name: "new name") |> without_secrets
      conn = put conn, staff_student_path(conn, :update, student, as: admin.id), student: params
      assert redirected_to(conn) == staff_student_path(conn, :show, student)

      conn = get conn, staff_student_path(conn, :show, student, as: admin.id)
      assert html_response(conn, 200) =~ "new name"
    end
  end

  describe "delete" do
    test "deletes chosen student", %{conn: conn} do
      admin = insert(:admin)
      student = insert(:student)
      conn = delete conn, staff_student_path(conn, :delete, student, as: admin.id)

      assert redirected_to(conn) == staff_student_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, staff_student_path(conn, :show, student)
      end
    end
  end

  defp without_secrets(params) do
    params
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
  end
end
