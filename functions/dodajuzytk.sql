create function dodajuzytk(login character varying, haslo_hash character varying, id_uprawn integer, opis character varying DEFAULT '%BRAK'::character varying, linia character varying DEFAULT 'LOTNISKO'::character varying) returns boolean
    language plpgsql
as
$$
BEGIN
    INSERT INTO uzytkownicy (login, haslo_hash, opis, id_uprawn, linia) VALUES ($1, $2, $4, $3, $5);
    RETURN TRUE;
END;
$$;

alter function dodajuzytk(varchar, varchar, integer, varchar, varchar) owner to postgres;

