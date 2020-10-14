/* 1,2,3,4 */
/*
https://my.vertabelo.com/public-model-view/05HxsuJtjpDq8PXBVwNYUP9hh1Hid3UzojX31U0C74MZ0U1yaqBzjg9h5WpRCpU1?x=2403&y=2646&zoom=0.3854
*/

/* 5 */
/* W osobnym pliku "Zadanie5_Cwiczenie2_create_VERTABELO.sql" wygenerowanym z użyciem Vertabelo.

W konsoli:
psql -U postgres -d s290734 -c "CREATE SCHEMA Sklep;"
psql -U postgres -d s290734 -f Zadanie5_Cwiczenie2_create_VERTABELO_1.sql
*/


/* 6 */

INSERT INTO  sklep.producenci  (nazwa_producenta , mail, telefon) VALUES 
('firma1', 'firma1@firma.pl','111111111'),
('firma2', 'firma2@firma.pl', '222222222'),
('firma3', 'firma3@firma.pl', '333333333'),
('firma4', 'firma4@firma.pl',  '444444444'),
('firma5', 'firma5@firma.pl', '555555555'),
('firma6', 'firma6@firma.pl','666666666'),
('firma7', 'firma7@firma.pl', '777777777'),
('firma8', 'firma8@firma.pl','888888888'),
('firma9', 'firma9@firma.pl', '999999999'),
('firma10', 'firma10@firma.pl', '000000000');


INSERT INTO  sklep.produkty  (nazwa_produktu, cena, id_producenta ) VALUES 
('produkt1', 10.7, 1),
('produkt2', 12.3, 1),
('produkt3', 1.2, 1),
('produkt4', 11.2, 2),
('produkt5', 3.3, 2),
('produkt6', 4.6, 2),
('produkt7', 50.5, 3),
('produkt8', 20.1, 4),
('produkt9', 12.5, 5),
('produkt10', 2.5, 5);


INSERT INTO  sklep.zamowienia  (data, id_produktu, liczba_produktow ) VALUES 
('2020-01-10', 1, 5),
('2020-01-10', 1, 10),
('2020-01-10', 1, 2),
('2020-01-10', 2,2),
('2020-01-10', 2,30),
('2020-01-10', 3,1),
('2020-01-25', 7,4),
('2020-01-26', 8,6),
('2020-01-25', 1,11),
('2020-01-25', 9,33),
('2020-01-25', 9,54),
('2020-01-25', 10,100),
('2020-05-10', 1,32),
('2020-05-10', 2,42),
('2020-05-10', 3,34),
('2020-05-10', 7,7),
('2020-05-10', 7,63),
('2020-05-10', 7,3),
('2020-05-25', 7,23),
('2020-05-26', 8,43),
('2020-05-25', 1,21),
('2020-05-25', 4,12),
('2020-05-25', 4,9),
('2020-05-27', 10,1),
('2020-07-25', 7,5),
('2020-07-03', 6,12),
('2020-07-03', 6,8),
('2020-07-01', 9,12),
('2020-07-01', 9,1),
('2020-07-27', 10,76);


/* 7 */
/* 
W konsoli:
pg_dump -C --format custom -U postgres -d s290734  -f s290734_backup.dmp
*/

/* 8 */
/* 
W konsoli:
psql -U postgres -c "DROP DATABASE s290734";"
*/


/* 9 */
/* 
W konsoli:
pg_restore -C -d postgres -U postgres s290734_backup.dmp
psql --dbname postgres -c 'ALTER DATABASE s290734 RENAME TO backup_s290734;'
*/


/* 10 */
ALTER DATABASE backup_s290734 RENAME TO s290734;

/* 11 */

/* a */
SELECT FORMAT('Producent %s, liczba zamowien %s, wartosc zamowienia %s zl', p.nazwa_producenta,  SUM(ilosc_sztuk), SUM(kwota)) 
FROM sklep.producenci AS p INNER JOIN ( SELECT nazwa_producenta, nazwa_produktu, SUM(liczba_produktow) AS ilosc_sztuk, SUM(liczba_produktow*cena) AS kwota FROM sklep.producenci AS producenci
INNER JOIN sklep.produkty AS produkty ON  produkty.id_producenta = producenci.id_producenta
INNER JOIN sklep.zamowienia AS zamowienia ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY nazwa_producenta, nazwa_produktu) AS x ON p.nazwa_producenta = x.nazwa_producenta GROUP BY p.nazwa_producenta;
/* b */
SELECT FORMAT('Produkt %s, liczba zamowien %s', nazwa_produktu, COUNT(id_zamowienia))
FROM sklep.produkty AS produkty INNER JOIN sklep.zamowienia ON produkty.id_produktu = zamowienia.id_produktu
GROUP BY produkty.id_produktu;

/* c */
SELECT * FROM sklep.produkty NATURAL JOIN sklep.zamowienia;
/* d  */
/*
Pole data zostalo dodane w trakcie tworzenia tabel
*/
 
/* e */
SELECT * FROM sklep.zamowienia WHERE EXTRACT(MONTH FROM data) = 1;
/* f */
SELECT to_char(zamowienia.data,'day') AS dzien_tygodnia, SUM(liczba_produktow) AS suma FROM sklep.zamowienia AS zamowienia
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY dzien_tygodnia ORDER BY suma DESC;

/* g  3 najczesciej kupowane produkty */
SELECT nazwa_produktu, SUM(liczba_produktow) AS suma FROM sklep.zamowienia AS zamowienia
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY nazwa_produktu ORDER BY suma DESC LIMIT 3;

/* 12 */

/* a */
SELECT FORMAT('Produkt %s, ktorego producentem jest %s, zamowiono %s razy', UPPER(nazwa_produktu), LOWER(nazwa_producenta), liczba_produktow) AS opis
FROM sklep.zamowienia AS zamowienia 
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu = produkty.id_produktu
INNER JOIN sklep.producenci AS producenci ON produkty.id_producenta = producenci.id_producenta
ORDER BY liczba_produktow DESC;

/* b */
SELECT zamowienia.id_zamowienia, zamowienia.data, liczba_produktow*cena AS wartosc_zamowienia FROM sklep.zamowienia AS zamowienia  INNER JOIN  sklep.produkty AS produkty 
ON zamowienia.id_produktu = produkty.id_produktu 
ORDER BY wartosc_zamowienia OFFSET 3 ;
/* c */
CREATE TABLE sklep.klienci (id_klienta BIGSERIAL PRIMARY KEY, email VARCHAR, telefon VARCHAR);
INSERT INTO  sklep.klienci (email, telefon) VALUES 
('klient1@klient.pl', '01111111'),
('klient2@klient.pl', '022222222'),
('klient3@klient.pl', '033333333'),
('klient4@klient.pl', '044444444'),
('klient5@klient.pl', '055555555'),
('klient6@klient.pl', '066666666'),
('klient7@klient.pl', '077777777'),
('klient8@klient.pl', '088888888'),
('klient9@klient.pl', '099999999'),
('klient10@klient.pl', '100000000');

/* d */
ALTER TABLE sklep.zamowienia ADD COLUMN id_klienta BIGINT;
ALTER TABLE sklep.zamowienia ADD FOREIGN KEY (id_klienta) REFERENCES klienci(id_klienta);

UPDATE sklep.zamowienia SET id_klienta=1 WHERE id_zamowienia%29 =0;
UPDATE sklep.zamowienia SET id_klienta=2 WHERE id_zamowienia%23 =0;
UPDATE sklep.zamowienia SET id_klienta=5 WHERE id_zamowienia%19 =0;
UPDATE sklep.zamowienia SET id_klienta=6 WHERE id_zamowienia%17 =0;
UPDATE sklep.zamowienia SET id_klienta=9 WHERE id_zamowienia%13 =0;
UPDATE sklep.zamowienia SET id_klienta=10 WHERE id_zamowienia%11 =0;
UPDATE sklep.zamowienia SET id_klienta=3 WHERE id_zamowienia%7 =0;
UPDATE sklep.zamowienia SET id_klienta=4 WHERE id_zamowienia%5 =0;
UPDATE sklep.zamowienia SET id_klienta=7 WHERE id_zamowienia%3 =0;
UPDATE sklep.zamowienia SET id_klienta=8 WHERE id_zamowienia%2 =0;
UPDATE sklep.zamowienia SET id_klienta=3 WHERE id_zamowienia=1;

/* e */
SELECT klienci.id_klienta, klienci.email, produkty.nazwa_produktu, zamowienia.liczba_produktow, zamowienia.liczba_produktow*produkty.cena AS wartosc_zamowienia 
FROM sklep.klienci AS klienci LEFT JOIN sklep.zamowienia AS zamowienia ON zamowienia.id_klienta = klienci.id_klienta
LEFT JOIN sklep.produkty AS produkty ON zamowienia.id_produktu = produkty.id_produktu ORDER BY klienci.id_klienta;

/* f */

(SELECT 'NAJCZESCIEJ ZAMAWIAJACY' AS zamawiajacy, klienci.id_klienta, klienci.email, 
SUM(zamowienia.liczba_produktow) AS suma_zamowien, 
SUM(zamowienia.liczba_produktow*produkty.cena) AS wartosc_zamowienia 
FROM sklep.klienci AS klienci
INNER JOIN sklep.zamowienia AS zamowienia ON zamowienia.id_klienta = klienci.id_klienta
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY klienci.id_klienta
ORDER BY suma_zamowien DESC
LIMIT 1)

UNION ALL

(SELECT 'NAJRZADZIEJ ZAMAWIAJACY' AS zamawiajacy, klienci.id_klienta, klienci.email, 
SUM(zamowienia.liczba_produktow) AS suma_zamowien, 
SUM(zamowienia.liczba_produktow*produkty.cena) AS wartosc_zamowienia 
FROM sklep.klienci AS klienci
INNER JOIN sklep.zamowienia AS zamowienia ON zamowienia.id_klienta = klienci.id_klienta
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu = produkty.id_produktu
GROUP BY klienci.id_klienta
ORDER BY suma_zamowien ASC
LIMIT 1);


/* g */
SELECT produkty.id_produktu FROM sklep.produkty AS produkty 
LEFT JOIN sklep.zamowienia AS zamowienia ON zamowienia.id_produktu = produkty.id_produktu 
WHERE zamowienia.id_produktu IS NULL;

DELETE FROM sklep.produkty WHERE id_produktu IN 
(SELECT produkty.id_produktu FROM sklep.produkty AS produkty 
LEFT JOIN sklep.zamowienia AS zamowienia ON zamowienia.id_produktu = produkty.id_produktu 
WHERE zamowienia.id_produktu IS NULL);

/* 13 */

/* a */
CREATE TABLE numer (liczba DECIMAL(4,0));
/* b */
CREATE SEQUENCE liczba_seq INCREMENT BY 5  MINVALUE 0 MAXVALUE 125 START WITH 100 CYCLE;

/* c */
DO $$
BEGIN
   FOR i IN 1..7 LOOP
      INSERT INTO numer VALUES (nextval('liczba_seq'));                   
   END LOOP;
END $$;

/* d */
ALTER SEQUENCE liczba_seq INCREMENT BY 6;
/* e */
SELECT currval('liczba_seq');
SELECT nextval('liczba_seq');
/* f */
DROP SEQUENCE liczba_seq;

/* 14 */

/* a */

SELECT usename FROM pg_catalog.pg_user ;
/* LUB */
SELECT usename FROM pg_shadow;
/* b */
CREATE USER superuser290734 SUPERUSER LOGIN PASSWORD 'superuser';

CREATE USER guest290734 LOGIN PASSWORD 'guest';
GRANT CONNECT ON DATABASE s290734 TO guest290734;
GRANT USAGE ON SCHEMA sklep, firma  TO guest290734;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep, firma  TO guest290734;

SELECT usename FROM pg_catalog.pg_user;
/* c */
ALTER USER superuser290734  WITH NOSUPERUSER;
ALTER USER superuser290734 RENAME TO student;
ALTER USER student PASSWORD 'student';
GRANT CONNECT ON DATABASE s290734 TO student;
GRANT USAGE ON SCHEMA sklep, firma  TO student;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep, firma  TO student;
DROP USER guest290734;


/* 15 */

/* a */
BEGIN;
UPDATE sklep.produkty SET cena=cena+10;
COMMIT;
/* b */
BEGIN;
UPDATE sklep.produkty SET cena=cena+(cena*0.1) WHERE id_produktu=3;
SAVEPOINT S1;
UPDATE sklep.produkty SET cena=cena+(cena*0.25);
SAVEPOINT S2;
DELETE FROM sklep.klienci WHERE id_klienta = 
(SELECT zamowienia.id_klienta FROM sklep.zamowienia AS zamowienia
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu=produkty.id_produktu
GROUP BY zamowienia.id_klienta
ORDER BY SUM(zamowienia.liczba_produktow) DESC
LIMIT 1);
ROLLBACK TO SAVEPOINT S1;
ROLLBACK TO SAVEPOINT S2;  /* punkt S2 nie istnieje */
ROLLBACK;

/* c */
CREATE OR REPLACE FUNCTION udzial_procentowy() 
RETURNS TABLE(opis TEXT)
AS $$
BEGIN
RETURN QUERY SELECT FORMAT('%s - %s%%', produkty.nazwa_produktu, 
ROUND(100*SUM(zamowienia.liczba_produktow)/(SELECT SUM(liczba_produktow) FROM sklep.zamowienia)))
FROM sklep.zamowienia AS zamowienia
INNER JOIN sklep.produkty AS produkty ON zamowienia.id_produktu=produkty.id_produktu
GROUP BY produkty.nazwa_produktu;
END;
$$ LANGUAGE plpgsql;


