defmodule Exgradebook.Users.Staff do
  use Ecto.Schema
  import Ecto.Changeset
  import Doorman.Auth.Bcrypt, only: [hash_password: 1]
  import Doorman.Auth.Secret, only: [put_session_secret: 1]
  alias Exgradebook.Curriculum.Course

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "staff" do
    field :email, :string
    field :first_name, :string
    field :hashed_password, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :role, :string, default: "teacher"
    field :session_secret, :string
    has_many :courses, Course, foreign_key: :teacher_id
    has_many :students, through: [:courses, :enrollments, :student]

    timestamps()
  end

  @required_fields ~w(
    email
    first_name
    last_name
    role
  )a

  @valid_roles ~w(teacher administrator)
  def valid_roles, do: @valid_roles

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:role, @valid_roles)
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password])
    |> validate_required([:password])
    |> changeset(params)
    |> hash_password()
    |> put_session_secret()
    |> validate_required([:hashed_password, :session_secret])
  end
end
