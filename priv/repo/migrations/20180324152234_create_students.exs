defmodule Exgradebook.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :hashed_password, :string
      add :session_secret, :string

      timestamps()
    end
    create unique_index(:students, [:email])
  end
end
