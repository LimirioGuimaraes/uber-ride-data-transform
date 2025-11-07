-- Total de Booking value por Veiculo
SELECT
    d_veh.vehicle_type,
    SUM(f.booking_value) AS valor_total
FROM
    dw.fat_rid AS f
LEFT JOIN
    dw.dim_veh AS d_veh ON f.srk_veh = d_veh.srk_veh
GROUP BY
    d_veh.vehicle_type
ORDER BY
    valor_total DESC;


-- Volume de Corridas ao longo do tempo por Mes
SELECT
    d_date.year_number,
    d_date.month_number,
    d_date.month_name,
    COUNT(f.srk_rid) AS total_de_corridas
FROM
    dw.fat_rid AS f
LEFT JOIN
    dw.dim_date AS d_date ON f.srk_date = d_date.srk_date
WHERE
    d_date.srk_date != -1
GROUP BY
    d_date.year_number,
    d_date.month_number,
    d_date.month_name
ORDER BY
    d_date.year_number,
    d_date.month_number;


-- Motivos de cancelamento de corrida e por quem

SELECT
    f.cancelled_by,
    f.reason_for_cancelling,
    COUNT(f.srk_rid) AS total_cancelamentos
FROM
    dw.fat_rid AS f
WHERE
    f.cancelled_by IN ('customer', 'driver')
    AND f.reason_for_cancelling IS NOT NULL
GROUP BY
    f.cancelled_by,
    f.reason_for_cancelling
ORDER BY
    f.cancelled_by,
    total_cancelamentos DESC; 