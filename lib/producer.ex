defmodule Event do
  defstruct id: nil
end

defmodule Stager.Producer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    num_events = :rand.uniform(20)
    :timer.sleep(5000)

    IO.inspect "creating #{num_events} events"

    events = Enum.to_list(state..(state + num_events - 1))
    |> Enum.map(&%Event{id: &1})

    IO.inspect(events)

    IO.inspect("being asked for #{length(events)} events for processing")

    {:noreply, events, (state + demand)}
  end
end
