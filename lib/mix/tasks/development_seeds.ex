defmodule Mix.Tasks.DevelopmentSeeds do
  use Mix.Task
  use Exgradebook.DevelopmentSeeds.Helper
  alias Ecto.Changeset

  @shortdoc "Insert the seeds for development"
  def run(_arguments) do
    Mix.Task.run("ecto.migrate", [])
    Mix.Task.run("app.start", [])

    UsefulOutput.start_link()

    for table_name <- tables_to_truncate() do
      Ecto.Adapters.SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end

    admin = create_staff(email: "admin@example.com", first_name: "Test", last_name: "Admin")
    UsefulOutput.add("Added staff #{admin.email}/password")


    teacher = create_staff(email: "teacher@example.com", first_name: "Test", last_name: "Teacher")
    UsefulOutput.add("Added staff #{teacher.email}/password")

    UsefulOutput.print()
  end


  defp tables_to_truncate do
    ~w(
      staff
    )
  end

  defp create_staff(params) do
    :staff
    |> build(params)
    |> set_password("password")
    |> insert
  end

  def set_password(struct, password) do
    struct
    |> Changeset.cast(%{password: password}, [:password])
    |> Doorman.Auth.Bcrypt.hash_password()
    |> Changeset.apply_changes()
  end
end
