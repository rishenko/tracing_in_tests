defmodule TracingInTests.BlackBoxReceiver do
  @moduledoc "Black box receiver we have no control over."

  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, [])

  @doc "Store your data in the black box."
  def store(ref, data), do: GenServer.call(ref, {:store, data})

  def init(_), do: {:ok, nil}

  def handle_call({:store, _data}, _from, state) do
    {:reply, {:ok, :data_received}, state}
  end
end
