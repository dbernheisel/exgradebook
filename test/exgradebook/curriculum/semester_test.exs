defmodule Exgradebook.Curriculum.SemesterTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Semester

  describe "changeset" do
    test "requires fields" do
      params = params_for(
        :semester,
        ended_on: nil,
        started_on: nil,
        name: nil
      )

      changeset = Semester.changeset(%Semester{}, params)

      assert changeset.errors[:name]
      assert changeset.errors[:ended_on]
      assert changeset.errors[:started_on]
    end

    test "requires name to be unique" do
      existing_semester = insert(:semester, name: "duplicate")
      params = params_for(:semester, name: existing_semester.name)

      {:error, changeset} =
        %Semester{}
        |> Semester.changeset(params)
        |> Repo.insert

      assert {"has already been taken", _} = changeset.errors[:name]
    end
  end

  describe "list_semesters" do
    test "returns all semesters" do
      semesters = insert_pair(:semester)

      [fetched_semester_one, fetched_semester_two] = Curriculum.list_semesters()

      assert fetched_semester_one.id in map_ids(semesters)
      assert fetched_semester_two.id in map_ids(semesters)
    end
  end
end
