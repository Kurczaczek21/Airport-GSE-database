create function pokazzasoby(uzytk character varying)
    returns TABLE(typ_sprzetu character varying, ilosc integer, koszt_nah integer)
    language plpgsql
as
$$
DECLARE
id uzytkownicy.id_uprawn%TYPE;
BEGIN
    SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE Login=$1;
    IF id=1 or id=2 THEN
        raise notice '!!!! Kolumny: | Typ sprzetu | Ilosc | Koszt najmu na godzine | !!!!';
        RETURN QUERY
        SELECT * FROM Zasoby_sprzetowe;
    ELSE
        raise notice 'Nie masz uprawnien';
    END IF;
END;
$$;

alter function pokazzasoby(varchar) owner to postgres;

