/* 1,2,3,4 */
/*
https://my.vertabelo.com/public-model-view/05HxsuJtjpDq8PXBVwNYUP9hh1Hid3UzojX31U0C74MZ0U1yaqBzjg9h5WpRCpU1?x=2403&y=2646&zoom=0.3854
*/

/* 5 */
/* W osobnym pliku "Zadanie5_Cwiczenie2_create_VERTABELO.sql" wygenerowanym z użyciem Vertabelo.

W konsoli:
psql -U postgres -d s290734 -c "CREATE SCHEMA Sklep;"


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


INSERT INTO  sklep.produkty  (nazwa_produktu, cena, Producenci_id_producenta ) VALUES 
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


INSERT INTO  sklep.zamowienia  (data, Produkty_id_produktu  ) VALUES 
('2020-01-10', 1),
('2020-01-10', 1),
('2020-01-10', 1),
('2020-01-10', 2),
('2020-01-10', 2),
('2020-01-10', 3),
('2020-01-25', 7),
('2020-01-26', 8),
('2020-01-25', 1),
('2020-01-25', 9),
('2020-01-25', 9),
('2020-01-25', 10),
('2020-05-10', 1),
('2020-05-10', 2),
('2020-05-10', 3),
('2020-05-10', 7),
('2020-05-10', 7),
('2020-05-10', 7),
('2020-05-25', 7),
('2020-05-26', 8),
('2020-05-25', 1),
('2020-05-25', 4),
('2020-05-25', 4),
('2020-05-27', 10),
('2020-07-25', 7),
('2020-07-03', 6),
('2020-07-03', 6),
('2020-07-01', 9),
('2020-07-01', 9),
('2020-07-27', 10);


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
/* b */
/* c */
/* d */
/* e */
/* f */
/* g */

/* 12 */

/* a */
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


