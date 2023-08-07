defmodule DeviceManager.DeviceTest do
  use DeviceManagerWeb.ConnCase
  use ExUnit.Case, async: true

  alias DeviceManager.Device
  alias DeviceManager.DevicesFixtures
  alias DeviceManager.Reading

  @consumer_request DevicesFixtures.device_fixture("valid_request.json") |> Jason.decode!()
  @missing_timestamp_request DevicesFixtures.device_fixture("missing_timestamp_request.json")
                             |> Jason.decode!()
  @missing_count_request DevicesFixtures.device_fixture("missing_count_request.json")
                         |> Jason.decode!()
  @missing_id_request DevicesFixtures.device_fixture("missing_id_request.json") |> Jason.decode!()

  # TODO: Add wrong type errors
  describe "changeset/1" do
    test " will only accept a struct with all the required fields" do
      changeset = Device.changeset(%Device{}, @consumer_request)
      assert true == changeset.valid?
    end

    test " when missing timestamp field, return with an error message" do
      changeset = Device.changeset(%Device{}, @missing_timestamp_request)

      assert %{readings: [%{timestamp: ["can't be blank"]}, %{timestamp: ["can't be blank"]}]} ==
               changeset
    end

    test " when missing count field, return with an error message" do
      changeset = Device.changeset(%Device{}, @missing_count_request)

      assert %{readings: [%{count: ["can't be blank"]}, %{count: ["can't be blank"]}]} ==
               changeset
    end

    test " when missing id field, return with an error message" do
      changeset = Device.changeset(%Device{}, @missing_id_request)
      assert %{id: ["can't be blank"]} == changeset
    end
  end
end
