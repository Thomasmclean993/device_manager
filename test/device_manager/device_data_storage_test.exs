defmodule DeviceManager.DeviceDataStorageTest do
  use DeviceManager.DataCase
  use ExUnit.Case
  alias DeviceManager.DeviceDataStorage, as: DDS

  @two_devices [
    %{
      id: "36d5658a-6908-479e-887e-a949ec199272",
      readings: [
        %{
          timestamp: "2021-09-29T16:08:15+01:00",
          count: 2
        },
        %{
          timestamp: "2021-09-29T16:09:15+01:00",
          count: 15
        }
      ]
    },
    %{
      id: "36d5658a-6908-479e-887e-a949ec199283",
      readings: [
        %{
          timestamp: "2021-09-29T16:08:15+01:00",
          count: 13
        },
        %{
          timestamp: "2021-09-29T16:09:15+01:00",
          count: 28
        }
      ]
    }
  ]

  @two_devices_with_same_id [
    %{
      id: "36d5658a-6908-479e-887e-a949ec199294",
      readings: [
        %{count: 14, timestamp: "2021-09-29T16:08:15+01:00"},
        %{count: 8, timestamp: "2021-09-29T16:09:15+01:00"}
      ]
    },
    %{
      id: "36d5658a-6908-479e-887e-a949ec199783",
      readings: [
        %{count: 2, timestamp: "2021-09-29T16:08:15+01:00"},
        %{count: 15, timestamp: "2021-09-29T16:09:15+01:00"}
      ]
    },
    %{
      id: "36d5658a-6908-479e-887e-a949ec199294",
      readings: [
        %{count: 13, timestamp: "2021-09-29T16:08:15+01:00"},
        %{count: 28, timestamp: "2021-09-29T16:09:15+01:00"}
      ]
    }
  ]

  # Start the GenServer before running each test.
  setup do
    case DDS.start_link() do
      {:ok, pid} ->
        {:ok, pid: pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid: pid}

      _ ->
        {:error, :GenServerError}
    end
  end

  test "adding maps to the list" do
    DDS.add_data(@two_devices)

    devices = DDS.fetch_all_data()

    assert Enum.member?(devices, %{
             id: "36d5658a-6908-479e-887e-a949ec199272",
             readings: [
               %{
                 timestamp: "2021-09-29T16:08:15+01:00",
                 count: 2
               },
               %{
                 timestamp: "2021-09-29T16:09:15+01:00",
                 count: 15
               }
             ]
           })

    assert Enum.member?(devices, %{
             id: "36d5658a-6908-479e-887e-a949ec199283",
             readings: [
               %{
                 timestamp: "2021-09-29T16:08:15+01:00",
                 count: 13
               },
               %{
                 timestamp: "2021-09-29T16:09:15+01:00",
                 count: 28
               }
             ]
           })
  end
end
