defmodule Exgradebook.Factory do
  use ExMachina.Ecto, repo: Exgradebook.Repo
  alias Exgradebook.Repo, warn: false

  def teacher_factory do
    %Exgradebook.Users.Staff{
      email: sequence(:email, &"user-#{&1}@example.com"),
      first_name: sequence(:first_name, &"First Name #{&1}"),
      hashed_password: sequence(:hashed_password, &"password-#{&1}"),
      last_name: sequence(:last_name, &"Last Name #{&1}"),
      role: Exgradebook.Users.Staff.valid_roles |> List.first,
      session_secret: sequence(:session_secret, &"session-#{&1}"),
    }
  end
end
