create function dodajlinie(uzytk character varying, linia character varying, fid character varying, opis character varying DEFAULT '%BRAK%'::character varying) returns boolean
    language plpgsql
as
$$
DECLARE
id uzytkownicy.id_uprawn%TYPE;
BEGIN
    SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
    IF id=1 or id=2 THEN
        INSERT INTO linie_lotnicze (linia, ID_FID, opis) VALUES ($2, $3, $4);
        RETURN TRUE;
    END IF;
RETURN FALSE;
END;
$$;

alter function dodajlinie(varchar, varchar, varchar, varchar) owner to postgres;

