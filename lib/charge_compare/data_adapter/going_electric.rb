# frozen_string_literal: true

require "errors"

module ChargeCompare
  module DataAdapter
    class GoingElectric
      COUNTRY_MAPPING = {
        "Albanien"                => "al",
        "Andorra"                 => "ad",
        "Belarus"                 => "by",
        "Belgien"                 => "be",
        "Bosnien und Herzegowina" => "ba",
        "Bulgarien"               => "bg",
        "Dänemark"                => "dk",
        "Deutschland"             => "de",
        "Estland"                 => "es",
        "Finnland"                => "fi",
        "Frankreich"              => "fr",
        "Großbritannien"          => "gb",
        "Griechenland"            => "gr",
        "Irland"                  => "ie",
        "Island"                  => "is",
        "Italien"                 => "it",
        "Kosovo"                  => "xk",
        "Kroatien"                => "hr",
        "Lettland"                => "lv",
        "Litauen"                 => "lt",
        "Luxemburg"               => "lu",
        "Niederlande"             => "nl",
        "Malta"                   => "mt",
        "Mazedonien"              => "mk",
        "Monaco"                  => "mc",
        "Norwegen"                => "no",
        "Moldawien"               => "md",
        "Polen"                   => "pl",
        "Portugal"                => "pt",
        "Russland"                => "ru",
        "Schweden"                => "se",
        "Schweiz"                 => "ch",
        "Serbien"                 => "rs",
        "Slowakei"                => "sk",
        "Slowenien"               => "sl",
        "Spanien"                 => "es",
        "Tschechien"              => "cz",
        "Türkei"                  => "tr",
        "Ukraine"                 => "ua",
        "Ungarn"                  => "hu",
        "Österreich"              => "at"
      }.freeze

      DC_CURRENT_TYPES = Set["CCS", "CHAdeMO", "Tesla Supercharger", "Tesla HPC"]

      class << self
        def map(dto)
          dto.station.region = map_country(dto.station.region)
          dto.station.connectors.each do |c|
            c.energy = map_dc_current_type(c.plug)
          end
          dto
        end

        def map_country(ge_country)
          COUNTRY_MAPPING.fetch(ge_country) do
            raise Errors::RequestInvalid.new("#{ge_country} is an invalid country")
          end
        end

        def map_dc_current_type(plug)
          DC_CURRENT_TYPES.include?(plug) ? "dc" : "ac"
        end
      end
    end
  end
end
