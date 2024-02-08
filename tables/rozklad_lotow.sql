CREATE TABLE Rozklad_lotow (
    FID VARCHAR(255) CHECK(FID ~ '[A-Z]{2}[0-9]{4}'),
    Data_przylotu TIMESTAMP NOT NULL,
    Data_wylotu TIMESTAMP NOT NULL,
    Miejsce_przylotu VARCHAR(255) NOT NULL,
    Miejsce_odlotu VARCHAR(255) NOT NULL,
    Linia VARCHAR(255) NOT NULL,
    Typ_samolotu VARCHAR(255) NOT NULL,
    Srednia_waga_bagazu_Kg INT DEFAULT 0,
    PRIMARY KEY (FID, Data_przylotu, Data_wylotu),
    FOREIGN KEY (Linia) REFERENCES Linie_lotnicze(Linia) ON UPDATE CASCADE ON DELETE CASCADE
);