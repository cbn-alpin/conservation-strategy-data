-- Script to extract AURA Conservation priority taxa from SIMETHIS
-- Usage: psql -h <server-ip> -u <user-name> -d si_cbn -f "./extract.sql" > ./$(date +'%F')_taxa_paca.csv

COPY (
    SELECT
        'PACA' AS territory_code,
        rt.cd_ref AS cd_nom,
        CASE 
            WHEN rt.id_reglementation = 'HIE-TFO-PACA' THEN 1
            WHEN rt.id_reglementation = 'HIE-FOR-PACA' THEN 2
        END AS revised_conservation_priority,
        to_date(r.annee_arrete::text, 'YYYY') AS revision_date
    FROM referentiels.reglementation_taxon AS rt 
        JOIN referentiels.reglementation AS r 
            ON (rt.id_reglementation = r.id_reglementation)
    WHERE rt.id_reglementation IN ('HIE-TFO-PACA', 'HIE-FOR-PACA')
        AND r.actif = FALSE
) TO stdout
WITH (format csv, header, delimiter E'\t');