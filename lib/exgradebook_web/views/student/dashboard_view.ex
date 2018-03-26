defmodule ExgradebookWeb.Student.DashboardView do
  use ExgradebookWeb, :view
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]
  import ExgradebookWeb.CourseView
  alias Exgradebook.Curriculum

  def display_gpa_for_semester(student, semester) do
    student
    |> Curriculum.gpa_for_student_in_semester(semester)
    |> display_grade
  end
end
