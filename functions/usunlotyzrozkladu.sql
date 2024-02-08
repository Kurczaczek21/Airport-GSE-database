create function usunlotyzrozkladu(uzytk character varying, p_fid character varying) returns void
    language plpgsql
as
$$
DECLARE
    lineUz uzytkownicy.linia%TYPE;
    lineLot rozklad_lotow.linia%TYPE;
    id uzytkownicy.id_uprawn%TYPE;
BEGIN
SELECT u.Linia FROM Uzytkownicy u INTO lineUz WHERE u.Login=$1;
SELECT u.Id_uprawn FROM Uzytkownicy u INTO id WHERE u.Login=$1;
SELECT r.Linia FROM rozklad_lotow r INTO lineLot WHERE r.FID=$2;
IF (lineUz=lineLot and id=3) or id=1 THEN
    -- Usuń loty z rozkładu
    DELETE FROM Rozklad_lotow WHERE FID = p_FID;

    -- Usuń powiązane wymagania linii (opcjonalne, w zależności od potrzeb)
    DELETE FROM Wymagania_linii WHERE FID = p_FID;

    -- Możesz dodać dodatkowe czynności, jeśli są powiązane z usunięciem lotów

    RAISE NOTICE 'Loty z rozkładu o FID % zostały usunięte.', p_FID;
ELSE
   RAISE NOTICE 'NIE MASZ UPRAWNIEŃ.';
END IF;
END;
$$;

alter function usunlotyzrozkladu(varchar, varchar) owner to postgres;

