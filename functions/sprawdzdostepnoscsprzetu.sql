create function sprawdzdostepnoscsprzetu(uzytk character varying, p_start timestamp without time zone, p_end timestamp without time zone)
    returns TABLE(nazwa_sprzetu_okres character varying, ilosc_sprzetu_okres integer)
    language plpgsql
as
$$
DECLARE
    lineUz uzytkownicy.linia%TYPE;
    id uzytkownicy.id_uprawn%TYPE;
BEGIN
DROP TABLE IF EXISTS wyniki_sprzetu_okres;
DROP TABLE IF EXISTS dane_lotow_rownoleglych;
SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
IF id=3 or id=1 THEN
    -- Create a temporary table to store the results
    DROP TABLE IF EXISTS wyniki_sprzetu_okres;
    CREATE TEMP TABLE wyniki_sprzetu_okres (
        nazwa_sprzetu_okres VARCHAR(255),
        ilosc_sprzetu_okres INT
    );

    -- Your existing logic to retrieve data and calculate available equipment
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
        (rl.Data_przylotu, rl.Data_wylotu) OVERLAPS (p_Start, p_End)
    GROUP BY
        rl.FID, rl.srednia_waga_bagazu_kg;

    -- Insert results into the temporary table
    INSERT INTO wyniki_sprzetu_okres
    SELECT
        'Agregat'::VARCHAR(255),
        ((SELECT Ilosc FROM Zasoby_sprzetowe WHERE Zasoby_sprzetowe.Typ_sprzetu = 'Agregat') - (SELECT COALESCE(SUM(LiczbaAgregatow), 0) FROM dane_lotow_rownoleglych ))::INT
    UNION ALL
    SELECT
        'Schody',
        ((SELECT Ilosc FROM Zasoby_sprzetowe WHERE Zasoby_sprzetowe.Typ_sprzetu = 'Schody') - (SELECT COALESCE(SUM(LiczbaSchodow), 0) FROM dane_lotow_rownoleglych ))::INT
    UNION ALL
    SELECT
        'Woda',
        ((SELECT Ilosc FROM Zasoby_sprzetowe WHERE Zasoby_sprzetowe.Typ_sprzetu = 'Woda') - (SELECT COALESCE(SUM(LiczbaWody), 0) FROM dane_lotow_rownoleglych ))::INT
    UNION ALL
    SELECT
        'Asenizacja',
        ((SELECT Ilosc FROM Zasoby_sprzetowe WHERE Zasoby_sprzetowe.Typ_sprzetu = 'Asenizacja') - (SELECT COALESCE(SUM(LiczbaAsenizacji), 0) FROM dane_lotow_rownoleglych ))::INT
    UNION ALL
    SELECT
        'Rekaw',
        ((SELECT Ilosc FROM Zasoby_sprzetowe WHERE Zasoby_sprzetowe.Typ_sprzetu = 'Rekaw') - (SELECT COALESCE(SUM(LiczbaRekawow), 0) FROM dane_lotow_rownoleglych ))::INT
    UNION ALL
    SELECT
        'Przyczepki',
        ((SELECT Ilosc FROM Zasoby_sprzetowe WHERE Zasoby_sprzetowe.Typ_sprzetu = 'Przyczepki') - (SELECT COALESCE(SUM(LiczbaPrzyczepek), 0) FROM dane_lotow_rownoleglych ))::INT;

    -- Return the results
    RETURN QUERY SELECT * FROM wyniki_sprzetu_okres;

    -- Drop the temporary tables
    DROP TABLE IF EXISTS wyniki_sprzetu_okres;
    DROP TABLE IF EXISTS dane_lotow_rownoleglych;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function sprawdzdostepnoscsprzetu(varchar, timestamp, timestamp) owner to postgres;

