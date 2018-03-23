defmodule Exgradebook.DevelopmentSeeds.UsefulOutput do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(message) do
    Agent.update __MODULE__, fn state ->
      state ++ [message]
    end
  end

  def print do
    IO.puts ""
    IO.puts "*************************************************"
    __MODULE__ |> Agent.get(&(&1)) |> Enum.each(&IO.puts/1)
    IO.puts "*************************************************"
    IO.puts ""
  end
end
