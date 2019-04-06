# POST /v1/charge_prices

Gets the prices of available tariffs for a single charge, given a set of options (duration, kwh).

This API follows the https://jsonapi.org specification.

## Headers

* `API-Key: <your_api_key>` (contact niklas@plugchecker.com to get access)
* `Content-Type: application/json`

## Request

The following fields are to be sent in the request body, in the `attributes` section of a `charge_prices_request` object:

| **Name**                          | **Type**      | **Presence**              | **Example**      | **Description**                                                                                                          |
| --------------------------------- | ------------- | ------------------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------ |
| data_adapter                      | string        | mandatory                 | "going_electric" | The source of the station and charge_card_id data. Possible values: "going_electric"                                     |
| station                           | Object        | mandatory                 |                  | Station related request data                                                                                             |
| station.longitude                 | Float         | mandatory                 | 43.123           | Longitude coordinate of the station                                                                                      |
| station.latitude                  | Float         | mandatory                 | 123.456          | Latitude coordinate of the station                                                                                       |
| station.country                   | String        | mandatory                 | "Deutschland"    | Country in which the station is located                                                                                  |
| station.network                   | String        | mandatory                 | "Wien Energie"   | Network to which the station belongs to.                                                                                 |
| station.charge_points             | Array[Object] | mandatory                 |                  | All kinds of connectors that are available at a station.                                                                 |
| station.charge_points.power       | Float         | mandatory                 | 22               | In kW                                                                                                                    |
| station.charge_points.plug        | String        | mandatory                 | "CCS"            | Name of plug at charge point                                                                                             |
| options                           | Object        | mandatory                 |                  | Charge related request data                                                                                              |
| options.energy                    | Float         | mandatory                 | 30               | To be consumed energy of the charge in kWH                                                                               |
| options.duration                  | Float         | mandatory                 | 45               | Duration of the charge in minutes                                                                                        |
| options.car_ac_phases             | Integer       | optional (default: 3)     | 3                | Number of AC phases the car can use to charge. Possible values: 1,3                                                      |
| options.currency                  | String        | optional (default: "eur") | "eur"            | Currency in which the prices should be returned. Possible values: "eur" (Euro)                                           |
| options.provider_customer_tariffs | Boolean       | optional (default: false) | false            | Include prices of tariffs, that are only available for customers of a provider (e.g. electricity provider for the home). |
| charge_card_ids                   | Array[Float]  | mandatory                 | ["30"]           | IDs of available charge cards. Only prices for the provided charge cards will be returned.                               |

## Response Body

A response contains 0 to many `charge_price` objects, which define the prices per charge of a tariff per connector.
The following table lists the `attributes` of these objects:

| **Name**                  | **Type**       | **Example**         | **Description**                                                                                         |
| ------------------------- | -------------- | ------------------- | ------------------------------------------------------------------------------------------------------- |
| provider                  | String         | "Maingau Energie"   | Name of the charge card provider                                                                        |
| tariff                    | String or null | "EinfachStromLaden" | Name of the tariff, if available                                                                        |
| monthly_min_sales         | Float          | 12.49               | Minimum charging costs per month                                                                        |
| total_monthly_fee         | Float          | 12.30               | Any monthly fee + any yearly (service) fee (proportional)                                               |
| is_flat_rate              | Boolean        | true                | Given a monthly fee, charging with this tariff is at no extra cost for a single charge                  |
| provider_customer_only    | Boolean        | true                | If true, tariff is only available for customers of a provider (e.g. electricity provider for the home). |
| currency                  | String         | "eur"               | Currency of the prices or fees                                                                          |
| charge_point_prices       | Array[Object]  |                     |                                                                                                         |
| charge_point_prices.plug  | String         | "ac"                | Name of plug at charge point                                                                            |
| charge_point_prices.power | Float          | 22                  | In kW                                                                                                   |
| charge_point_prices.price | Float          | 8.43                | Cost of a single charge at the given connector, given the options of the request                        |

## Example

### Request

```http
POST http://example-base-url.com/v1/charge_prices
Content-Type: application/json
Api-Key: my-secret-key
```

Body:
```json
{
  "data": {
    "type":       "charge_price_request",
    "attributes": {
      "data_adapter": "going_electric",
      "station":         {
        "longitude":  14.13117,
        "latitude":   48.289453,
        "country":    "Deutschland",
        "network":    "Wien Energie",
        "connectors": [
          {
            "power":  22,
            "plug":   "CCS"
          }
        ]
      },
      "options":         {
        "energy":   30,
        "duration": 30
      },
      "charge_card_ids": [
        "274"
      ]
    }
  }
}
```

### Response

#### 200 Ok

Body:
```json
{
  "data": [
    {
      "id": "dcb281b8-f4f3-470c-938b-5f94cb265f6a",
      "type": "charge_price",
      "attributes": {
        "provider": "Maingau Energie",
        "tariff": "EinfachStromLaden",
        "monthly_min_sales": 0,
        "total_monthly_fee": 0,
        "is_flat_rate": false,
        "provider_customer_only": false,
        "currency": "eur",
        "charge_point_prices": [
          {
            "power":  22,
            "plug":   "CCS",
            "price":  12
          }
        ]
      }
    }
  ]
}

```

##### 400 Bad Request

Client provided invalid request body.

```json
{
  "errors": [
    {
      "status": "400",
      "title": "..."
    }
  ]
}
```

##### 403 Forbidden

* API-Key is missing
* API-Key is invalid
* API-Key not authorized to perform action

```json
{
  "errors": [
    {
      "status": "403",
      "title": "api_key missing"
    }
  ]
}
```

##### 500 Internal Server Error

An unexpected error happened.

```json
{
  "errors": [
    {
      "status": "403",
      "title": "api_key missing"
    }
  ]
}
```
