defmodule DeviceManager.DeviceDataStorageTest do
  use DeviceManager.DataCase

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

  describe "validate_data/1" do
    test "Valid data will return true" do
      assert true == DDS.validate_data(@two_devices)
    end

    test "invalid id value will returns a false response" do
      assert false ==
               DDS.validate_data(%{
                 id: "111",
                 readings: [
                   %{count: 6, timestamp: "2021-09-29T16:09:15+01:00"}
                 ]
               })
    end

    test "invalid count value will returns a false response" do
      assert false ==
               DDS.validate_data(%{
                 id: "36d5658a-6908-479e-887e-a949ec199290",
                 readings: [
                   %{count: "", timestamp: "2021-09-29T16:09:15+01:00"}
                 ]
               })
    end

    test "invalid timestamp value will returns a false response" do
      assert false ==
               DDS.validate_data(%{
                 id: "36d5658a-6908-479e-887e-a949ec199290",
                 readings: [
                   %{count: 3, timestamp: "aothni"}
                 ]
               })
    end
  end

  describe "insert_list_of_devices/1" do
    test "confirm device_storage is able to insert data" do
      expected_response = [
        %{
          id: "36d5658a-6908-479e-887e-a949ec199272",
          readings: [
            %{count: 2, timestamp: "2021-09-29T16:08:15+01:00"},
            %{count: 15, timestamp: "2021-09-29T16:09:15+01:00"}
          ]
        },
        %{
          id: "36d5658a-6908-479e-887e-a949ec199283",
          readings: [
            %{count: 13, timestamp: "2021-09-29T16:08:15+01:00"},
            %{count: 28, timestamp: "2021-09-29T16:09:15+01:00"}
          ]
        }
      ]

      assert expected_response ==
               DDS.insert_list_of_devices(@two_devices)
    end

    test "submitted data with the same id will be grouped together" do
      expected_response = [
        %{
          id: "36d5658a-6908-479e-887e-a949ec199294",
          readings: [
            %{count: 14, timestamp: "2021-09-29T16:08:15+01:00"},
            %{count: 8, timestamp: "2021-09-29T16:09:15+01:00"},
            %{count: 13, timestamp: "2021-09-29T16:08:15+01:00"},
            %{count: 28, timestamp: "2021-09-29T16:09:15+01:00"}
          ]
        },
        %{
          id: "36d5658a-6908-479e-887e-a949ec199783",
          readings: [
            %{count: 2, timestamp: "2021-09-29T16:08:15+01:00"},
            %{count: 15, timestamp: "2021-09-29T16:09:15+01:00"}
          ]
        }
      ]

      assert expected_response ==
               DDS.insert_list_of_devices(@two_devices_with_same_id)
    end



    test "when data is submitted out of order, reorder data" do
      expected_response = [
        %{
          id: "8718328d-a58e-4666-9a15-0ab1f4f23e33",
          readings: [
            %{count: 13, timestamp: "2021-09-29T16:08:15+01:00"},
            %{count: 28, timestamp: "2021-09-29T16:09:15+01:00"}
          ]
        },
        %{
         id: "ae83efbd-7ca6-4536-a955-265f2c03f9b6",
         readings: [
           %{count: 2, timestamp: "2021-09-29T16:08:15+01:00"},
           %{count: 15, timestamp: "2021-09-29T16:09:15+01:00"}
         ]
       }
      ]

      assert expected_response ==
               DDS.insert_list_of_devices([
                 %{
                   id: "ae83efbd-7ca6-4536-a955-265f2c03f9b6",
                   readings: [
                     %{
                       count: 2,
                       timestamp: "2021-09-29T16:08:15+01:00"
                     },
                     %{
                       count: 15,
                       timestamp: "2021-09-29T16:09:15+01:00"
                     }
                   ]
                 },
                 %{
                   id: "8718328d-a58e-4666-9a15-0ab1f4f23e33",
                   readings: [
                     %{
                       count: 13,
                       timestamp: "2021-09-29T16:08:15+01:00"
                     },
                     %{
                       count: 28,
                       timestamp: "2021-09-29T16:09:15+01:00"
                     }
                   ]
                 }
               ])
    end

    @tag :skip
    #TODO: Confirm that this is behaving
    test "when duplicate data is present, it is ignored" do
      assert DDS.insert_list_of_devices(@two_devices)

      assert @two_devices == DDS.fetch_all_data
    end
  end
end
