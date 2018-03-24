defmodule ExgradebookWeb.Staff.UserView do
  use ExgradebookWeb, :view
  alias Exgradebook.Users.Staff

  def role_options do
    Staff.valid_roles
    |> Enum.map(& {&1, &1})
  end

  def display_name(user) do
    [
      user.first_name,
      user.last_name
    ] |> Enum.join(" ")
  end
end
