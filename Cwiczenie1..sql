/* 1 */
CREATE DATABASE s290734 ;
/* 2 */
CREATE SCHEMA firma;
/* 3 */
CREATE ROLE ksiegowosc;
GRANT SELECT ON ALL TABLES IN SCHEMA firma to ksiegowosc;
/* 4 */
/* a */
SET search_path TO firma;
CREATE TABLE pracownicy (id_pracownika SERIAL UNIQUE NOT NULL, imie VARCHAR , nazwisko VARCHAR, adres VARCHAR, telefon VARCHAR);
CREATE TABLE godziny (id_godziny SERIAL UNIQUE NOT NULL, data DATE, liczba_godzin INTEGER, id_pracownika BIGINT);
CREATE TABLE pensja_stanowisko (id_pensji SERIAL UNIQUE NOT NULL, stanowisko VARCHAR, kwota NUMERIC(10,2));
CREATE TABLE premia  (id_premii SERIAL UNIQUE NOT NULL, rodzaj VARCHAR, kwota NUMERIC(10,2));
CREATE TABLE wynagrodzenie (id_wynagrodzenia SERIAL UNIQUE NOT NULL, data DATE, id_pracownika BIGINT NOT NULL, id_godziny BIGINT NOT NULL, id_pensji BIGINT NOT NULL, id_premii BIGINT NOT NULL);

/* b */
ALTER TABLE pracownicy ADD PRIMARY KEY (id_pracownika); 
ALTER TABLE godziny ADD PRIMARY KEY (id_godziny); 
ALTER TABLE pensja_stanowisko ADD PRIMARY KEY (id_pensji); 
ALTER TABLE premia ADD PRIMARY KEY (id_premii); 
ALTER TABLE wynagrodzenie ADD PRIMARY KEY (id_wynagrodzenia); 

/* c */
ALTER TABLE godziny ADD FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika); 

ALTER TABLE wynagrodzenie ADD FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika); 
ALTER TABLE wynagrodzenie ADD FOREIGN KEY (id_godziny) REFERENCES godziny(id_godziny); 
ALTER TABLE wynagrodzenie ADD FOREIGN KEY (id_premii) REFERENCES premia(id_premii); 
ALTER TABLE wynagrodzenie ADD FOREIGN KEY (id_pensji) REFERENCES pensja_stanowisko(id_pensji); 
/* d */
CREATE INDEX nazwisko_idx ON pracownicy(nazwisko);
/* e */
COMMENT ON TABLE pracownicy IS 'Lista pracowników firmy';
COMMENT ON TABLE godziny IS 'Ilość godzin przepracowanych przez pracownika w danym miesiącu';
COMMENT ON TABLE pensja_stanowisko IS 'Wysokość pensji w zależności od zajmowanego stanowiska';
COMMENT ON TABLE premia IS 'Wysokość premii w zależności od jej rodzaju';
COMMENT ON TABLE wynagrodzenie IS 'Wysokość wynagrodzenia za miesiąc pracy';
/* 5 */

INSERT INTO pracownicy (imie, nazwisko,adres, telefon) VALUES 
('Jan', 'Kowalski', 'Kraków ul. Zwierzyniecka 23/2', '111111111'),
('Anna', 'Nowak', 'Kraków ul. Cicha 3', '222222222'),
('Mateusz', 'Kowal', 'Kraków ul. Szeroka 1', '111111111'),
('Patryk', 'Nowak', 'Kraków ul. Nowosądecka 3', '333333333'),
('Katarzyna', 'Nowacka', 'Kraków ul. Nowosądecka 3', '444444444'),
('Karol', 'Karolak', 'Kraków ul. Krótka 1\4', '666666666'),
('Joanna', 'Bujak', 'Kraków ul. Kolorowa 3', '777777777'),
('Katarzyna', 'Nowacka', 'Kraków ul. Nowosądecka 3', '888888888'),
('Maciej', 'Klon', 'Kraków ul. Opolska 5', '999999999'),
('Aleksandra', 'Matoga', 'Kraków ul. Nowosądecka 56', '000000000');

ALTER TABLE godziny ADD COLUMN miesiac INT ;
ALTER TABLE godziny ADD COLUMN tydzien INT ;

INSERT INTO godziny (data, liczba_godzin, id_pracownika) VALUES 
('2020-10-10',120, 1),
('2020-10-10',165, 2),
('2020-10-10',140, 3),
('2020-10-10',150, 4),
('2020-10-10',135, 5),
('2020-10-10',145, 6),
('2020-10-10',150, 7),
('2020-10-10',120, 8),
('2020-10-10',143, 9),
('2020-10-10',170, 10),
('2020-09-10',140, 10),
('2020-09-10',150, 9),
('2020-09-10',140, 8),
('2020-09-10',150, 7),
('2020-09-10',135, 6),
('2020-09-10',145, 5),
('2020-09-10',150, 4),
('2020-09-10',120, 3),
('2020-09-10',120, 2),
('2020-09-10',130, 1),
('2020-08-10',140, 10),
('2020-08-10',130, 9),
('2020-08-10',140, 8),
('2020-08-10',150, 7),
('2020-08-10',135, 6),
('2020-08-10',180, 5),
('2020-08-10',150, 4),
('2020-08-10',120, 3),
('2020-08-10',170, 2),
('2020-08-10',130, 1);

INSERT INTO premia (rodzaj, kwota) VALUES 
('nadgodziny', 100.22),
('awans', 250.44),
('za ilościowy wzrost wykonywanych zadań', 120.2),
('za poprawę jakości', 150.4),
('za obniżenie kosztów działalności', 90.0),
('za oszczędność surowców, energii i innych środków', 163.2),
('za poprawę wykorzystania czasu pracy ludzi i maszyn', 65.2),
('za terminowe lub przedterminowe wykonanie zadań', 190.12),
('za bezwypadkową pracę',50.0),
/* c */
('brak', 0);


INSERT INTO pensja_stanowisko (stanowisko, kwota ) VALUES 
('ksiegowy', 1200),
('starszy ksiegowy', 1500.30),
('administrator sieci', 1000),
('praktykant', 500),
('sekretarka', 1300.20),
('doradca klienta', 1000),
('asystent', 1200),
('kierownik', 2100),
('pielęgniarka', 900),
('Specjalista ds. szkoleń', 1200),
('Specjalista ds. marketingu', 1200);


INSERT INTO wynagrodzenie (id_pracownika, data, id_godziny, id_pensji, id_premii) VALUES
(1,'2020-11-10', 1,4,5),
(2,'2020-11-10', 2,1,10),
(3,'2020-11-10', 3,2,5),
(4,'2020-11-10', 4,9,1),
(5,'2020-11-10', 5,1,4),
(6,'2020-11-10', 6,8,4),
(7,'2020-11-10', 7,1,1),
(8,'2020-11-10', 8,9,1),
(9,'2020-11-10', 9,10,1),
(10,'2020-11-10', 10,3,1),
(10,'2020-10-10', 11,3,1),
(9,'2020-10-10', 12,9,1),
(8,'2020-10-10', 13,1,1),
(7,'2020-10-10', 14,1,1),
(6,'2020-10-10', 15,8,1);


/* a */

/* b */
ALTER TABLE wynagrodzenie ALTER COLUMN data TYPE VARCHAR;

/* 6 */
/* a */
SELECT id_pracownika, nazwisko FROM pracownicy;
/* b */
SELECT id_pracownika FROM wynagrodzenie INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji) WHERE pensja_stanowisko.kwota > 1000;
/* c */
SELECT DISTINCT wynagrodzenie.id_pracownika FROM wynagrodzenie INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji)
WHERE pensja_stanowisko.kwota > 1200 AND id_premii IN (SELECT id_premii FROM premia WHERE rodzaj = 'brak');
/* d */
SELECT * FROM pracownicy WHERE imie LIKE 'J%';
/* e */
SELECT * FROM pracownicy WHERE nazwisko LIKE '%_n_%' AND imie LIKE '%_a';
/* f */
SELECT DISTINCT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenie ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika) 
INNER JOIN godziny ON (wynagrodzenie.id_godziny = godziny.id_godziny)  WHERE godziny.liczba_godzin > 160;
/* g */
SELECT DISTINCT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenie ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika) 
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji) WHERE  pensja_stanowisko.kwota > 1500 AND pensja_stanowisko.kwota < 3000;
/* h */
SELECT DISTINCT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenie ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika) 
INNER JOIN godziny ON (wynagrodzenie.id_godziny = godziny.id_godziny) 
WHERE godziny.liczba_godzin > 160 AND id_premii IN (SELECT id_premii FROM premia WHERE rodzaj = 'brak');


/* 7 */
/* a */
SELECT DISTINCT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenie ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika)
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji) ORDER BY kwota;
/* b */
SELECT DISTINCT imie, nazwisko FROM pracownicy INNER JOIN wynagrodzenie ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika)
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji)
INNER JOIN premia ON (wynagrodzenie.id_premii = premia.id_premii) ORDER BY pensja_stanowisko.kwota, premia.kwota DESC;
/* c */
SELECT COUNT(DISTINCT id_pracownika), pensja_stanowisko.stanowisko FROM wynagrodzenie 
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji) GROUP BY pensja_stanowisko.stanowisko;
/* d */
SELECT AVG(kwota), MIN(kwota), MAX(kwota) FROM pensja_stanowisko WHERE stanowisko='kierownik';
/* e */
SELECT SUM(premia.kwota+pensja_stanowisko.kwota) FROM wynagrodzenie
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji)
INNER JOIN premia ON (wynagrodzenie.id_premii = premia.id_premii) ;
/* f */
SELECT SUM(premia.kwota+pensja_stanowisko.kwota), pensja_stanowisko.stanowisko FROM wynagrodzenie
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji)
INNER JOIN premia ON (wynagrodzenie.id_premii = premia.id_premii) GROUP BY pensja_stanowisko.stanowisko;
/* g */
SELECT COUNT(wynagrodzenie.id_premii), pensja_stanowisko.stanowisko FROM wynagrodzenie INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji)
INNER JOIN premia ON (wynagrodzenie.id_premii = premia.id_premii) WHERE premia.rodzaj != 'brak' GROUP BY pensja_stanowisko.stanowisko;
/* h */
DELETE FROM pracownicy WHERE id_pracownika IN
(SELECT id_pracownika FROM wynagrodzenie INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji) 
WHERE pensja_stanowisko.kwota < 1200);


/* 8 */
/* a */
UPDATE pracownicy SET telefon = CONCAT('+(48) ', SUBSTRING(telefon,0,10));
/* b */
UPDATE pracownicy SET telefon = CONCAT(SUBSTRING(telefon, 0, 10), '-', SUBSTRING(telefon, 10, 3), '-', SUBSTRING(telefon, 13, 3));
/* c */
SELECT DISTINCT UPPER(nazwisko) FROM pracownicy WHERE length(nazwisko) = (SELECT MAX(length(nazwisko)) FROM pracownicy);
/* d */

SELECT MD5(CONCAT(pracownicy.id_pracownika,' ', imie,' ', nazwisko,' ', telefon,' ', kwota, 'zl')) FROM pracownicy 
INNER JOIN wynagrodzenie ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika) 
INNER JOIN pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji);

/* 9 */
SELECT FORMAT('Pracownik %s %s, w dniu %s otrzymał pensję całkowitą na kwotę %s zł, gdzie wynagrodzenie zasadnicze wynosiło: %s zł, premia: %s zł, nadgodziny: %s zł',
imie, nazwisko, wynagrodzenie.data, pensja_stanowisko.kwota+premia.kwota, pensja_stanowisko.kwota, premia.kwota, ((liczba_godzin-160) * pensja_stanowisko.kwota/160))
FROM wynagrodzenie INNER JOIN  pensja_stanowisko ON (wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji)
INNER JOIN premia ON (wynagrodzenie.id_premii = premia.id_premii)
INNER JOIN pracownicy ON (wynagrodzenie.id_pracownika = pracownicy.id_pracownika)
INNER JOIN godziny ON (wynagrodzenie.id_godziny = godziny.id_godziny);