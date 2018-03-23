defmodule Exgradebook.Users.Staff do
  use Ecto.Schema
  import Ecto.Changeset
  import Doorman.Auth.Bcrypt, only: [hash_password: 1]
  import Doorman.Auth.Secret, only: [put_session_secret: 1]

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
    |> validate_role
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password])
    |> changeset(params)
    |> hash_password()
    |> put_session_secret()
  end

  defp validate_role(changeset) do
    case get_field(changeset, :role) do
      role when role in @valid_roles ->
        changeset

      _ ->
        changeset
        |> add_error(:role, "Role not valid")
    end
  end
end
