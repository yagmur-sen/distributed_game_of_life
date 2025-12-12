defmodule Cell do
    use GenServer

    def start_link(opts \\ []) do
        initial_state = Keyword.get(opts, :state, :dead)
        GenServer.start_link(__MODULE__, %{state: initial_state, neighbors: []})
    end

    def get_state(pid) do
        GenServer.call(pid, :get_state)
    end

    def set_neighbors(pid, neighbor_pids) when is_list(neighbor_pids) do
        GenServer.cast(pid, {:set_neighbors, neighbor_pids})
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
    def handle_cast({:set_neighbors, neighbor_pids}, state) do
        {:noreply, %{state | neighbors: neighbor_pids}}
    end

end
