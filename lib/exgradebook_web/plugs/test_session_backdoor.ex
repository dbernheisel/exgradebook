defmodule ExgradebookWeb.Plug.TestSessionBackdoor do
  alias Exgradebook.Repo
  alias Exgradebook.Users.Staff
  import ExgradebookWeb.Session, only: [login: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    if System.get_env("ENVIRONMENT_NAME") == "test" do
      case conn.query_params do
        %{"as" => id} ->
          user = Repo.get(Staff, id)
          conn
          |> login(user)

        _ ->
          conn
      end
    else
      conn
    end
  end
end
