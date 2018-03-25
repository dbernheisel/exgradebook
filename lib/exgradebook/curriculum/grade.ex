defmodule Exgradebook.Curriculum.Grade do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exgradebook.Curriculum.Assignment
  alias Exgradebook.Users.Student

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "grades" do
    field :value, :float
    belongs_to :assignment, Assignment
    belongs_to :student, Student

    timestamps()
  end

  @required_fields ~w(
    assignment_id
    student_id
    value
  )a

  @doc false
  def changeset(grade, attrs) do
    grade
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
