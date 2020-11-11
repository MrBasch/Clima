BEGIN TRANSACTION;

--
-- Paises
--
DROP TABLE IF EXISTS countries CASCADE;
CREATE TABLE countries(
    pk bigserial NOT NULL, -- Autoincremental
    name_es varchar(255) NOT NULL, -- Nombre en español
    name_en varchar(255) NOT NULL,  -- Nombre en ingles
    name_fr varchar(255) NOT NULL, -- Nombre en frances
    iso2 varchar(2) NOT NULL,  -- Código iso2
    iso3 varchar(3) NOT NULL,  -- Código iso3
    phone_code varchar(255) NOT NULL, -- Código teléfonico del pais
    UNIQUE (iso2),
    UNIQUE (iso3),
    UNIQUE (name_es, name_en, name_fr),
    PRIMARY KEY (pk)
);
CREATE UNIQUE INDEX ON countries(UPPER(TRIM(both FROM iso2)));
CREATE UNIQUE INDEX ON countries(UPPER(TRIM(both FROM iso3)));


--
-- Estaciones meteorologicas 
--

DROP TABLE IF EXISTS stations CASCADE;
CREATE TABLE stations(
    pk bigserial NOT NULL, -- Autoincremental
    country_fk bigint NOT NULL, -- pais
    icao varchar(255) NOT NULL, -- código ICAO
    name varchar(255) NOT NULL, -- Nombre estacion
    latitude double precision NOT NULL, 
    longitude double precision NOT NULL,
    elevation int NOT NULL,
    FOREIGN KEY (country_fk) REFERENCES countries(pk) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (icao),
    PRIMARY KEY (pk)
);
CREATE UNIQUE INDEX ON stations(UPPER(TRIM(both FROM icao)));
CREATE INDEX ON stations(country_fk);


--
-- Tabla que almacena la informacion del clima
--
DROP TABLE IF EXISTS climates CASCADE;
CREATE TABLE climates(
    pk bigserial NOT NULL, -- Autoincremental
    station_fk bigint NOT NULL, -- referencia a la estacion que ingresa los datos
    wind_direction varchar(255) NOT NULL, -- Texto ejemplo '210 (SSW)'
    wind_speed numeric NOT NULL DEFAULT '0' CHECK(wind_speed >=0), -- Expresado en km/h
    visibility numeric NOT NULL DEFAULT '0', -- Escalar
    temperature numeric NOT NULL DEFAULT '0', -- Expresado en °C
    dewpoint numeric NOT NULL DEFAULT '0', --Expresado en °C
    pressure numeric NOT NULL DEFAULT '0', -- Expresado en hPa
    created timestamp NOT NULL DEFAULT NOW(),
    FOREIGN KEY (station_fk) REFERENCES stations(pk) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (pk)
);
CREATE INDEX ON climates(station_fk);

COMMIT;
