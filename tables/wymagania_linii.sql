CREATE TABLE Wymagania_Linii (
    FID VARCHAR(255) PRIMARY KEY CHECK(FID ~ '^[A-Z]{2}[0-9]{4}$'),
    Linia VARCHAR(255) NOT NULL,
    Typ_samolotu VARCHAR(255) NOT NULL,
    Agregat INT DEFAULT 0,
    Schody INT DEFAULT 0,
    Woda INT DEFAULT 0,
    Asenizacja INT DEFAULT 0,
    Rekaw INT DEFAULT 0,
    FOREIGN KEY (Linia) REFERENCES Linie_lotnicze(Linia) ON UPDATE CASCADE ON DELETE CASCADE
);