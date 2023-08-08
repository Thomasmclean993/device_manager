defmodule DeviceManager.DeviceDataStorageTest do
  use DeviceManager.DataCase
  use ExUnit.Case
  alias DeviceManager.DeviceDataStorage, as: DDS

  # Start the GenServer before running each test.
  setup do
    start_fresh_state()
  end

  @valid_request [
    %{
      "id" => "device_id_3",
      "readings" => [%{"count" => :rand.uniform(100), "timestamp" => DateTime.utc_now()}]
    },
    %{
      "id" => "device_id_6",
      "readings" => [%{"count" => :rand.uniform(100), "timestamp" => DateTime.utc_now()}]
    }
  ]

  describe "add_data/1" do
    test "add_data/1 with valid data", %{pid: pid} do
      assert [:ok, :ok] == DeviceManager.DeviceDataStorage.add_data(@valid_request)
      state = DeviceManager.DeviceDataStorage.fetch_all_data()
      assert length(state) == 2
    end

    test "add_data/1 with duplicate data", %{pid: pid} do
      data = [
        %{
          "id" => "device_id_1",
          "readings" => [%{"count" => 1, "timestamp" => "2023-07-30T12:00:00Z"}]
        },
        %{
          "id" => "device_id_1",
          "readings" => [%{"count" => 1, "timestamp" => "2023-07-30T12:00:00Z"}]
        }
      ]

      assert [:ok, {:error, :duplicate_data, %{"id" => "device_id_1", "readings" => [%{"count" => 1, "timestamp" => "2023-07-30T12:00:00Z"}]}}] = DeviceManager.DeviceDataStorage.add_data(data)
      state = DeviceManager.DeviceDataStorage.fetch_all_data()
      assert length(state) == 1
    end
  end

  describe "fetch_all_data/1" do
    test "fetch_all_data/0 with no added data" do
      state = DeviceManager.DeviceDataStorage.fetch_all_data()
      assert state == []
    end
  end

  describe "retrieve_devices_data/1" do
    test "retrieve_devices_data/1 with existing device_id", %{pid: pid} do
      data = [
        %{
          "id" => "device_id_1",
          "readings" => [%{"count" => 15, "timestamp" => "2023-07-30T12:00:00Z"}]
        },
        %{
          "id" => "device_id_2",
          "readings" => [%{"count" => 10, "timestamp" => "2023-07-30T12:15:00Z"}]
        }
      ]

      assert [:ok, :ok] == DeviceManager.DeviceDataStorage.add_data(data)
      assert device_data = DeviceManager.DeviceDataStorage.retrieve_devices_data("device_id_1")

      assert device_data == %{
               "id" => "device_id_1",
               "readings" => [%{"count" => 15, "timestamp" => "2023-07-30T12:00:00Z"}]
             }
    end

    test "retrieve_devices_data/1 with non-existing device_id" do
      assert {:error, :not_found} =
               DeviceManager.DeviceDataStorage.retrieve_devices_data("non_existing_id")
    end
  end

  describe "reset_state/0" do
    test "reset_state/0", %{pid: pid} do
      data = [
        %{
          "id" => "device_id_1",
          "readings" => [%{"count" => 1, "timestamp" => "2023-07-30T12:00:00Z"}]
        },
        %{
          "id" => "device_id_2",
          "readings" => [%{"count" => 2, "timestamp" => "2023-07-30T12:15:00Z"}]
        }
      ]

      assert [:ok, :ok] = DeviceManager.DeviceDataStorage.add_data(data)
      assert data == DeviceManager.DeviceDataStorage.fetch_all_data()

      assert :ok == DeviceManager.DeviceDataStorage.reset_state(pid)
      state_after_reset = DeviceManager.DeviceDataStorage.fetch_all_data()
      assert state_after_reset == []
    end
  end

  def start_fresh_state() do
    with {:ok, pid} <- DDS.start_link() do
      %{pid: pid}
    else
      {:error, {:already_started, pid}} ->
        DDS.reset_state(pid)
        %{pid: pid}

      _ ->
        {:error, :unexpected_error}
    end
  end
end
