defmodule DeviceManager.DeviceDataStorage do
  use GenServer

  @moduledoc """
    This module manages the storage and retrieval of device data using a GenServer. GenServer rely on callback functions

    THe module provides functions the add , fetch and retrieve device data. When adding data, it prevents duplicate data to be inserted as well.
  Usage:
    - start_link/1 to start the GenServer process.
    - add_data/1 to add device data, preventing duplicates.
    - fetch_all_data/0 to retrieve all stored device data.
    - retrieve_devices_data/1 to retrieve data for a specific device ID.
    - reset_state/1 to reset the GenServer state.

  """

  # Api functionality
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_data(data) when is_list(data) do
    results = Enum.map(data, fn single_device -> add_data(single_device) end)

    if Enum.all?(results, fn result -> result == :ok end) do
      :ok
    else
      Enum.reject(results, fn result -> result == :ok end)
    end
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

  # Server functionality
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
