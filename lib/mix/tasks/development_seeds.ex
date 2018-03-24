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

    admin = create_user(:admin, email: "admin@example.com", first_name: "Test", last_name: "Admin")
    UsefulOutput.add("Added staff #{admin.email}/password")


    teacher = create_user(:teacher, email: "teacher@example.com", first_name: "Test", last_name: "Teacher")
    UsefulOutput.add("Added staff #{teacher.email}/password")
    insert_list(20, :teacher)

    student = create_user(:student, email: "student@example.com", first_name: "Test", last_name: "Student")
    UsefulOutput.add("Added student #{student.email}/password")

    insert_list(100, :student)

    UsefulOutput.print()
  end


  defp tables_to_truncate do
    ~w(
      staff
      students
    )
  end

  defp create_user(type, params) do
    type
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
