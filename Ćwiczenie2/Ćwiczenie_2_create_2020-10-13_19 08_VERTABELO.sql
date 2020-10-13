-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-10-13 17:02:19.777

-- tables
-- Table: Producenci
CREATE TABLE Producenci (
    id_producenta bigserial  NOT NULL,
    nazwa_producenta varchar  NOT NULL,
    mail varchar  NOT NULL,
    telefon varchar  NOT NULL,
    CONSTRAINT Producenci_pk PRIMARY KEY (id_producenta)
);

CREATE INDEX Producenci_idx on Producenci (nazwa_producenta ASC);

-- Table: Produkty
CREATE TABLE Produkty (
    id_produktu bigserial  NOT NULL,
    nazwa_produktu varchar  NOT NULL,
    cena decimal(10,2)  NOT NULL,
    Producenci_id_producenta int8  NOT NULL,
    CONSTRAINT Produkty_pk PRIMARY KEY (id_produktu)
);

CREATE INDEX Produkty_idx on Produkty (nazwa_produktu ASC);

-- Table: Zamowienia
CREATE TABLE Sklep.Zamowienia (
    id_zamowienia bigserial  NOT NULL,
    data date  NOT NULL,
    Produkty_id_produktu int8  NOT NULL,
    CONSTRAINT Zamowienia_pk PRIMARY KEY (id_zamowienia)
);

-- foreign keys
-- Reference: Produkty_Producenci (table: Produkty)
ALTER TABLE Produkty ADD CONSTRAINT Produkty_Producenci
    FOREIGN KEY (Producenci_id_producenta)
    REFERENCES Producenci (id_producenta)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Zamowienia_Produkty (table: Zamowienia)
ALTER TABLE Sklep.Zamowienia ADD CONSTRAINT Zamowienia_Produkty
    FOREIGN KEY (Produkty_id_produktu)
    REFERENCES Produkty (id_produktu)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

