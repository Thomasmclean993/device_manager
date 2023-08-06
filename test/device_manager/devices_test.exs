defmodule DeviceManager.DevicesTest do
  use DeviceManager.DataCase

  alias DeviceManager.Devices

  describe "readings" do
    alias DeviceManager.Devices.Reading

    import DeviceManager.DevicesFixtures

    @invalid_attrs %{count: nil, timestamp: nil}

    test "list_readings/0 returns all readings" do
      reading = reading_fixture()
      assert Devices.list_readings() == [reading]
    end

    test "get_reading!/1 returns the reading with given id" do
      reading = reading_fixture()
      assert Devices.get_reading!(reading.id) == reading
    end

    test "create_reading/1 with valid data creates a reading" do
      valid_attrs = %{count: 42, timestamp: ~U[2023-08-04 18:41:00Z]}

      assert {:ok, %Reading{} = reading} = Devices.create_reading(valid_attrs)
      assert reading.count == 42
      assert reading.timestamp == ~U[2023-08-04 18:41:00Z]
    end

    test "create_reading/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_reading(@invalid_attrs)
    end

    test "update_reading/2 with valid data updates the reading" do
      reading = reading_fixture()
      update_attrs = %{count: 43, timestamp: ~U[2023-08-05 18:41:00Z]}

      assert {:ok, %Reading{} = reading} = Devices.update_reading(reading, update_attrs)
      assert reading.count == 43
      assert reading.timestamp == ~U[2023-08-05 18:41:00Z]
    end

    test "update_reading/2 with invalid data returns error changeset" do
      reading = reading_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_reading(reading, @invalid_attrs)
      assert reading == Devices.get_reading!(reading.id)
    end

    test "delete_reading/1 deletes the reading" do
      reading = reading_fixture()
      assert {:ok, %Reading{}} = Devices.delete_reading(reading)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_reading!(reading.id) end
    end

    test "change_reading/1 returns a reading changeset" do
      reading = reading_fixture()
      assert %Ecto.Changeset{} = Devices.change_reading(reading)
    end
  end
end
