create function dodajnowylot(uzytk character varying, p_fid character varying, p_linia character varying, p_typ_samolotu character varying, p_agregat integer DEFAULT 0, p_schody integer DEFAULT 0, p_woda integer DEFAULT 0, p_asenizacja integer DEFAULT 0, p_rekaw integer DEFAULT 0) returns void
    language plpgsql
as
$$
DECLARE
line uzytkownicy.linia%TYPE;
id uzytkownicy.id_uprawn%TYPE;
fid_id linie_lotnicze.ID_FID%TYPE;
BEGIN
    SELECT Linia FROM Uzytkownicy INTO line WHERE Login=$1;
    SELECT Id_uprawn FROM Uzytkownicy INTO id WHERE Login=$1;
    SELECT ID_FID FROM Linie_lotnicze INTO fid_id WHERE Linia=$3;
    IF (line=$3 and id=3 and fid_id=regexp_replace($2, '[0-9]{4}', '', 'g')) or (id=1 and fid_id=regexp_replace($2, '[0-9]{4}', '', 'g')) then
        INSERT INTO Wymagania_Linii (FID, Linia, Typ_samolotu, Agregat, Schody, Woda, Asenizacja, Rekaw) VALUES (p_FID, p_Linia, p_Typ_samolotu, p_Agregat, p_Schody, p_Woda, p_Asenizacja, p_Rekaw);
    ELSE
        RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
    END IF;
END;
$$;

alter function dodajnowylot(varchar, varchar, varchar, varchar, integer, integer, integer, integer, integer) owner to postgres;

