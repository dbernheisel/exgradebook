defmodule Exgradebook.TestHelpers do
  def map_ids(collection) do
    Enum.map(collection, & &1.id)
  end
end
