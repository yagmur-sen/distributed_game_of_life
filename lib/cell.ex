defmodule Cell do
    use GenServer

    def start_link(opts \\ []) do
        initial_state = Keyword.get(opts, :state, :dead)
        GenServer.start_link(__MODULE__, %{
            state: initial_state, 
            next_state: nil,
            neighbors: []})
    end

    def get_state(pid) do
        GenServer.call(pid, :get_state)
    end

    def set_neighbors(pid, neighbor_pids) when is_list(neighbor_pids) do
        GenServer.call(pid, {:set_neighbors, neighbor_pids})
    end

    def tick_start(pid) do
        GenServer.call(pid, :tick_start)
    end

    def tick_end(pid) do
        GenServer.call(pid, :tick_end)
    end

    #Callbacks
    @impl true
    def init(state_map) do
        {:ok, state_map}
    end

    @impl true
    def handle_call(:get_state, _from, state) do
        {:reply, state.state, state}
    end

    @impl true
    def handle_call(:tick_start, _from, state) do
        # Get neighbor states
        alive_count = count_alive_neighbors(state.neighbors)

        # Apply game rules
        next_state = case {state.state, alive_count} do
            {:alive, 2} -> :alive
            {:alive, 3} -> :alive
            {:dead, 3} -> :alive
            _ -> :dead
        end

        {:reply, :ok, %{state | next_state: next_state}}
    end

    @impl true
    def handle_call(:tick_end, _from, state) do
        {:reply, :ok, %{state | state: state.next_state}}
    end
        

    @impl true
    def handle_call({:set_neighbors, neighbor_pids}, _from, state) do
        {:reply, :ok, %{state | neighbors: neighbor_pids}}
    end

    # Helper function
    defp count_alive_neighbors(neighbor_pids) do
        neighbor_pids
        |> Enum.map(&get_state/1)
        |> Enum.count(fn cell_state -> cell_state == :alive end)
    end

end
