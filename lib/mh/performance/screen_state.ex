defmodule Mh.Performance.ScreenState do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def update_state(state) do
    GenServer.cast(__MODULE__, {:update, state})
  end

  def get_state() do
    GenServer.call(__MODULE__, {:get})
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_cast({:update, state_req}, state) do
    new_state = state_req
    {:noreply, new_state}
  end

  def handle_call(request, from, state) do
    {:reply, state, state}
  end
end
