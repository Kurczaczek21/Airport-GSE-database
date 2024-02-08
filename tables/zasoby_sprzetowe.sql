CREATE TABLE Zasoby_sprzetowe (
    Typ_sprzetu VARCHAR(10) NOT NULL,
    Ilosc INT DEFAULT 0,
    Koszt_nah INT DEFAULT 0,
    PRIMARY KEY (Typ_sprzetu)
);