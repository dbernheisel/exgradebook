defmodule ExgradebookWeb.Staff.SemesterController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Semester

  def index(conn, _params) do
    semesters = Curriculum.list_semesters()

    conn
    |> assign(:semesters, semesters)
    |> render(:index)
  end

  def new(conn, _params) do
    changeset = Curriculum.prepare_semester(%Semester{})

    conn
    |> render_new(changeset)
  end

  def create(conn, %{"semester" => semester_params}) do
    case Curriculum.create_semester(semester_params) do
      {:ok, semester} ->
        conn
        |> put_flash(:info, "Semester created successfully.")
        |> redirect(to: staff_semester_path(conn, :show, semester))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_new(changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    semester = Curriculum.get_semester!(id)

    conn
    |> assign(:semester, semester)
    |> render(:show)
  end

  def edit(conn, %{"id" => id}) do
    semester = Curriculum.get_semester!(id)
    changeset = Curriculum.prepare_semester(semester)

    conn
    |> render_edit(semester, changeset)
  end

  def update(conn, %{"id" => id, "semester" => semester_params}) do
    semester = Curriculum.get_semester!(id)

    case Curriculum.update_semester(semester, semester_params) do
      {:ok, semester} ->
        conn
        |> put_flash(:info, "Semester updated successfully.")
        |> redirect(to: staff_semester_path(conn, :show, semester))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_edit(semester, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    semester = Curriculum.get_semester!(id)
    {:ok, _semester} = Curriculum.delete_semester(semester)

    conn
    |> put_flash(:info, "Semester deleted successfully.")
    |> redirect(to: staff_semester_path(conn, :index))
  end

  defp render_edit(conn, user, changeset) do
    conn
    |> assign(:semester, user)
    |> assign(:changeset, changeset)
    |> render(:edit)
  end

  defp render_new(conn, changeset) do
    conn
    |> assign(:changeset, changeset)
    |> render(:new)
  end
end
