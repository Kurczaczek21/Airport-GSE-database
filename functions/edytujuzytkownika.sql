create function edytujuzytkownika(uzytk character varying, username character varying, descr character varying DEFAULT ''::character varying, nowe_haslo character varying DEFAULT ''::character varying) returns boolean
    language plpgsql
as
$$
DECLARE
id uzytkownicy.id_uprawn%TYPE;
usern uzytkownicy.login%TYPE;
pass uzytkownicy.haslo_hash%TYPE;
BEGIN
SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
SELECT u.Login FROM Uzytkownicy u INTO usern WHERE u.Login=$2;
raise notice 'username %', usern;
SELECT u.Haslo_hash FROM Uzytkownicy u INTO pass WHERE u.Login=$2;
    IF id=1 or usern=$1 THEN
        IF $3 <> '' THEN
            raise notice 'Zmieniono opis dla uzytkownika %.', $2;
            UPDATE Uzytkownicy SET Opis=$3 WHERE Login=$2;
        END IF;
        IF $4 <> '' and $4 <> pass THEN
            raise notice 'Zmieniono haslo dla uzytkownika %.', $2;
            UPDATE Uzytkownicy SET Haslo_hash=$4 WHERE Login=$2;
        ELSIF $4=pass THEN
            raise notice 'Haslo nie moze byc takie samo jak wczesniej.';
        END IF;
        RETURN TRUE;
    ELSE
        raise notice 'Nie masz uprawnien';
        RETURN FALSE;
    END IF;
END;
$$;

alter function edytujuzytkownika(varchar, varchar, varchar, varchar) owner to postgres;

