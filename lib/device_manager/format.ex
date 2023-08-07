defmodule DeviceManager.Format do
  def format(%{id: id, readings: %{count: _count, timestamp: _timestamp}}) do
    :ok
  end
end
