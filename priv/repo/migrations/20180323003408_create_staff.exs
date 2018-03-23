defmodule Exgradebook.Repo.Migrations.CreateStaff do
  use Ecto.Migration
  alias Exgradebook.Repo

  def change do
    Ecto.Adapters.SQL.query(Repo, "create extension citext")

    create table(:staff, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :citext
      add :role, :string
      add :hashed_password, :string
      add :session_secret, :string

      timestamps()
    end

    create unique_index(:staff, [:email])
  end
end
