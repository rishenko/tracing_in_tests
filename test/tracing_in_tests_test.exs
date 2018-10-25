defmodule TracingInTestsTest do
  @moduledoc false

  use ExUnit.Case

  alias TracingInTests.{BlackBoxReceiver, MySender}

  test "verify a process received a particular message pattern" do
    # we start instances of both BlackBoxReceiver and MySender
    {:ok, receiver_pid} = BlackBoxReceiver.start_link()
    {:ok, sender_pid} = MySender.start_link(receiver_pid)

    # the juicy bit: we use trace/3 to trace BlackBoxReceiver
    :erlang.trace(receiver_pid, true, [:receive])

    # Next, let's call MySender and have it run its workhorse function
    {:ok, :data_received} = MySender.action(sender_pid, a: 1)

    # Now that MySender has finished, let's see if the message was sent
    assert_receive({:trace, ^receiver_pid, :receive, {:"$gen_call", _, {:store, _}}})
  end
end
