NGSI Load Tester
================

This repository provides a simple Docker image that execute load test on a [Orion Context Broker](https://fiware-orion.readthedocs.io/en/master/) instance (without any authentication mechanism enabled).

The load tester is based on [artillery.io](https://artillery.io), an easy-to-use load testing toolkit. Should you need to customize it, is should not be too difficult ;)

Image Build
-----------
To create the image from the repository, simply execute:

```docker build -t martel/ngsi-load-tester .```

Run the Container
----------------
To run the container, simply execute:

```docker run -e ART_TARGET=orion_context_broker:port martel/ngsi-load-tester```

Where `orion_context_broker` is the ip of the Context Broker instance you want to test and `port` is the active port of the Context Broker.

If you want to test an Orion Context Running in a container, execute:

```docker run --link container_name:orion martel/ngsi-load-tester```

Where `container_name` is the name of the container where your context broker runs.

### Configurable variables

| Variable Name | Description | Default Value  |
| ------------- |-------------------| -----|
| ART_TARGET    | The url of the context broker instance to be tested | `http://localhost:1026` |
| ART_ARRIVALRATE | specify the arrival rate of virtual users for a duration of time     | `5` |
| ART_DURATION | specify the duration of each test      | `10` |
| ART_DEBUG | The debug settings for request and response. Set empty for not printing request and response. Set to `http` to print requests, and to `http:response` to print responses.  `http,http:response` to print both.  | `http,http:response` |

#### Example
```docker run --link ngsiloadtester_orion_1:orion -e ART_DEBUG='' -e ART_ARRIVALRATE=10 -e ART_DURATION=50 martel/ngsi-load-tester```


Example adopted
---------------

The NGSI Load Tester use the data model of the [NGSI API Walkthrough](https://fiware-orion.readthedocs.io/en/master/user/walkthrough_apiv2/index.html#entity-creation).Entities created are of the type `Room` and contain `temperature` and `pressure` attributes.

```{
  "id": "Room1",
  "type": "Room",
  "temperature": {
    "value": 23,
    "type": "Float"
  },
  "pressure": {
    "value": 720,
    "type": "Integer"
  }
}```

Test the container locally
--------------------------

You can run a simple test by launching the example Orion Context Broker compose file, and linking to it.

From the main directory run:

```docker-compose up -d```

```docker run --link ngsiloadtester_orion_1:orion martel/ngsi-load-tester```


HOW TO CONTRIBUTE
-----------------
Make pull requests :)

TODO
----

1. Better divide test in write / read / delete & read and write.
2. Provide instructions on how to export results.
3. Graph generation would be nice.
4. Explore [statsd integration](https://github.com/shoreditch-ops/artillery-plugin-statsd).
