# Integrate Charge Prices into your Application

## Beta Program

The purpose of the Beta Program is to give applications access to  the Plugchecker 3rd Party API for a limited period in order to verify the API's featureset.

The following data can be used:

* API-Key: `9qV1VKXUxasNkks6K95AUjOjTWxyGvFR` 
* Base-Url: `https://charge-compare.herokuapp.com`

Considerations:

* In the Beta Program you won't get an extra API-Key as described in Step 1 below
* The API should only be used for testing purposes and should NOT be integrated into production applications yet!
* After the Beta Program ends, the API-Key will be disabled and the Base-Url might change as well!
* Due to adaptations, breaking changes might be introduced to the interface during the Beta Program.
* The usage of the interface during the Beta Program is free of charge.
* Be nice and don't DDoS the API!
* GitHub is the main feedback channel! Use this thread: [3rd Party API Feedback](https://github.com/hoenic07/plugchecker/issues/38)

## Steps

### 1. Contact Plugchecker

Please contact niklas@plugchecker.com and tell us about your application!
We provide you with an API-Key then.

### 2. Register + Integrate the Going Electric API

At the moment the charging price calculation of Plugchecker depends on charging station data, that is provided by the Going Electric API: https://www.goingelectric.de/stromtankstellen/api/

In the future other providers of station data might be supported.

Once your application can get `chargepoint` details, you can move on to step 2:

### 3. Map Going Electric API with Plugchecker API

Here you can find the interface documention of the [Charge Prices API](../api/v1/charge_prices/index.md) of Plugchecker.

You will need to map the data of Going Electric to the following attributes in Plugchecker:

| **Going Electric** | **Plugchecker**          | **Transformation** |
| ------------------ | ------------------------ | ------------------ |
| address.country    | station.country          | -                  |
| network            | station.network          | false -> null      |
| coordinates.lng    | station.longitude        | -                  |
| coordinates.lat    | station.latitude         | -                  |
| chargepoints.power | station.connectors.power | -                  |
| chargepoints.type  | station.connectors.plug  | -                  |
| chargecards.id     | charge_card_ids          | -                  |