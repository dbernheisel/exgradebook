defmodule Exgradebook.Curriculum.Course do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exgradebook.Users.Staff
  alias Exgradebook.Curriculum.Semester
  alias Exgradebook.Curriculum.Enrollment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "courses" do
    field :title, :string
    field :enrollments_count, :integer, default: 0
    belongs_to :teacher, Staff
    belongs_to :semester, Semester
    has_many :enrollments, Enrollment
    has_many :students, through: [:enrollments, :student]

    timestamps()
  end

  @required_fields ~w(
    title
    teacher_id
    semester_id
    enrollments_count
  )a

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title)
  end

  def increment_course_enrollment_count(enrollment_changeset) do
    prepare_changes(enrollment_changeset, fn (changeset) ->
      changeset
      |> apply_changes
      |> Ecto.assoc(:course)
      |> Exgradebook.Repo.update_all(inc: [enrollments_count: 1])

      changeset
    end)
  end
end
