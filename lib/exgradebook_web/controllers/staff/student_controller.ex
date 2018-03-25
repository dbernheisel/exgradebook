defmodule ExgradebookWeb.Staff.StudentController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Users
  alias Exgradebook.Users.Student

  def index(conn, _params) do
    students = Users.list_students()

    conn
    |> assign(:students, students)
    |> render(:index)
  end

  def new(conn, _params) do
    changeset = Users.prepare_student(%Student{})

    conn
    |> render_new(changeset)
  end

  def create(conn, %{"student" => student_params}) do
    case Users.create_student(student_params) do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        #|> redirect(to: staff_student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_new(changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student = Users.get_student!(id)

    conn
    |> assign(:student, student)
    |> render(:show)
  end

  def edit(conn, %{"id" => id}) do
    student = Users.get_student!(id)
    changeset = Users.prepare_student(student)

    conn
    |> render_edit(student, changeset)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Users.get_student!(id)

    case Users.update_student(student, student_params) do
      {:ok, _student} ->
        conn
        |> put_flash(:info, "Student updated successfully.")
        #|> redirectCourseto: staff_student_path(conn, :show, student))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_edit(student, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Users.get_student!(id)
    {:ok, _student} = Users.delete_student(student)

    conn
    |> put_flash(:info, "Student deleted successfully.")
    #|> redirect(to: staff_student_path(conn, :index))
  end

  defp render_edit(conn, user, changeset) do
    conn
    |> assign(:student, user)
    |> assign(:changeset, changeset)
    |> render(:edit)
  end

  defp render_new(conn, changeset) do
    conn
    |> assign(:changeset, changeset)
    |> render(:new)
  end
end
