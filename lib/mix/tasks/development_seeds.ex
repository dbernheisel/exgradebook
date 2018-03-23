defmodule Mix.Tasks.DevelopmentSeeds do
  use Mix.Task
  use Exgradebook.DevelopmentSeeds.Helper

  @shortdoc "Insert the seeds for development"
  def run(_arguments) do
    Mix.Task.run("ecto.migrate", [])
    Mix.Task.run("app.start", [])

    UsefulOutput.start_link()

    for table_name <- tables_to_truncate() do
      Ecto.Adapters.SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end
  end


  defp tables_to_truncate do
    ~w(
    )
  end
end
