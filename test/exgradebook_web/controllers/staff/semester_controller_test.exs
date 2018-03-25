defmodule ExgradebookWeb.Staff.SemesterControllerTest do
  use ExgradebookWeb.ConnCase, async: true

  describe "index" do
    test "lists all semesters", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_semester_path(conn, :index, as: admin.id)

      assert html_response(conn, 200) =~ "Semesters"
    end
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_semester_path(conn, :new, as: admin.id)

      assert html_response(conn, 200) =~ "New Semester"
    end
  end

  describe "create" do
    test "redirects to show when data is valid", %{conn: conn} do
      admin = insert(:admin)
      params = params_for(:semester)
      conn = post conn, staff_semester_path(conn, :create, as: admin.id), semester: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == staff_semester_path(conn, :show, id)

      conn = get conn, staff_semester_path(conn, :show, id)
      assert html_response(conn, 200) =~ params.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = insert(:admin)
      params = params_for(:semester, name: nil)
      conn = post conn, staff_semester_path(conn, :create, as: admin.id), semester: params

      assert html_response(conn, 200) =~ "New Semester"
    end
  end

  describe "edit" do
    test "renders form for editing chosen semester", %{conn: conn} do
      admin = insert(:admin)
      semester = insert(:semester)
      conn = get conn, staff_semester_path(conn, :edit, semester, as: admin.id)

      assert html_response(conn, 200) =~ "Edit #{semester.name}"
    end
  end

  describe "update" do
    test "redirects when data is valid", %{conn: conn} do
      admin = insert(:admin)
      semester = insert(:semester)
      params = %{name: "new name"}
      conn = put conn, staff_semester_path(conn, :update, semester, as: admin.id), semester: params
      assert redirected_to(conn) == staff_semester_path(conn, :show, semester)

      conn = get conn, staff_semester_path(conn, :show, semester, as: admin.id)
      assert html_response(conn, 200) =~ params.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = insert(:admin)
      semester = insert(:semester)
      params = %{ended_on: "invalid"}
      conn = put conn, staff_semester_path(conn, :update, semester, as: admin.id), semester: params

      assert html_response(conn, 200) =~ "Edit #{semester.name}"
    end
  end

  describe "delete" do
    test "deletes chosen semester", %{conn: conn} do
      admin = insert(:admin)
      semester = insert(:semester)
      conn = delete conn, staff_semester_path(conn, :delete, semester, as: admin.id)

      assert redirected_to(conn) == staff_semester_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, staff_semester_path(conn, :show, semester)
      end
    end
  end
end
