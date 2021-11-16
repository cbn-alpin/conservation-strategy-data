-- Script to extract AURA DEP (01, 26, 38, 73, 74) Conservation priority taxa from SIMETHIS
-- Usage: psql -h <server-ip> -u <user-name> -d si_cbn -f "./extract.sql" > ./$(date +'%F')_taxa_dep.csv

COPY (
    WITH reg_priority_taxa_1 AS (
        SELECT rt.cd_ref
        FROM referentiels.reglementation_taxon AS rt 
        WHERE rt.id_reglementation = 'HIE-TFO-PACA'
    ),
    reg_priority_taxa_2 AS (
        SELECT rt.cd_ref
        FROM referentiels.reglementation_taxon AS rt 
        WHERE rt.id_reglementation = 'HIE-FOR-PACA'
    )
    SELECT DISTINCT
        RIGHT(rt.id_reglementation, 2) AS territory_code,
        rt.cd_ref AS cd_nom,
        CASE 
            WHEN rt.cd_ref IN (SELECT cd_ref FROM reg_priority_taxa_1) THEN 1
            WHEN rt.cd_ref IN (SELECT cd_ref FROM reg_priority_taxa_2) THEN 2
            ELSE 3
        END AS revised_conservation_priority,
        to_date(r.annee_arrete::text, 'YYYY') AS revision_date
    FROM referentiels.reglementation_taxon AS rt 
        JOIN referentiels.reglementation AS r 
            ON (rt.id_reglementation = r.id_reglementation)
    WHERE rt.id_reglementation SIMILAR TO 'HIE_AURA_[0-9][0-9]'
        AND r.actif = TRUE
) TO stdout
WITH (format csv, header, delimiter E'\t');