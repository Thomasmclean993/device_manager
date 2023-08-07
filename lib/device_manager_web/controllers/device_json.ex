defmodule DeviceManagerWeb.DeviceJSON do
  alias DeviceManager.Device

  @doc """
  Renders a list of devices.
  """
  def index(%{devices: devices}) do
    %{data: for(device <- devices, do: data(device))}
  end

  @doc """
  Renders a single device.
  """
  def show(%{device: device}) do
    %{data: data(device)}
  end

  defp data(%device{} = device) do
    %{
      id: device.id,
      readings: device.readings
    }
  end
end
