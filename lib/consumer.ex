defmodule Stager.Consumer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :no_state)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [{Stager.ProducerConsumer, max_demand: 10, min_demand: 5}]}
  end

  def handle_events(events, _from, state) do
    IO.inspect "preparing to consume #{length(events)} events"

    process_events(events)

    {:noreply, [], state}
  end

  defp process_events([]), do: []
  defp process_events(events) do
    [event | tail] = events

    consume_time = :rand.uniform(10) * 10
    :timer.sleep(consume_time)

    IO.inspect "consuming #{event.id} - will take #{consume_time}ms - #{length(events)} left"

    process_events(tail)
  end
end
