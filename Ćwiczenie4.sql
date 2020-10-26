/* 4 */
SELECT COUNT(DISTINCT gid), f_codedesc, geom INTO tableb FROM popp INNER JOIN 
(SELECT ST_Buffer( geom, 100000, 'endcap=square join=mitre') AS b FROM rivers ) AS buf
ON ( ST_IsEmpty(ST_Intersection(popp.geom, buf.b)) = false ) WHERE popp.f_codedesc='Building';

SELECT DISTINCT(gid), f_codedesc, geom INTO tableb FROM popp INNER JOIN 
(SELECT ST_Buffer( geom, 100000, 'endcap=square join=mitre') AS b FROM rivers ) AS buf
ON ( ST_IsEmpty(ST_Intersection(popp.geom, buf.b)) = false ) WHERE popp.f_codedesc='Building';
/* LUB */
SELECT b.gid, b.f_codedesc, b.geom FROM popp b INNER JOIN (SELECT ST_UNION(geom) AS u FROM majrivers) AS un
ON ST_IsEmpty(ST_Intersection(b.geom, ST_BUFFER( un.u, 100000, 'endcap=square join=mitre'))) = false
WHERE b.f_codedesc='Building' ;

SELECT ST_ASTEXT(ST_Buffer( geom, 10000, 'endcap=square join=mitre')) FROM rivers;

/* 5 */

SELECT name, elev, geom INTO airportsNew FROM airports;

/* a */
SELECT name, ST_ASTEXT(geom) FROM airportsNew ORDER BY ST_Y(geom);
SELECT 'zachod', name FROM airportsNew WHERE ST_Y(geom) =(SELECT min(ST_Y(geom)) FROM airportsNew)
UNION
SELECT 'wschod', name FROM airportsNew WHERE ST_Y(geom)=(SELECT max(ST_Y(geom)) FROM airportsNew);

/* b */
INSERT INTO airportsNew(name, elev, geom) VALUES
('airportB', 400, 
(SELECT ST_POINT((min(ST_X(geom))+max(ST_X(geom)))/2, (min(ST_Y(geom))+max(ST_Y(geom)))/2 ) FROM airportsNew));

/* 6 */
SELECT ST_AREA((ST_BUFFER(ST_ShortestLine(lake.geom, airport.geom), 1000,  'endcap=square join=mitre')))
 FROM lakes lake, airports airport WHERE lake.names='Iliamna Lake' AND airport.name='AMBLER';
 
 /* 7 */

SELECT SUM(forest.area_km2) FROM trees forest INNER JOIN 
(SELECT geom FROM tundra UNION SELECT geom FROM swamp) AS area
ON ST_IsEmpty(ST_Intersection(area.geom, ST_MAKEVALID(forest.geom)))=false;




