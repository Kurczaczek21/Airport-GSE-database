create function pokazuzytkownikow(uzytk character varying, nazwa character varying DEFAULT 'ALL'::character varying)
    returns TABLE(login character varying, haslo_hash character varying, opis character varying, id_uprawn integer, linia character varying)
    language plpgsql
as
$$
DECLARE
id uzytkownicy.id_uprawn%TYPE;
lineUz uzytkownicy.linia%TYPE;
BEGIN
    SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
    SELECT u.Linia FROM Uzytkownicy u INTO lineUz WHERE u.Login=$1;
    IF $2='ALL' THEN
        IF id=1 THEN
            raise notice '!!!! Kolumny: | Login | Hash hasla | Opis | ID Uprawnien | Linia | !!!!';
            RETURN QUERY
            SELECT * FROM uzytkownicy;
        ELSE
            raise notice 'Nie masz uprawnien';
        END IF;
    ELSE
        IF uzytk=nazwa THEN
            raise notice '!!!! Kolumny: | Login | Hash hasla | Opis | ID Uprawnien | Linia | !!!!';
            RETURN QUERY
            SELECT * FROM uzytkownicy u where u.login=nazwa;
        END IF;
    END IF;
END;
$$;

alter function pokazuzytkownikow(varchar, varchar) owner to postgres;

