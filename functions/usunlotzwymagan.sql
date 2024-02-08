create function usunlotzwymagan(uzytk character varying, p_fid character varying) returns void
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
    -- Usuń z tabeli Wymagania_linii (kaskadowo usunie z Rozklad_lotow)
    DELETE FROM Wymagania_linii
    WHERE FID = p_FID;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function usunlotzwymagan(varchar, varchar) owner to postgres;

