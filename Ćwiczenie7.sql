/* 
W repozytorium znajdują się screeny niektórych rozwiązań sprawdzonych w QGisie.
Niestety nie wszystkie wyniki wyglądają zadowalająco. Część z nich jest dziwnie ucięta, 
jednak po eksporcie do formatu .tiff wyglądają prawidłowo.
*/
CREATE DATABASE raster;
\c raster
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;

-- pg_restore -U postgres -d raster postgis_raster.backup
\c raster
ALTER SCHEMA schema_name RENAME TO burkiewicz;

-- import 


-- ładowanie rastru przy użyciu pliku .sql
-- "C:\Program Files\PostgreSQL\12\bin\raster2pgsql.exe" -s 3763 -N -32767 -t 100x100 -I -C -M -d .\srtm_1arc_v3.tif rasters.dem > .\dem.sql

-- ładowanie rastru bezpośrednio do bazy
-- "C:\Program Files\PostgreSQL\12\bin\raster2pgsql.exe" -s 3763 -N -32767 -t 100x100 -I -C -M -d .\srtm_1arc_v3.tif rasters.dem | psql -d raster -h localhost -U postgres -p 5432


-- załadowanie danych landsat 8 o wielkości kafelka 128x128 bezpośrednio do bazy danych
-- "C:\Program Files\PostgreSQL\12\bin\raster2pgsql.exe" -s 3763 -N -32767 -t 128x128 -I -C -M -d .\Landsat8_L1TP_RGBN.TIF rasters.landsat8 | psql -d raster -h localhost -U postgres -p 5432


-- Przecięcie z wektorem
CREATE TABLE burkiewicz.intersects AS
SELECT raster.rast, vector.municipality 
FROM rasters.dem AS raster, vectors.porto_parishes AS vector
WHERE ST_Intersects(raster.rast, vector.geom) AND vector.municipality = 'PORTO';

-- klucz glówny
ALTER TABLE burkiewicz.intersects ADD COLUMN raster_id SERIAL PRIMARY KEY;

-- index przestrzenny convexhull- otoczka wypukla
CREATE INDEX idx_intersects_rast_gist ON burkiewicz.intersects USING gist (ST_ConvexHull(rast));

-- 
SELECT AddRasterConstraints('burkiewicz'::name, 'intersects'::name,'rast'::name);

-- Obcinanie rastra
CREATE TABLE burkiewicz.clip AS
SELECT ST_CLIP(raster.rast, vector.geom, true), vector.municipality
FROM rasters.dem AS raster, vectors.porto_parishes AS vector
WHERE ST_Intersects(raster.rast, vector.geom) AND vector.municipality = 'PORTO';

-- łączenie kafelków
CREATE TABLE burkiewicz.union AS
SELECT ST_UNION(ST_CLIP(raster.rast, vector.geom, true))
FROM rasters.dem AS raster, vectors.porto_parishes AS vector
WHERE ST_Intersects(raster.rast, vector.geom) AND vector.municipality = 'PORTO';

-- tworzenie rastra z wektorów
-- osobne parafie
CREATE TABLE burkiewicz.porto_parishes AS
WITH raster AS (SELECT rast FROM rasters.dem LIMIT 1) 
SELECT ST_AsRaster(vector.geom, raster.rast, '8BUI', vector.id, -32767) 
AS rast FROM vectors.porto_parishes AS vector, raster 
WHERE vector.municipality = 'PORTO';

-- parafie razem
DROP TABLE burkiewicz.porto_parishes;
CREATE TABLE burkiewicz.porto_parishes AS
WITH raster AS (SELECT rast FROM rasters.dem LIMIT 1) 
SELECT ST_UNION(ST_AsRaster(vector.geom,raster.rast,'8BUI',vector.id,-32767)) 
AS rast FROM vectors.porto_parishes AS vector, raster 
WHERE vector.municipality = 'PORTO';

-- parafie rozdzielone ST_TILE
DROP TABLE burkiewicz.porto_parishes;
CREATE TABLE burkiewicz.porto_parishes AS
WITH raster AS (SELECT rast FROM rasters.dem LIMIT 1) 
SELECT ST_TILE(ST_UNION(ST_AsRaster(vector.geom,raster.rast,'8BUI',vector.id,-32767)),128,128,true,-32767) 
AS rast FROM vectors.porto_parishes AS vector, raster 
WHERE vector.municipality = 'PORTO';

-- wektoryzowanie
-- 1
CREATE TABLE burkiewicz.intersection AS
SELECT raster.rid,(ST_Intersection(vector.geom, raster.rast)).geom,(ST_Intersection(vector.geom,raster.rast)).val 
FROM rasters.landsat8 AS raster, vectors.porto_parishes AS vector 
WHERE lower(vector.parish) = 'paranhos' and ST_Intersects(vector.geom, raster.rast);

-- 2
CREATE TABLE burkiewicz.dumppolygons AS 
SELECT raster.rid,(ST_DumpAsPolygons(ST_Clip(raster.rast,vector.geom))).geom,
(ST_DumpAsPolygons(ST_Clip(raster.rast,vector.geom))).val 
FROM rasters.landsat8 AS raster, vectors.porto_parishes AS vector
WHERE lower(vector.parish) = 'paranhos' and ST_Intersects(vector.geom, raster.rast);

-- analiza rastrów 

-- ST_BAND - wyciągnięcie pasma
CREATE TABLE burkiewicz.landsat_nir AS 
SELECT rid, ST_Band(rast, 4) AS rast
FROM rasters.landsat8;

-- ST_Clip - wybranie tylko jednej parafi z rastra
CREATE TABLE burkiewicz.paranhos_dem  AS
SELECT  raster.rid, ST_Clip(raster.rast, vector.geom, true)
FROM rasters.dem AS raster, vectors.porto_parishes AS vector
WHERE ST_Intersects(raster.rast, vector.geom) AND lower(vector.parish) = 'paranhos';

-- ST_SLOPE - nachylenie terenu
CREATE TABLE burkiewicz.paranhos_slope AS
SELECT paranhos.rid, ST_Slope(paranhos.st_clip,1,'32BF','PERCENTAGE') 
FROM burkiewicz.paranhos_dem AS paranhos;

-- ST_Reclass - podział na klasy wedlug zadanej funkcji (przyklad wedlug procentowego nachylenia)
CREATE TABLE burkiewicz.paranhos_slope_reclass AS 
SELECT paranhos_slope.rid, 
ST_Reclass(paranhos_slope.st_slope,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
AS rast
FROM burkiewicz.paranhos_slope AS paranhos_slope;

-- ST_SummaryStats - parametry count, sum, mean, stddev, min, max 
SELECT ST_Summarystats(paranhos.st_clip) AS stats
FROM burkiewicz.paranhos_dem AS paranhos;

-- ST_SummaryStats z ST_Union
SELECT ST_SummaryStats(ST_UNION(paranhos.st_clip)) AS stats
FROM burkiewicz.paranhos_dem AS paranhos;

-- ST_SummaryStats - kontrola złożonego typu danych
WITH t AS (
	SELECT ST_SummaryStats(ST_UNION(paranhos.st_clip)) AS stats 
	FROM burkiewicz.paranhos_dem AS paranhos
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;

-- Wyświetlenie statystyk dla każdej z parafii
SELECT parish, (stats).count, (stats).min, (stats).max, (stats).mean FROM (
	SELECT vector.parish AS parish, ST_SummaryStats(ST_Union(ST_Clip(raster.rast, vector.geom, true))) AS stats
	FROM rasters.dem AS raster, vectors.porto_parishes AS vector 
	WHERE ST_Intersects(vector.geom, raster.rast) AND vector.municipality = 'PORTO' GROUP BY parish
) AS val;

-- ST_Value - podaje wartość piksela na kolejnych pasmach
SELECT vector.name, st_value(raster.rast,(ST_Dump(vector.geom)).geom)
FROM rasters.dem raster, vectors.places AS vector
WHERE ST_Intersects(raster.rast, vector.geom) ORDER BY vector.name;

-- ST_TPI - podaje, czy dana komórka ma większą, czy mniejszą wysokość niż średnia wartość w określonym sąsiedztwie
CREATE TABLE burkiewicz.tpi30 AS
SELECT ST_TPI(rast,1) as rast from rasters.dem;

CREATE INDEX idx_tpi30_rast_gist ON burkiewicz.tpi30 
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('burkiewicz'::name, 'tpi30'::name,'rast'::name);

-- ST_TPI dla Porto

CREATE TABLE burkiewicz.tpi30Porto AS
SELECT ST_TPI(raster.rast, 1)
FROM rasters.dem AS raster, vectors.porto_parishes AS vector
WHERE ST_Intersects(raster.rast, vector.geom) AND vector.municipality = 'PORTO';

CREATE INDEX idx_tpi30porto_rast_gist ON burkiewicz.tpi30Porto
USING gist (ST_ConvexHull(st_tpi));

SELECT AddRasterConstraints('burkiewicz'::name, 'tpi30porto'::name,'st_tpi'::name);

-- algebra map
-- 1 Wyrażenie algebry map
CREATE TABLE burkiewicz.porto_ndvi AS 
WITH r AS (
	SELECT raster.rid, ST_Clip(raster.rast, vector.geom,true) AS rast 
	FROM rasters.landsat8 AS raster, vectors.porto_parishes AS vector
	WHERE vector.municipality ='PORTO' and ST_Intersects(vector.geom,raster.rast)
)
SELECT r.rid, ST_MapAlgebra(r.rast, 1, r.rast, 4,'([rast2.val] -[rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF') AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON burkiewicz.porto_ndvi 
USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('burkiewicz'::name, 'porto_ndvi'::name,'rast'::name);

-- 2 Funkcja zwrotna
CREATE OR REPLACE FUNCTION burkiewicz.ndvi(value double precision [] [] [], pos integer [][],VARIADIC userargs text [])
RETURNS double precision AS
	$$ BEGIN
		--RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug purposes
		RETURN (value [2][1][1] -value [1][1][1])/(value [2][1][1]+value [1][1][1]); 
		--> NDVI calculation!
	END; $$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;

CREATE TABLE burkiewicz.porto_ndvi2 AS 
WITH r AS (
	SELECT raster.rid, ST_Clip(raster.rast, vector.geom,true) AS rast
	FROM rasters.landsat8 AS raster, vectors.porto_parishes AS vector
	WHERE vector.municipality = 'PORTO' and ST_Intersects(vector.geom,raster.rast)
)
SELECT r.rid, ST_MapAlgebra(r.rast, ARRAY[1,4],'burkiewicz.ndvi(double precision[], integer[],text[])'::regprocedure, '32BF'::text) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi2_rast_gist ON burkiewicz.porto_ndvi2
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('burkiewicz'::name, 'porto_ndvi2'::name,'rast'::name);

-- Eksport danych
-- ST_AsTiff
SELECT ST_AsTiff(ST_Union(rast)) FROM burkiewicz.porto_ndvi;

-- ST_AsGDALRaster
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM burkiewicz.porto_ndvi;

-- eksport na dysk
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
					 ST_AsGDALRaster(
						 ST_Union(st_slope), 
						 'GTiff',  
						 ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9']
					 )
					) AS loid
FROM burkiewicz.paranhos_slope;
		
SELECT lo_export(loid, 'D:\Studia\Informatyka IV rok\Bazy danych przestrzennych\paranhos_slope.tiff') FROM tmp_out;
SELECT lo_unlink(loid) FROM tmp_out; 
