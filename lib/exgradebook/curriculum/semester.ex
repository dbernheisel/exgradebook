defmodule Exgradebook.Curriculum.Semester do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "semesters" do
    field :ended_on, :date
    field :name, :string
    field :started_on, :date

    timestamps()
  end

  @required_fields ~w(
    name
    ended_on
    started_on
  )a

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
