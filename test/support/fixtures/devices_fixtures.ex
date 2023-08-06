defmodule DeviceManager.DevicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DeviceManager.Devices` context.
  """

  @doc """
  Generate a reading.
  """
  def reading_fixture(attrs \\ %{}) do
    {:ok, reading} =
      attrs
      |> Enum.into(%{
        count: 42,
        timestamp: ~U[2023-08-04 18:41:00Z]
      })
      |> DeviceManager.Devices.create_reading()

    reading
  end
end
