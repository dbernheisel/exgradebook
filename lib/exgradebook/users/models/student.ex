defmodule Exgradebook.Users.Student do
  use Ecto.Schema
  import Ecto.Changeset
  import Doorman.Auth.Bcrypt, only: [hash_password: 1]
  import Doorman.Auth.Secret, only: [put_session_secret: 1]
  alias Exgradebook.Curriculum.Enrollment
  alias Exgradebook.Curriculum.Grade

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "students" do
    field :email, :string
    field :first_name, :string
    field :hashed_password, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :session_secret, :string
    has_many :enrollments, Enrollment, on_delete: :delete_all
    has_many :courses, through: [:enrollments, :course]
    has_many :grades, Grade, on_delete: :delete_all

    timestamps()
  end

  @required_fields ~w(
    email
    first_name
    last_name
  )a

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields -- [:email])
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
