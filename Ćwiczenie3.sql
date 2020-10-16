/* 1 - zainstalowano postgisa */
/* 2 */
CREATE DATABASE cwiczenie3;

/* 3 */
CREATE EXTENSION postgis;

/* 4 */
CREATE TABLE budynki (id SERIAL, geometria GEOMETRY, nazwa VARCHAR);
CREATE TABLE drogi (id SERIAL, geometria GEOMETRY, nazwa VARCHAR);
CREATE TABLE punkty_informacyjne (id SERIAL, geometria GEOMETRY(POINT), nazwa VARCHAR);

/* 5 */
INSERT INTO punkty_informacyjne (geometria, nazwa) VALUES 
( ST_POINT(1, 3.5), 'G'),
( ST_POINT(5.5, 1.5), 'H'),
( ST_POINT(9.5, 6), 'I'),
( ST_POINT(6.5, 6), 'J'),
( ST_POINT(6, 9.5), 'K');

INSERT INTO drogi (geometria, nazwa) VALUES 
( ST_MAKELINE(ST_POINT(0,4.5), ST_POINT(12, 4.5)), 'RoadX'),
( ST_MAKELINE(ST_POINT(7.5,0), ST_POINT(7.5, 10.5)), 'RoadX');

INSERT INTO budynki (geometria, nazwa) VALUES 
(ST_MakeEnvelope( 8, 1.5, 10.5, 4), 'BuildingA'),
(ST_MakeEnvelope( 4, 5, 6, 7), 'BuildingB'), 
(ST_MakeEnvelope( 3, 6, 5, 8), 'BuildingC'), 
(ST_MakeEnvelope( 9, 8, 10, 9), 'BuildingD'), 
(ST_MakeEnvelope( 1, 1, 2, 2), 'BuildingF');

SELECT ST_Distance(a.geometria, b.geometria)
FROM punkty_informacyjne a, punkty_informacyjne b
WHERE a.id=3 AND b.id=4;

/* 6 */

/* a */
SELECT SUM(ST_LENGTH(geometria)) FROM drogi;
/* b */
SELECT ST_AsText(geometria), ST_AREA(geometria), ST_Perimeter(geometria) FROM budynki WHERE nazwa='BuildingA';
/* c */
SELECT nazwa, ST_AREA(geometria) FROM budynki ORDER BY nazwa;
/* d */
SELECT nazwa, ST_Perimeter(geometria) FROM budynki ORDER BY ST_AREA(geometria) LIMIT 2;
/* e */
SELECT ST_LENGTH(ST_ShortestLine(building.geometria, point.geometria)) 
FROM budynki building, punkty_informacyjne point 
WHERE building.nazwa='BuildingC' AND point.nazwa='G';

SELECT ST_Distance(building.geometria, point.geometria)
FROM budynki building, punkty_informacyjne point 
WHERE building.nazwa='BuildingC' AND point.nazwa='G';
/* f */
SELECT ST_AREA( ST_Difference(c.geometria, ST_Buffer(b.geometria, 0.5, 'join=mitre side=left'))) 
FROM budynki c, budynki b 
WHERE c.nazwa='BuildingC' AND b.nazwa='BuildingB';

/* g */
SELECT b.nazwa FROM budynki b, drogi d WHERE d.nazwa='RoadX' AND ST_Y(ST_Centroid(b.geometria)) > ST_Y(ST_PointN(d.geometria,1)); 

SELECT ST_AREA( ST_Difference(geometria, ST_MakePolygon('LINESTRING(4 7, 6 7, 6 8, 4 8, 4 7)'))) 
FROM budynki 
WHERE nazwa='BuildingC';

