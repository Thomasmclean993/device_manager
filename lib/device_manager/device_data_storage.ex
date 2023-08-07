defmodule DeviceManager.DeviceDataStorage do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_data(data) when is_list(data) do
    Enum.map(data, fn single_device -> add_data(single_device) end)
  end

  def add_data(data) when is_map(data) do
    IO
    GenServer.call(__MODULE__, {:add_devices, data})
  end

  def fetch_all_data do
    GenServer.call(__MODULE__, :get_devices)
  end

  def retrieve_devices_data(device_id) do
    GenServer.call(__MODULE__, {:get_device_data, device_id})
  end

  def reset_state(server_pid) do
    GenServer.cast(server_pid, {:reset_state})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:add_devices, data}, _from, state) do
    new_state = state ++ [data]
    {:reply, :ok, new_state}
  end

  def handle_call(:get_devices, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_device_data, device_id}, _from, state) do
    find_single_device(state, device_id)

  end

  def handle_cast({:reset_state}, state) do
    {:noreply, []}
  end

    def find_single_device(data, id) do
      Enum.map(data, fn %{id: map_id, readings: _readings} -> id == map_id end)
    end

end
