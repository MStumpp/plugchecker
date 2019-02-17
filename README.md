# Charge Compare API

Provides prices of charging cards for EV charging stations.

See [Charge Compare Client](https://github.com/hoenic07/charge-compare-client) for the Web Client.

## API

`GET  https://charge-compare.herokuapp.com/v1/stations/:station_id/station_tariffs`

### Parameters

- `station_id`: Id of the charging station from GoingElectric.de

## Supported Charging Card Providers

More to come, but the following are already included:

- ELLA
- EnBW
- Energie Steiermark
- Linz AG
- Maingau Energie
- Smatrics
- Tesla Supercharging
- Wien Energie
- Plugsurfing

## Setup

1. Install Ruby
2. Install Bundler `gem install bundler`
3. Install Dependencies `bundle`
4. Create `config/.env.development` file with:
  
    ```
    GOING_ELECTRIC_KEY= # See https://www.goingelectric.de/stromtankstellen/api/
    PLUGSURFING_KEY= # See https://www.plugsurfing.com/de/geschaeftskunden/ladestationsbetreiber.html
    ```
5. Run service `rackup`


## Contribution

Please contact me (nik.hoesl@hotmail.com).

