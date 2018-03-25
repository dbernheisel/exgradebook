defmodule Exgradebook.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :student_id, references(:students, type: :binary_id, on_delete: :delete_all), null: false
      add :course_id, references(:courses, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end
    create unique_index(:enrollments, [:student_id, :course_id])
    create index(:enrollments, [:student_id])
    create index(:enrollments, [:course_id])
  end
end
