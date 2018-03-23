defmodule ExgradebookWeb.Plug.TestSessionBackdoor do
  alias Exgradebook.Repo
  alias Exgradebook.Users.Staff
  import ExgradebookWeb.Session, only: [login: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    if Mix.env == :test do
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
