defmodule ExgradebookWeb.StaffView do
  use ExgradebookWeb, :view
  alias Exgradebook.Users.Staff

  def role_options do
    Staff.valid_roles
    |> Enum.map(& {&1, &1})
  end
end
