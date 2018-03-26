defmodule ExgradebookWeb.Student.DashboardView do
  use ExgradebookWeb, :view
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]
  import ExgradebookWeb.CourseView
end
