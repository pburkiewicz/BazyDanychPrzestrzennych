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
/* c */
/* d */
/* e */
/* f */
/* g */

/* 13 */

/* a */
/* b */
/* c */
/* d */
/* e */
/* f */


/* 14 */

/* a */
/* b */
/* c */


/* 15 */

/* a */
/* b */
/* c */


