-- Script to extract Alpes mountains Conservation priority taxa from SIMETHIS
-- Usage: psql -h <server-ip> -u <user-name> -d si_cbn -f "./extract.sql" > ./$(date +'%F')_taxa_alp.csv

COPY (
    SELECT
        'ALP' AS territory_code,
        rt.cd_ref AS cd_nom,
        CASE 
            WHEN rt.id_reglementation = 'HIE_TFO_ALP' THEN 1
            WHEN rt.id_reglementation = 'HIE_FOR_ALP' THEN 2
            WHEN rt.id_reglementation = 'HIE_BRY_ALP' THEN 1
        END AS revised_conservation_priority,
        to_date(r.annee_arrete::text, 'YYYY') AS revision_date
    FROM referentiels.reglementation_taxon AS rt 
        JOIN referentiels.reglementation AS r 
            ON (rt.id_reglementation = r.id_reglementation)
    WHERE rt.id_reglementation IN ('HIE_TFO_ALP', 'HIE_FOR_ALP', 'HIE_BRY_ALP')
        AND r.actif = TRUE
) TO stdout
WITH (format csv, header, delimiter E'\t');