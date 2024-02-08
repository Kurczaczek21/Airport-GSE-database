create function pokazuprawnienia(uzytk character varying)
    returns TABLE(id_uprawn integer, opis character varying)
    language plpgsql
as
$$
DECLARE
id uzytkownicy.id_uprawn%TYPE;
BEGIN
    SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE Login=$1;
    IF id=1 THEN
        raise notice '!!!! Kolumny: | ID | Uprawnienie | !!!!';
        RETURN QUERY
        SELECT * FROM Uprawnienia;
    ELSE
        raise notice 'Nie masz uprawnien';
    END IF;
END;
$$;

alter function pokazuprawnienia(varchar) owner to postgres;

