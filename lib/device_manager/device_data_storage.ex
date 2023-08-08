defmodule DeviceManager.DeviceDataStorage do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_data(data) when is_list(data) do
    Enum.map(data, fn single_device -> add_data(single_device) end)
  end

  def add_data(data) when is_map(data) do
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
    case find_duplicate(data, state) do
      nil ->
        new_state = state ++ [data]
        {:reply, :ok, new_state}

      duplicate_data ->
        {:reply, {:error, :duplicate_data, duplicate_data}, state}
    end
  end

  def handle_call(:get_devices, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_device_data, device_id}, _from, state) do
    data = find_single_device(state, device_id)

    {:reply, data, state}
  end

  def handle_cast({:reset_state}, _state) do
    {:noreply, []}
  end

  defp find_duplicate(new_data, state) do
    Enum.find(state, fn existing_data ->
      existing_id = Map.get(existing_data, "id")
      existing_readings = Map.get(existing_data, "readings")

      new_id = Map.get(new_data, "id")
      new_readings = Map.get(new_data, "readings")

      if existing_id == new_id && existing_readings == new_readings do
        existing_data
      else
        nil
      end
    end)
  end

  defp find_single_device(data, id) do
    Enum.find(data, {:error, :not_found}, fn %{"id" => map_id, "readings" => _readings} ->
      map_id == id
    end)
  end
end
