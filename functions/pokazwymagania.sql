create function pokazwymagania(uzytk character varying, p_linia character varying DEFAULT 'NONE'::character varying, p_fid character varying DEFAULT 'NONE'::character varying)
    returns TABLE(fid character varying, linia character varying, typ_samolotu character varying, agregat integer, schody integer, woda integer, asenizacja integer, rekaw integer)
    language plpgsql
as
$$
DECLARE
id uzytkownicy.id_uprawn%TYPE;
lineUz uzytkownicy.linia%TYPE;
BEGIN
    SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE Login=$1;
    SELECT u.Linia FROM Uzytkownicy u INTO lineUz WHERE Login=$1;
    IF $2='NONE' and $3='NONE' THEN
        IF id=1 or id=2 THEN
            raise notice '!!!! Kolumny: | ID | Linia | Typ samolotu | L. agregatow | L. schodow | Woda | Asenizacja | L. rekawow | !!!!';
            RETURN QUERY
            SELECT * FROM wymagania_linii;
        ELSE
            raise notice 'Nie masz uprawnien';
        END IF;
    ELSIF $2<>'NONE' and $3='NONE' THEN
        IF id=1 or id=2 or (id=3 and $2=lineUz) THEN
            raise notice '!!!! Kolumny: | ID | Linia | Typ samolotu | L. agregatow | L. schodow | Woda | Asenizacja | L. rekawow | !!!!';
            RETURN QUERY
            SELECT * FROM wymagania_linii w WHERE w.Linia=$2;
        ELSE
            raise notice 'Nie masz uprawnien';
        END IF;
    ELSE
        IF id=1 or id=2 or (id=3 and $2=lineUz) THEN
            raise notice '!!!! Kolumny: | ID | Linia | Typ samolotu | L. agregatow | L. schodow | Woda | Asenizacja | L. rekawow | !!!!';
            RETURN QUERY
            SELECT * FROM wymagania_linii w WHERE w.FID=$3;
        ELSE
            raise notice 'Nie masz uprawnien';
        END IF;

    END IF;

END;
$$;

alter function pokazwymagania(varchar, varchar, varchar) owner to postgres;

