defmodule Exgradebook.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :teacher_id, references(:staff, type: :binary_id), null: false
      add :semester_id, references(:semesters, type: :binary_id), null: false
      add :enrollments_count, :integer, default: 0, null: false

      timestamps()
    end
  end
end