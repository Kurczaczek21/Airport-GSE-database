create function usunlotzrozkladu(uzytk character varying, p_fid character varying, p_dataprzylotu timestamp without time zone, p_dataodlotu timestamp without time zone) returns void
    language plpgsql
as
$$
DECLARE
    lineUz uzytkownicy.linia%TYPE;
    lineLot wymagania_linii.linia%TYPE;
    id uzytkownicy.id_uprawn%TYPE;
BEGIN
SELECT u.Linia FROM Uzytkownicy u INTO lineUz WHERE u.Login=$1;
SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
SELECT w.Linia FROM wymagania_linii w INTO lineLot WHERE w.FID=$2;
IF (lineUz=lineLot and id=3) or id=1 THEN
    DELETE FROM Rozklad_lotow
    WHERE FID = p_FID
      AND Data_przylotu = p_DataPrzylotu
      AND Data_wylotu = p_DataOdlotu;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function usunlotzrozkladu(varchar, varchar, timestamp, timestamp) owner to postgres;

