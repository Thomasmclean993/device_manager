defmodule DeviceManager.DevicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DeviceManager.Devices` context.
  """

  @doc """
  Generate a reading.
  """
  def device_fixture(file_name) do
    {:ok, file} = File.read("test/support/fixtures/#{file_name}")
    file
  end
end
