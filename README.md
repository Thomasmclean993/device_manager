# Field Device Data Management API (Project summary)
The Field Device Data Management API is a comprehensive solution for recording, storing, and retrieving data from field devices over the internet. This API provides seamless data management capabilities to efficiently manage and monitor field device readings.

## Prerequisites
 * Elixir (v1.14 or later)
 * Phoenix Framework (v1.6 or later)

## Installation/Start up
1. Clone the project: https://github.com/Thomasmclean993/device_manager.git
2. Setup the project: 
 * cd `device_manager`
 * Run `mix setup` to install and setup dependencies
 * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
3. Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# API Documentation
## Features
### Record and Store Data
The API enables users to upload reading data collected from field devices, encompassing measurements like counts, timestamps, and pertinent parameters. 

### Retrieve Device Data
Users can retrieve the recorded data for a specific field device by passing its unique ID. The API responds with the complete set of readings associated with the device, offering insights into historical trends and performance metrics.

## Usage
### /api/store
This endpoint accepts reading data from field devices and stores it. The data must include the device ID, counts, timestamps, and any additional relevant information.
 * REQUIRED FIELDS: ID, READINGS, COUNT, TIMESTAMP
 * Readings fields are required but can by out of order
 * Duplicate data for a specific field device will not be recorded
 * Incomplete or malformed data will result in an error

```
curl --location 'localhost:4000/api/store?' \
--header 'Content-Type: application/json' \
--header 'content_type: application/json' \
--data '{ 
"id": "36d5658a-6908-479e-887e-a949ec199272", 
"readings": [{ 
"timestamp": "2021-09-29T16:08:15+01:00", 
"count": 2 
}, { 
"timestamp": "2021-09-29T16:09:15+01:00", 
"count": 15 
}] 
}'
```

### /api/readings/:id
This endpoint retrieves the stored readings for a specific device identified by its ID. The API responds with a collection of readings, including counts, timestamps, and other relevant information
 * A device id that is not found in the system will result in a not found error
``` 
curl --location --request GET 'localhost:4000/api/show?id=36d5658a-6908-479e-887e-a949ec199272' \
--header 'Content-Type: application/json' \
--header 'content_type: application/json' \
--data '{ 
"id": "36d5658a-6908-479e-887e-a949ec199272", 
"readings": [{ 
"timestamp": "2021-09-29T16:08:17+01:00", 
"count": 15
},
{ 
"timestamp": "2021-09-29T16:08:15+01:00", 
"count": 2 
} ,{ 
"timestamp": "2021-09-29T16:09:15+01:00", 
"count": 15 
}] 
}'
```

# Project Reflection
## What are some roadblocks did I run into with this project? 
  * Duplication Logic Issue: I faced an initial challenge with the GenServer not performing as expected while attempting to prevent the storage of devices with duplicate data. Gen servers handle concurrency, and when dealing with operations that involve checking and modifying state, you need to be careful with managing these operations to avoid race conditions and unexpected behavior. In my case, the reset state logic wasn't handling ongoing processes correctly, leading to tests failing. Once I fixed the runaway processes, this ensured the proper termination and cleanup of processes within the GenServer.
* Required Fields Solution: My initial implementation for the required fields was a massive file   of function after function calls, pattern matching, and the works. Headache to test and     took much time. In short, it was a smell. So I decided to leverage the changeset logic in the Phoenix framework. Relying on this reliable framework significantly simplified my codebase and improved maintainability. 

## If I had more time, what part of your project would you refactor? 
I would refactor the Genserver:
* Load testing
* Resource management: State management, Long running processes, Better Messaging
* Utilize more async operations: Genstagers that create task pipelines, Async callbacks, and task supervisor, that could off load tasks that does need to be executed in a synchronous manner. 



### What other trade offs were made?
* Test Coverage can be improved
* Naming Conventions
* Better Error Messages (etc, request structure is malformed, sent a error message explaining that)
* Adding typespecs 

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

