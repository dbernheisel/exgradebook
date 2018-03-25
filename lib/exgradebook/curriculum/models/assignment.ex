defmodule Exgradebook.Curriculum.Assignment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Grade

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "assignments" do
    field :name, :string
    field :value, :float
    belongs_to :course, Course
    has_many :grades, Grade, on_delete: :delete_all

    timestamps()
  end

  @required_fields ~w(
    course_id
    name
    value
  )a

  @doc false
  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
