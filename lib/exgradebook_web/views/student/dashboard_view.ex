defmodule ExgradebookWeb.Student.DashboardView do
  use ExgradebookWeb, :view
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]
  import ExgradebookWeb.Staff.CourseView, only: [grade_percentage_for_student_in_course: 2]
end
