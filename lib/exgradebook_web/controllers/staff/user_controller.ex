defmodule ExgradebookWeb.Staff.UserController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Users
  alias Exgradebook.Users.Staff

  def index(conn, _params) do
    staff = Users.list_staff()
    render(conn, "index.html", staff: staff)
  end

  def new(conn, _params) do
    changeset = Users.prepare_staff(%Staff{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"staff" => staff_params}) do
    case Users.create_staff(staff_params) do
      {:ok, staff} ->
        conn
        |> put_flash(:info, "Staff created successfully.")
        |> redirect(to: staff_user_path(conn, :show, staff))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff = Users.get_staff!(id)
    render(conn, "show.html", staff: staff)
  end

  def edit(conn, %{"id" => id}) do
    staff = Users.get_staff!(id)
    changeset = Users.prepare_staff(staff)
    render(conn, "edit.html", staff: staff, changeset: changeset)
  end

  def update(conn, %{"id" => id, "staff" => staff_params}) do
    staff = Users.get_staff!(id)

    case Users.update_staff(staff, staff_params) do
      {:ok, staff} ->
        conn
        |> put_flash(:info, "Staff updated successfully.")
        |> redirect(to: staff_user_path(conn, :show, staff))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", staff: staff, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff = Users.get_staff!(id)
    {:ok, _staff} = Users.delete_staff(staff)

    conn
    |> put_flash(:info, "Staff deleted successfully.")
    |> redirect(to: staff_user_path(conn, :index))
  end
end
