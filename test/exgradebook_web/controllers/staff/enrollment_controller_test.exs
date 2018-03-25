defmodule ExgradebookWeb.Staff.EnrollmentControllerTest do
  use ExgradebookWeb.ConnCase, async: true
  alias Exgradebook.Curriculum

  describe "create" do
    test "redirects to course show when data is valid", %{conn: conn} do
      admin = insert(:admin)
      params = params_with_assocs(:enrollment)
      conn = post conn, staff_enrollment_path(conn, :create, as: admin.id), enrollment: params

      assert redirected_to(conn) == staff_course_path(conn, :show, params.course_id)
      assert get_flash(conn, :info) == "Student enrolled"
    end
  end

  describe "delete" do
    test "deletes chosen enrollment", %{conn: conn} do
      admin = insert(:admin)
      enrollment = insert(:enrollment)
      conn = delete conn, staff_enrollment_path(conn, :delete, enrollment, as: admin.id)

      assert redirected_to(conn) == staff_course_path(conn, :show, enrollment.course_id)
      assert get_flash(conn, :info) == "Student unenrolled"
      assert_raise Ecto.NoResultsError, fn -> Curriculum.get_enrollment!(enrollment.id) end
    end
  end
end

