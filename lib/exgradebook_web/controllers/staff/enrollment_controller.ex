defmodule ExgradebookWeb.Staff.EnrollmentController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum

  def create(conn, %{"enrollment" => enrollment_params}) do
    case Curriculum.enroll(enrollment_params) do
      {:ok, enrollment} ->
        conn
        |> put_flash(:info, "Student enrolled")
        |> redirect(to: staff_course_path(conn, :show, enrollment.course_id))

      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Student could not be enrolled")
        |> redirect(to: redirect_back(conn))
    end
  end

  def delete(conn, %{"id" => enrollment_id}) do
    {:ok, enrollment} = Curriculum.unenroll(enrollment_id)

    conn
    |> put_flash(:info, "Student unenrolled")
    |> redirect(to: staff_course_path(conn, :show, enrollment.course_id))
  end
end

