# Plugcheccker API

Provides prices of charging cards for EV charging stations.

See [Plugchecker Client](https://github.com/hoenic07/plugchecker-client) for the Web Client.

## Supported Charging Card Providers

More to come, but the following are already included:

- ADAC
- BEW
- Enel
- ELLA
- EnBW
- Energie Burgenland
- Energie Steiermark
- E.ON
- Hamburg Energie
- Kelag
- Linz AG
- Innogy
- Maingau Energie
- New Motion
- Plugsurfing
- Rheinhessische
- Smatrics
- Telekom Ladestrom
- Tesla Supercharging
- TIWAG
- VKW
- Wien Energie

## Setup

1. Install Ruby
2. Install Bundler `gem install bundler`
3. Install Dependencies `bundle`
4. Create `config/.env.development` file with:
  
    ```
    PLUGSURFING_KEY= # See https://www.plugsurfing.com/de/geschaeftskunden/ladestationsbetreiber.html
    ```
5. Run service `rackup`


## Contribution

Please contact me (niklas@plugchecker.com).

