defmodule Exgradebook.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :student_id, references(:students, type: :binary_id), null: false
      add :course_id, references(:courses, type: :binary_id), null: false

      timestamps()
    end
  end
end
