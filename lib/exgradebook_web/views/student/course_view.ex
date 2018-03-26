defmodule ExgradebookWeb.Student.CourseView do
  use ExgradebookWeb, :view
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]
  import ExgradebookWeb.Staff.Course.StudentView, only: [grade_for_student: 2]
  import ExgradebookWeb.CourseView
end
