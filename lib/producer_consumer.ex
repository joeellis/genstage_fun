defmodule Stager.ProducerConsumer do
  use GenStage
  require Integer

  def start_link do
    GenStage.start_link(__MODULE__, :no_state, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [{Stager.Producer, max_demand: 10, min_demand: 5}]}
  end

  def handle_events(events, _from, state) do
    even_events = events
    |> Enum.filter(fn(event) -> Integer.is_even(event.id) end)

    IO.inspect "discarding #{length(events) - length(even_events)} events because they have odd ids"

    {:noreply, events, state}
  end
end
