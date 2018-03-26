defmodule ExgradebookWeb.Student.DashboardController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum

  def show(conn, _params) do
    student = Session.get_current_user(conn)
    enrollments = Curriculum.list_enrollments_for_student(student.id)

    conn
    |> assign(:enrollments, enrollments)
    |> render(:show)
  end
end
