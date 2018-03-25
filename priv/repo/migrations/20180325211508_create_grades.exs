defmodule Exgradebook.Repo.Migrations.CreateGrades do
  use Ecto.Migration

  def change do
    create table(:grades, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :float, null: false
      add :assignment_id, references(:assignments, on_delete: :delete_all, type: :binary_id), null: false
      add :student_id, references(:students, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:grades, [:assignment_id])
    create index(:grades, [:student_id])
  end
end
