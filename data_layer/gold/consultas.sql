-- 1. Total de Booking value por Veículo
SELECT
    d_veh.veh_typ,
    SUM(f.bkg_vle) AS valor_total
FROM dw.fat_rid AS f
LEFT JOIN dw.dim_veh AS d_veh 
    ON f.srk_veh = d_veh.srk_veh
GROUP BY
    d_veh.veh_typ
ORDER BY
    valor_total DESC;

-- 2. Total de Booking value por Veículo apenas para corridas "Completed"
SELECT
    d_veh.veh_typ,
    SUM(f.bkg_vle) AS valor_total
FROM dw.fat_rid AS f
LEFT JOIN dw.dim_veh AS d_veh
    ON f.srk_veh = d_veh.srk_veh
WHERE
    f.bkg_stt = 'Completed'
GROUP BY
    d_veh.veh_typ
ORDER BY
    valor_total DESC;

-- 3. Volume de Corridas ao longo do tempo por Mês
SELECT
    d_dat.year_number,
    d_dat.day_mth,
    d_dat.mth_nme,
    COUNT(f.srk_rid) AS total_de_corridas
FROM dw.fat_rid AS f
LEFT JOIN dw.dim_dat AS d_dat 
    ON f.srk_dat = d_dat.srk_dat
WHERE
    d_dat.srk_dat != -1
GROUP BY
    d_dat.year_number,
    d_dat.day_mth,
    d_dat.mth_nme
ORDER BY
    d_dat.year_number,
    d_dat.day_mth;


-- 4. Motivos de cancelamento de corrida e por quem
SELECT
    f.ccd_by,
    f.rfc,
    COUNT(f.srk_rid) AS total_cancelamentos
FROM dw.fat_rid AS f
WHERE
    f.ccd_by IN ('customer', 'driver')
    AND f.rfc IS NOT NULL
GROUP BY
    f.ccd_by,
    f.rfc
ORDER BY
    f.ccd_by,
    total_cancelamentos DESC;


-- 5. Avaliações médias por tipo de veículo
SELECT
    v.veh_typ,
    ROUND(AVG(f.drv_rtg)::numeric, 2) AS avg_driver_rating,
    ROUND(AVG(f.cus_rtg)::numeric, 2) AS avg_customer_rating,
    COUNT(*) AS total_rides
FROM dw.fat_rid f
JOIN dw.dim_veh v 
    ON f.srk_veh = v.srk_veh
GROUP BY
    v.veh_typ
ORDER BY
    avg_driver_rating DESC;


-- 6. Top 5 clientes por valor total de booking
SELECT
    c.cus_id,
    SUM(COALESCE(f.bkg_vle, 0)) AS total_booking_value,
    COUNT(f.srk_rid) AS total_rides,
    ROUND(AVG(f.cus_rtg)::numeric, 2) AS avg_customer_rating
FROM dw.fat_rid f
JOIN dw.dim_cus c 
    ON f.srk_cus = c.srk_cus
GROUP BY
    c.cus_id
ORDER BY
    total_booking_value DESC
LIMIT 5;

-- 7. Média de Avaliação de Clientes por Mês 
SELECT
    d_date.day_yea,
    d_date.day_mth,
    d_date.mth_nme,
    ROUND(AVG(f.cus_rtg)::numeric, 2) AS media_avaliacao_cliente
FROM
    dw.FAT_RID AS f
LEFT JOIN
    dw.DIM_DAT AS d_date ON f.srk_dat = d_date.srk_dat
WHERE
    f.cus_rtg IS NOT NULL
    AND f.cus_rtg > 0
GROUP BY
    d_date.day_yea,
    d_date.day_mth,
    d_date.mth_nme
ORDER BY
    d_date.day_yea,
    d_date.day_mth;

-- 8. Média de Avaliação de Motoristas por Mês (Apenas avaliações positivas > 0)
SELECT
    d_date.day_yea,
    d_date.day_mth,
    d_date.mth_nme,
    ROUND(AVG(f.drv_rtg)::numeric, 2) AS media_avaliacao_motorista
FROM
    dw.FAT_RID AS f
LEFT JOIN
    dw.DIM_DAT AS d_date ON f.srk_dat = d_date.srk_dat
WHERE
    f.drv_rtg IS NOT NULL
    AND f.drv_rtg > 0
GROUP BY
    d_date.day_yea,
    d_date.day_mth,
    d_date.mth_nme
ORDER BY
    d_date.day_yea,
    d_date.day_mth;

-- 9. Volume Total de Corridas Canceladas por Cliente ou Motorista
SELECT
    COUNT(f.srk_rid) AS total_corridas_canceladas
FROM
    dw.FAT_RID AS f
WHERE
    f.bkg_stt IN ('Cancelled by Driver', 'Cancelled by Customer');

-- 10. Total de Corridas Completas por Tipo de Veículo
SELECT
    d_veh.veh_typ,
    COUNT(f.srk_rid) AS total_corridas_completas
FROM
    dw.FAT_RID AS f
LEFT JOIN
    dw.DIM_VEH AS d_veh ON f.srk_veh = d_veh.srk_veh
WHERE
    f.bkg_stt = 'Completed'
GROUP BY
    d_veh.veh_typ
ORDER BY
    total_corridas_completas DESC;