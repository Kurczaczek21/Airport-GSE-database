create function usunlinielotnicza(uzytk character varying, p_nazwalinii character varying) returns void
    language plpgsql
as
$$
DECLARE
    id uzytkownicy.id_uprawn%TYPE;
BEGIN
SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
IF id=2 or id=1 THEN
    -- Usuń z tabeli Linie_lotnicze (kaskadowo usunie z Rozklad_lotow)
    DELETE FROM Linie_lotnicze
    WHERE linia = p_NazwaLinii;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function usunlinielotnicza(varchar, varchar) owner to postgres;

