defmodule ExgradebookWeb.Student.CourseController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Course

  def index(conn, _params) do
    student = Session.get_current_user(conn)
    courses = Curriculum.list_courses_for_user(student)

    conn
    |> assign(:courses, courses)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    course = Curriculum.get_course!(id)
    #assignments = Curriculum.list_assignments_for_course(course.id)

    conn
    |> assign(:course, course)
    |> assign(:assignments, nil)
    |> render(:show)
  end
end
