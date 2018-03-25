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

  describe "list_semester" do
    test "returns all semester" do
      Curriculum.list_semesters()
      semester = insert(:semester)

      [result] = Curriculum.list_semesters()

      assert result.id == semester.id
    end
  end

  describe "get_semester!/1" do
    test "returns the semester with given id" do
      semester = insert(:semester)

      assert Curriculum.get_semester!(semester.id) == semester
    end
  end

  describe "create_semester/1" do
    test "with valid data creates a semester" do
      params = params_for(:semester)

      assert {:ok, %Semester{}} = Curriculum.create_semester(params)
      assert Repo.get_by(Semester, params)
    end

    test "with invalid data returns error changeset" do
      params = params_for(:semester, name: nil)

      assert {:error, %Ecto.Changeset{}} = Curriculum.create_semester(params)
    end
  end

  describe "update_semester" do
    test "with valid data updates the semester" do
      semester = insert(:semester)
      params = params_for(:semester)

      assert {:ok, %Semester{}} = Curriculum.update_semester(semester, params)
      assert Repo.get_by(Semester, Map.put(params, :id, semester.id))
    end

    test "with invalid data returns error changeset" do
      semester = insert(:semester)
      params = params_for(:semester, ended_on: "invalid")

      assert {:error, %Ecto.Changeset{}} = Curriculum.update_semester(semester, params)
    end
  end

  describe "delete_semester" do
    test "deletes the semester" do
      semester = insert(:semester)

      assert {:ok, %Semester{}} = Curriculum.delete_semester(semester)
      assert_raise Ecto.NoResultsError, fn -> Curriculum.get_semester!(semester.id) end
    end
  end

  describe "prepare_semester" do
    test "returns a semester changeset" do
      semester = build(:semester)

      assert %Ecto.Changeset{} = Curriculum.prepare_semester(semester)
    end
  end
end
