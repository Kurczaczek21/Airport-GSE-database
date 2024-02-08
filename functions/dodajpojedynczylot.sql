create function dodajpojedynczylot(uzytk character varying, p_fid character varying, p_linia character varying, p_dataprzylotu timestamp without time zone, p_dataodlotu timestamp without time zone, p_miejsceprzylotu character varying, p_miejsceodlotu character varying, p_sredniawagabagazu_kg integer) returns void
    language plpgsql
as
$$
DECLARE
    IloscAgregatow INT;
    IloscSchodow INT;
    IloscWody INT;
    IloscAsenizacji INT;
    IloscRekawow INT;
    IloscPrzyczepek INT;
    line uzytkownicy.linia%TYPE;
    id uzytkownicy.id_uprawn%TYPE;
    fid_id linie_lotnicze.ID_FID%TYPE;
BEGIN
SELECT Linia FROM Uzytkownicy INTO line WHERE Login=$1;
SELECT Id_uprawn FROM Uzytkownicy INTO id WHERE Login=$1;
SELECT ID_FID FROM Linie_lotnicze INTO fid_id WHERE Linia=$3;
IF (line=$3 and id=3 and fid_id=regexp_replace($2, '[0-9]{4}', '', 'g')) or (id=1 and fid_id=regexp_replace($2, '[0-9]{4}', '', 'g')) then
        -- Pobierz ilość przyczepek dla lotu ktory chcesz dodac
    IloscPrzyczepek := obliczliczbeprzyczepek(p_SredniaWagaBagazu_Kg);
    -- Pobierz liczbe sprzetu dla lotu ktory chcesz dodac
    SELECT agregat FROM wymagania_linii WHERE FID = p_FID INTO IloscAgregatow;
    SELECT schody FROM wymagania_linii WHERE FID = p_FID INTO IloscSchodow;
    SELECT woda FROM wymagania_linii WHERE FID = p_FID INTO IloscWody;
    SELECT Asenizacja FROM wymagania_linii WHERE FID = p_FID INTO IloscAsenizacji;
    SELECT Rekaw FROM wymagania_linii WHERE FID = p_FID INTO IloscRekawow;

    DROP TABLE IF EXISTS dane_lotow_rownoleglych;
    CREATE TEMP TABLE dane_lotow_rownoleglych AS
    SELECT
        rl.FID,
        ObliczLiczbePrzyczepek(Srednia_waga_bagazu_Kg) AS LiczbaPrzyczepek,
        COALESCE(SUM(wl.Agregat), 0) AS LiczbaAgregatow,
        COALESCE(SUM(wl.Schody), 0) AS LiczbaSchodow,
        COALESCE(SUM(wl.Woda), 0) AS LiczbaWody,
        COALESCE(SUM(wl.Asenizacja), 0) AS LiczbaAsenizacji,
        COALESCE(SUM(wl.Rekaw), 0) AS LiczbaRekawow
    FROM
        Rozklad_lotow rl
    JOIN
        Wymagania_linii wl ON rl.FID = wl.FID
    WHERE
        (rl.Data_przylotu, rl.Data_wylotu) OVERLAPS (p_DataPrzylotu, p_DataOdlotu)
    GROUP BY
        rl.FID, rl.srednia_waga_bagazu_kg;

    IF (IloscAgregatow + (SELECT COALESCE(SUM(LiczbaAgregatow), 0) FROM dane_lotow_rownoleglych )) <= (SELECT Ilosc FROM Zasoby_sprzetowe WHERE Typ_sprzetu = 'Agregat')
        AND (IloscSchodow + (SELECT COALESCE(SUM(LiczbaSchodow), 0) FROM dane_lotow_rownoleglych )) <= (SELECT Ilosc FROM Zasoby_sprzetowe WHERE Typ_sprzetu = 'Schody')
        AND (IloscWody + (SELECT COALESCE(SUM(LiczbaWody), 0) FROM dane_lotow_rownoleglych )) <= (SELECT Ilosc FROM Zasoby_sprzetowe WHERE Typ_sprzetu = 'Woda')
        AND (IloscAsenizacji + (SELECT COALESCE(SUM(LiczbaAsenizacji), 0) FROM dane_lotow_rownoleglych )) <= (SELECT Ilosc FROM Zasoby_sprzetowe WHERE Typ_sprzetu = 'Asenizacja')
        AND (IloscRekawow + (SELECT COALESCE(SUM(LiczbaRekawow), 0) FROM dane_lotow_rownoleglych )) <= (SELECT Ilosc FROM Zasoby_sprzetowe WHERE Typ_sprzetu = 'Rekaw')
        AND (IloscPrzyczepek + (SELECT COALESCE(SUM(LiczbaPrzyczepek), 0) FROM dane_lotow_rownoleglych )) <= (SELECT Ilosc FROM Zasoby_sprzetowe WHERE Typ_sprzetu = 'Przyczepki') THEN

        -- Dodaj lot do rozkładu lotów
        RAISE NOTICE 'Wszystkie warunki są spełnione. Dodaję lot do rozkładu lotów.';
        INSERT INTO Rozklad_lotow (FID, Data_przylotu, Data_wylotu, Miejsce_przylotu, Miejsce_odlotu, Linia, Typ_samolotu, Srednia_waga_bagazu_Kg)
        SELECT p_FID, p_DataPrzylotu, p_DataOdlotu, p_MiejscePrzylotu, p_MiejsceOdlotu, Linia, Typ_samolotu, p_SredniaWagaBagazu_Kg
        FROM Wymagania_Linii
        WHERE FID = p_FID;

        -- Uzupełnienie brakujących informacji w Rozklad_lotow na podstawie Wymagania_Linii
        UPDATE Rozklad_lotow
        SET Linia = (SELECT Linia FROM Wymagania_Linii WHERE FID = p_FID),
            Typ_samolotu = (SELECT Typ_samolotu FROM Wymagania_Linii WHERE FID = p_FID)
        WHERE FID = p_FID;
    ELSE
        RAISE NOTICE 'Nie można dodać lotu do rozkładu.';
    END IF;

    DROP TABLE dane_lotow_rownoleglych;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function dodajpojedynczylot(varchar, varchar, varchar, timestamp, timestamp, varchar, varchar, integer) owner to postgres;

