defmodule ExgradebookWeb.Staff.Course.StudentController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Users
  alias Exgradebook.Curriculum

  def show(conn, %{"id" => student_id, "course_id" => course_id}) do
    student = Users.get_student!(student_id)
    course = Curriculum.get_course!(course_id)
    assignments = Curriculum.list_assignments_for_course(course_id)

    conn
    |> assign(:student, student)
    |> assign(:course, course)
    |> assign(:assignments, assignments)
    |> render(:show)
  end
end
