INSERT INTO Linie_lotnicze (Linia, ID_FID, Opis) VALUES
('LOT', 'LO', 'Polskie Linie Lotnicze'),
('LUFTHANSA', 'LU', 'Lufthansa - Niemieckie Linie Lotnicze'),
('EMIRATES', 'EM', 'Emirates - Linie Lotnicze Zjednoczonych Emiratów Arabskich'),
('LOTNISKO', 'LOTNISKO', 'Na potrzeby dzialania funkcji');

-- Wymagania linii lotniczych
INSERT INTO Wymagania_Linii (FID, Linia, Typ_samolotu, Agregat, Schody, Woda, Asenizacja, Rekaw) VALUES
('LO3924', 'LOT', 'Boeing 737', 1, 1, 1, 0, 1),
('LO0010', 'LOT', 'Boeing 787-9', 2, 1, 1, 1, 1),
('LU0013', 'LUFTHANSA', 'Airbus A380', 2, 2, 1, 1, 2),
('EM0014', 'EMIRATES', 'Boeing 777', 1, 2, 0, 0, 0);

-- Zasoby sprzętowe
INSERT INTO Zasoby_sprzetowe (Typ_sprzetu, Ilosc, Koszt_nah) VALUES
('Przyczepki', 30, 500),
('Agregat', 8, 1000),
('Schody', 10, 800),
('Woda', 5, 500),
('Asenizacja', 5, 1200),
('Rekaw', 7, 1500);

-- Uprawnienia
INSERT INTO Uprawnienia (Id_uprawn, Opis) VALUES
(1, 'Administrator'),
(2, 'Pracownik'),
(3, 'Pracownik linii lotniczych');

-- Uzytkownicy
INSERT INTO Uzytkownicy (Login, Haslo_hash, Id_uprawn, Linia) VALUES
('admin', 'haslo_hash_admin', 1, 'LOTNISKO'),
('user', 'haslo_hash_user', 2, 'LOTNISKO'),
('TomekLot', 'wjgwiebg', 3, 'LOT'),
('AniaLuft', 'avdgaegewg', 3, 'LUFTHANSA'),
('PrzemEmi', 'dddfgwege', 3, 'EMIRATES');

SELECT DodajNowyLot('admin','LO0002', 'LOT', 'Airbus A320', 1, 2, 1, 1, 0);
SELECT DodajNowyLot('admin','LO0003', 'LOT', 'Boeing 787-9', 1, 1, 1, 1, 1);

SELECT DodajCodziennyLot('admin','LO0002','LOT', '2024-01-01 11:00:00', '2024-01-01 20:00:00', 'Warszawa', 'Oslo', 1100, 2);

SELECT SprawdzDostepnoscSprzetu('admin','2024-01-01 13:00:00', '2024-01-03 15:00:00');

SELECT DodajCotygodniowyLot('admin','LO0003','LOT', '2024-01-08 13:00:00', '2024-01-08 15:00:00', 'Warszawa', 'Berlin', 600, 3);

SELECT sprawdzdostepnoscsprzetu('admin','2024-01-01 13:00:00', '2024-01-01 15:00:00');


SELECT dodajLinie('admin','LUFTHANSA','LU','Niemieckie linie lotnicze');
SELECT DodajNowyLot('admin','LU0013', 'LUFTHANSA', 'Boeing 787-9', 1, 1, 1, 1, 1);
SELECT DodajNowyLot('admin','LU0014', 'LUFTHANSA', 'Boeing 787-9', 1, 1, 1, 6, 6);


SELECT DodajCodziennyLot('admin','LU0014','LUFTHANSA', '2024-01-01 13:00:00', '2024-01-01 15:00:00', 'Warszawa', 'Berlin', 600, 2);
SELECT sprawdzdostepnoscsprzetu('admin','2024-01-01 13:00:00', '2024-01-01 15:00:00');
SELECT ObliczKosztyZamowionychUslug('admin','LUFTHANSA');


SELECT UsunLotZRozkladu('admin','LO0003','2024-05-08 13:00:00', '2024-05-08 15:00:00');
SELECT UsunLotyZRozkladu('admin','LO0003');

SELECT UsunLinieLotnicza('admin','LUFTHANSA');