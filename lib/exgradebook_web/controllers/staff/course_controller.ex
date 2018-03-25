defmodule ExgradebookWeb.Staff.CourseController do
  use ExgradebookWeb, :controller
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Course

  def index(conn, %{"search" => search_params}) do
    courses = Curriculum.search_courses(search_params)
    render_index(conn, courses, search_params)
  end
  def index(conn, params) do
    courses = Curriculum.list_courses()
    render_index(conn, courses)
  end

  defp render_index(conn, courses, search_params \\ %{}) do
    conn
    |> assign(:search, search_params)
    |> assign(:courses, courses)
    |> render(:index)
  end

  def new(conn, _params) do
    changeset = Curriculum.prepare_course(%Course{})

    conn
    |> render_new(changeset)
  end

  def create(conn, %{"course" => course_params}) do
    case Curriculum.create_course(course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: staff_course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_new(changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Curriculum.get_course!(id)
    enrollments = Curriculum.list_enrollments_for_course(course.id)

    conn
    |> assign(:course, course)
    |> assign(:enrollments, enrollments)
    |> render(:show)
  end

  def edit(conn, %{"id" => id}) do
    course = Curriculum.get_course!(id)
    changeset = Curriculum.prepare_course(course)

    conn
    |> render_edit(course, changeset)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Curriculum.get_course!(id)

    case Curriculum.update_course(course, course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: staff_course_path(conn, :show, course))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render_edit(course, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Curriculum.get_course!(id)
    {:ok, _course} = Curriculum.delete_course(course)

    conn
    |> put_flash(:info, "Course deleted successfully.")
    |> redirect(to: staff_course_path(conn, :index))
  end

  defp render_edit(conn, course, changeset) do
    conn
    |> assign(:course, course)
    |> assign(:changeset, changeset)
    |> render(:edit)
  end

  defp render_new(conn, changeset) do
    conn
    |> assign(:changeset, changeset)
    |> render(:new)
  end
end
