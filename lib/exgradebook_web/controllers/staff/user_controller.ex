defmodule ExgradebookWeb.Staff.UserController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Users
  alias Exgradebook.Users.Staff

  def index(conn, _params) do
    staff = Users.list_staff()

    conn
    |> assign(:staff, staff)
    |> render(:index)
  end

  def new(conn, _params) do
    changeset = Users.prepare_staff(%Staff{})

    conn
    |> render_new(changeset)
  end

  def create(conn, %{"staff" => staff_params}) do
    case Users.create_staff(staff_params) do
      {:ok, staff} ->
        conn
        |> put_flash(:info, "Staff created successfully.")
        |> redirect(to: staff_user_path(conn, :show, staff))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_new(changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff = Users.get_staff!(id)

    conn
    |> assign(:staff, staff)
    |> render(:show)
  end

  def edit(conn, %{"id" => id}) do
    staff = Users.get_staff!(id)
    changeset = Users.prepare_staff(staff)

    conn
    |> render_edit(staff, changeset)
  end

  def update(conn, %{"id" => id, "staff" => staff_params}) do
    staff = Users.get_staff!(id)

    case Users.update_staff(staff, staff_params) do
      {:ok, staff} ->
        conn
        |> put_flash(:info, "Staff updated successfully.")
        |> redirect(to: staff_user_path(conn, :show, staff))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_edit(staff, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff = Users.get_staff!(id)
    {:ok, _staff} = Users.delete_staff(staff)

    conn
    |> put_flash(:info, "Staff deleted successfully.")
    |> redirect(to: staff_user_path(conn, :index))
  end

  defp render_edit(conn, user, changeset) do
    conn
    |> assign(:staff, user)
    |> assign(:changeset, changeset)
    |> render(:edit)
  end

  defp render_new(conn, changeset) do
    conn
    |> assign(:changeset, changeset)
    |> render(:new)
  end
end
