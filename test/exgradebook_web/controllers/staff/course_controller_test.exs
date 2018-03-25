defmodule ExgradebookWeb.Staff.CourseControllerTest do
  use ExgradebookWeb.ConnCase, async: true

  describe "index" do
    test "lists all courses", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_course_path(conn, :index, as: admin.id)

      assert html_response(conn, 200) =~ "Course Directory"
    end
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      admin = insert(:admin)
      conn = get conn, staff_course_path(conn, :new, as: admin.id)

      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "create" do
    test "redirects to show when data is valid", %{conn: conn} do
      admin = insert(:admin)
      params = params_with_assocs(:course)
      conn = post conn, staff_course_path(conn, :create, as: admin.id), course: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == staff_course_path(conn, :show, id)

      conn = get conn, staff_course_path(conn, :show, id)
      assert html_response(conn, 200) =~ params.title
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = insert(:admin)
      params = params_for(:course, title: nil)
      conn = post conn, staff_course_path(conn, :create, as: admin.id), course: params

      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "edit" do
    test "renders form for editing chosen course", %{conn: conn} do
      admin = insert(:admin)
      course = insert(:course)
      conn = get conn, staff_course_path(conn, :edit, course, as: admin.id)

      assert html_response(conn, 200) =~ "Edit #{course.title}"
    end
  end

  describe "update" do
    test "redirects when data is valid", %{conn: conn} do
      admin = insert(:admin)
      course = insert(:course)
      params = %{title: "new name"}
      conn = put conn, staff_course_path(conn, :update, course, as: admin.id), course: params
      assert redirected_to(conn) == staff_course_path(conn, :show, course)

      conn = get conn, staff_course_path(conn, :show, course, as: admin.id)
      assert html_response(conn, 200) =~ params.title
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = insert(:admin)
      course = insert(:course)
      params = %{semester_id: nil}
      conn = put conn, staff_course_path(conn, :update, course, as: admin.id), course: params

      assert html_response(conn, 200) =~ "Edit #{course.title}"
    end
  end

  describe "delete" do
    test "deletes chosen course", %{conn: conn} do
      admin = insert(:admin)
      course = insert(:course)
      conn = delete conn, staff_course_path(conn, :delete, course, as: admin.id)

      assert redirected_to(conn) == staff_course_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, staff_course_path(conn, :show, course)
      end
    end
  end
end
