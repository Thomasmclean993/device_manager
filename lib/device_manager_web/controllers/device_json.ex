defmodule DeviceManagerWeb.DeviceJSON do
  @doc """
  Renders a list of devices.
  """
  def index(%{devices: devices}) do
    %{data: for(device <- devices, do: data(device))}
  end

  @doc """
  Renders a single device.
  """
  def show(device) do
    data(device)
  end

  def not_found(_device) do
    %{
      errors: %{
        detail: "Device not found"
      }
    }
  end

  defp data(%{data: %{"id" => _id, "readings" => readings}}) do
    %{
      readings: readings
    }
  end
end
