defmodule DeviceManager.DeviceDataStorage do
  alias DeviceManager.Data

  @device_storage []
  @uuid_regex ~r/\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/
  @timestamp_regex ~r/\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}(?:\.\d{1,6})?(?:Z|[+-]\d{2}:\d{2})?/

  def insert_list_of_devices(data) do
    combined_data =
      data
      |> Enum.group_by(fn x -> x.id end)
      |> Enum.map(fn {_id, maps} ->
        %{id: hd(maps).id, readings: Enum.flat_map(maps, fn x -> x.readings end)}
      end)

    @device_storage ++ combined_data
  end

  def validate_data(list_of_devices) when is_list(list_of_devices) do
    list_of_devices
    |> Enum.map(fn device -> validate_data(device) end)
    |> Enum.all?()
  end

  def validate_data(%{id: id, readings: readings}) do
    validate_id(id) and validate_readings(readings)
  end

  def validate_id(id) do
    Regex.match?(@uuid_regex, id)
  end

  def validate_readings(readings) when is_list(readings) do
    readings
    |> Enum.map(fn reading -> validate_readings(reading) end)
    |> Enum.all?()
  end

  def validate_readings(%{count: count, timestamp: timestamp}) do
    is_integer(count) and Regex.match?(@timestamp_regex, timestamp)
  end

  def fetch_all_data do
    @device_storage
  end
end
