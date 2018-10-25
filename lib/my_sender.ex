defmodule TracingInTests.MySender do
  @moduledoc "Data sender."

  use GenServer
  alias TracingInTests.BlackBoxReceiver

  def start_link(receiver_pid) do
    GenServer.start_link(__MODULE__, receiver_pid)
  end

  @doc """
  Executes a lot of business logic using `data`, and gives you actionable
  results in return.
  """
  def action(sender_pid, data), do: GenServer.call(sender_pid, {:action, data})

  def init(receiver_pid) do
    {:ok, receiver_pid}
  end

  def handle_call({:action, data}, _from, receiver_pid) do
    # business logic executed here
    result = BlackBoxReceiver.store(receiver_pid, data)
    # more business logic executed here
    {:reply, result, receiver_pid}
  end
end
