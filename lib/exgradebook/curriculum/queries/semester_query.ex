defmodule Exgradebook.Curriculum.Query.SemesterQuery do
  defmacro __using__(_opts) do
    quote do
      alias Exgradebook.Repo
      alias Exgradebook.Curriculum.Semester

      def get_semester!(semester_id) do
        Repo.get!(Semester, semester_id)
      end

      def update_semester(%Semester{} = semester, attrs) do
        semester
        |> Semester.changeset(attrs)
        |> Repo.update()
      end

      def list_semesters do
        Repo.all(Semester)
      end

      def delete_semester(%Semester{} = semester) do
        Repo.delete(semester)
      end

      def create_semester(attrs \\ %{}) do
        %Semester{}
        |> Semester.changeset(attrs)
        |> Repo.insert()
      end

      def prepare_semester(%Semester{} = semester, attrs \\ %{}) do
        Semester.changeset(semester, attrs)
      end
    end
  end
end
