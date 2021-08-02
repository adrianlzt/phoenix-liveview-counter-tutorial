defmodule LiveViewCounter.Count do
  use GenServer

  alias Phoenix.PubSub

  require OpenTelemetry.Tracer

  @name :count_server

  @start_value 0

  def topic do
    "count"
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def incr() do
    OpenTelemetry.Tracer.with_span "incr func" do
      Process.sleep(50)
      GenServer.call @name, :incr
    end
  end

  def decr() do
    OpenTelemetry.Tracer.with_span "decr func" do
      Process.sleep(50)
      GenServer.call @name, :decr
    end
  end

  def current() do
    GenServer.call @name, :current
  end

  def init(start_count) do
    {:ok, start_count}
  end

  def handle_call(:current, _from, count) do
     {:reply, count, count}
  end

  def handle_call(:incr, _from, count) do
    make_change(count, +1)
  end

  def handle_call(:decr, _from, count) do
    make_change(count, -1)
  end

  defp make_change(count, change) do
    new_count = count + change
    PubSub.broadcast(LiveViewCounter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end
end
