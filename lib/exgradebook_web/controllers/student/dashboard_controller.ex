defmodule ExgradebookWeb.Student.DashboardController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum

  def show(conn, _params) do
    student = Session.get_current_user(conn)
    courses = Curriculum.list_courses_for_user(student)

    conn
    |> assign(:courses, courses)
    |> render(:show)
  end
end
