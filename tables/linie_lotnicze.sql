CREATE TABLE Linie_lotnicze (
    Linia VARCHAR(255) PRIMARY KEY,
    ID_FID VARCHAR(255) CHECK(ID_FID ~ '[A-Z]{2}'),
    Opis VARCHAR(255) DEFAULT '%BRAK%'
);