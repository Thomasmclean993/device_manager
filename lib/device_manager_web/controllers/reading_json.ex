defmodule DeviceManagerWeb.ReadingJSON do
  alias DeviceManager.Reading

  @doc """
  Renders a list of readings.
  """
  def index(%{readings: readings}) do
    %{data: for(reading <- readings, do: data(reading))}
  end

  @doc """
  Renders a single reading.
  """
  def show(%{reading: reading}) do
    %{data: data(reading)}
  end

  defp data(%Reading{} = reading) do
    %{
      id: reading.id,
      timestamp: reading.timestamp,
      count: reading.count
    }
  end
end
