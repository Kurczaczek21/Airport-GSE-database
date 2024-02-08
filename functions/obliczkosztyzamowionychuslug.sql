create function obliczkosztyzamowionychuslug(uzytk character varying, p_linia character varying)
    returns TABLE(linia character varying, fid character varying, koszt_przyczepek integer, koszt_agregatow integer, koszt_schodow integer, koszt_wody integer, koszt_asenizacji integer, koszt_rekawow integer, total_koszt integer)
    language plpgsql
as
$$
DECLARE
    Laczny_czas_handlingu NUMERIC;
    rowek RECORD;
    lineUz uzytkownicy.linia%TYPE;
    id uzytkownicy.id_uprawn%TYPE;
BEGIN
SELECT u.Linia FROM Uzytkownicy u INTO lineUz WHERE u.Login=$1;
SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
IF (lineUz=$2 and id=3) or id=1 or id=2 THEN
    DROP TABLE IF EXISTS dane_lotow_rownoleglych;
    CREATE TEMP TABLE dane_lotow_rownoleglych AS
        SELECT
            rl.linia,
            rl.FID,
            SUM(ObliczLiczbePrzyczepek(Srednia_waga_bagazu_Kg)) AS LiczbaPrzyczepek,
            COALESCE(SUM(wl.Agregat), 0) AS LiczbaAgregatow,
            COALESCE(SUM(wl.Schody), 0) AS LiczbaSchodow,
            COALESCE(SUM(wl.Woda), 0) AS LiczbaWody,
            COALESCE(SUM(wl.Asenizacja), 0) AS LiczbaAsenizacji,
            COALESCE(SUM(wl.Rekaw), 0) AS LiczbaRekawow
        FROM
            Rozklad_lotow rl
        JOIN
            Wymagania_linii wl ON rl.FID = wl.FID AND rl.linia=p_Linia
        GROUP BY
            rl.linia, rl.srednia_waga_bagazu_kg, rl.FID;

    SELECT
        SUM(EXTRACT(EPOCH FROM (rl.Data_wylotu - rl.Data_przylotu)) / 3600) INTO Laczny_czas_handlingu
    FROM
        Rozklad_lotow rl
    WHERE
        rl.Linia = p_Linia;

    RAISE NOTICE 'Value of your_variable: %', Laczny_czas_handlingu;
    FOR rowek IN SELECT * FROM dane_lotow_rownoleglych LOOP
        RAISE NOTICE 'Row in dane_lotow_rownoleglych: %', rowek;
    END LOOP;

    RAISE NOTICE '!!!! Kolumny: | Linia | Przyczepki | Agregaty | Schody | Woda | Asenizacja | Rekawy | SUMA | !!!!';
    RETURN QUERY
    SELECT p_Linia, dane_lotow_rownoleglych.FID , CAST(LiczbaPrzyczepek*2*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Przyczepki')AS INT) AS koszt_przyczepek,
        CAST(LiczbaAgregatow*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Agregat')AS INT) AS koszt_agregatow,
        CAST(LiczbaSchodow*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Schody')AS INT) AS koszt_schodow,
        CAST(LiczbaWody*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Woda')AS INT) AS koszt_wody,
        CAST(LiczbaAsenizacji*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Asenizacja')AS INT) AS koszt_asenizacji,
        CAST(LiczbaRekawow*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Rekaw')AS INT) AS koszt_rekawow,

        CAST(LiczbaPrzyczepek*2*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Przyczepki')+
        LiczbaAgregatow*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Agregat')+
        LiczbaSchodow*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Schody')+
        LiczbaWody*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Woda')+
        LiczbaAsenizacji*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Asenizacja')+
        LiczbaRekawow*(SELECT zasoby_sprzetowe.koszt_nah FROM zasoby_sprzetowe WHERE zasoby_sprzetowe.Typ_sprzetu='Rekaw')AS INT) AS total_koszt FROM dane_lotow_rownoleglych;
    DROP TABLE IF EXISTS dane_lotow_rownoleglych;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function obliczkosztyzamowionychuslug(varchar, varchar) owner to postgres;

