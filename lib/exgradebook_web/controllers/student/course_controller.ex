defmodule ExgradebookWeb.Student.CourseController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum

  def index(conn, _params) do
    courses = Curriculum.list_courses()

    conn
    |> assign(:courses, courses)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    student = Session.get_current_user(conn)
    course = Curriculum.get_course!(id, user: student)
    #assignments = Curriculum.list_assignments_for_course(course.id)

    conn
    |> assign(:course, course)
    |> assign(:assignments, nil)
    |> render(:show)
  end
end
