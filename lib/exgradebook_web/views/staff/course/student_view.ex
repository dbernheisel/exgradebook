defmodule ExgradebookWeb.Staff.Course.StudentView do
  use ExgradebookWeb, :view
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]
  alias Exgradebook.Curriculum.Grade

  def grade_for_student(grades, student) do
    Enum.find(grades, %Grade{}, & &1.student_id == student.id)
  end
end
