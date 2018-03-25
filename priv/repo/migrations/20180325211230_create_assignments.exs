defmodule Exgradebook.Repo.Migrations.CreateAssignments do
  use Ecto.Migration

  def change do
    create table(:assignments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :value, :float
      add :course_id, references(:courses, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end
    create index(:assignments, [:course_id])
  end
end
