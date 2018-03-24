defmodule ExgradebookWeb.HistoryHelpers do
  def redirect_back(conn, opts \\ []) do
    conn
    |> NavigationHistory.last_paths(opts)
    |> Enum.find("/", & &1 != conn.request_path)
  end
end
