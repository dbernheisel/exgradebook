defmodule Exgradebook.Users.Query.StaffQuery do
  defmacro __using__(_opts) do
    quote do
      alias Exgradebook.Repo
      alias Exgradebook.Users.Staff

      def list_staff do
        Repo.all(Staff)
      end

      def get_staff!(id), do: Repo.get!(Staff, id)

      def create_staff(attrs \\ %{}) do
        %Staff{}
        |> Staff.registration_changeset(attrs)
        |> Repo.insert()
      end

      def update_staff(%Staff{} = staff, attrs) do
        staff
        |> Staff.changeset(attrs)
        |> Repo.update()
      end

      def delete_staff(%Staff{} = staff) do
        Repo.delete(staff)
      end

      def prepare_staff(%Staff{} = staff, attrs \\ %{}) do
        Staff.changeset(staff, attrs)
      end
    end
  end
end
