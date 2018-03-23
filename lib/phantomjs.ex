defmodule PhantomJS do
  def start do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    Process.register(pid, :phantomjs)
    :timer.sleep(750)
  end

  # GenServer

  def init(_) do
    port =
      Port.open({:spawn, "phantomjs"}, [
        :binary,
        :stream,
        :use_stdio,
        :exit_status
      ])

    Process.flag(:trap_exit, true)
    {:ok, %{port: port}}
  end

  def handle_info(_, state), do: {:noreply, state}

  def terminate(_reason, state) do
    Port.close(state.port)
  end
end
