defmodule Exgradebook.DevelopmentSeeds.Helper do
  defmacro __using__(_) do
    quote do
      import Exgradebook.Factory
      alias Exgradebook.DevelopmentSeeds.UsefulOutput
      alias Exgradebook.Repo
    end
  end
end
