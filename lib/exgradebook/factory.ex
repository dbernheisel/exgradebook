defmodule Exgradebook.Factory do
  use ExMachina.Ecto, repo: Exgradebook.Repo
  alias Exgradebook.Repo, warn: false

  def staff_factory do
    %Exgradebook.Users.Staff{
      email: sequence(:email, &"user-#{&1}@example.com"),
      first_name: sequence(:first_name, &"First Name #{&1}"),
      hashed_password: sequence(:hashed_password, &"password-#{&1}"),
      last_name: sequence(:last_name, &"Last Name #{&1}"),
      role: "teacher",
      session_secret: sequence(:session_secret, &"session-#{&1}"),
    }
  end

  def teacher_factory do
    build(:staff, role: "teacher")
  end

  def admin_factory do
    build(:teacher, role: "administrator")
  end

  def for_registration(user) do
    user
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
    |> Map.put(:password, "password")
  end
end
