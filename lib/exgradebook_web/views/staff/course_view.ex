defmodule ExgradebookWeb.Staff.CourseView do
  use ExgradebookWeb, :view
  alias Exgradebook.Users
  alias Exgradebook.Curriculum
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]

  def student_options(course_id) do
    course_id
    |> Users.list_students_not_in_course
    |> Enum.map(& {display_name(&1), &1.id})
  end

  def semester_options do
    Curriculum.list_semesters()
    |> Enum.map(& {&1.name, &1.id})
  end

  def teacher_options do
    Users.list_staff()
    |> Enum.map(& {display_name(&1), &1.id})
  end
end
