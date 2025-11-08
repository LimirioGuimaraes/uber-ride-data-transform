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

-- Avaliações médias por tipo de veículo

SELECT
    v.vehicle_type,
    ROUND(AVG(f.driver_rating)::numeric, 2) AS avg_driver_rating,
    ROUND(AVG(f.customer_rating)::numeric, 2) AS avg_customer_rating,
    COUNT(*) AS total_rides
FROM dw.fat_rid f
JOIN dw.dim_veh v ON f.srk_veh = v.srk_veh
GROUP BY v.vehicle_type
ORDER BY avg_driver_rating DESC;

-- Top 5 clientes por valor total de booking

SELECT
    c.customer_id,
    SUM(COALESCE(f.booking_value, 0)) AS total_booking_value,
    COUNT(f.srk_rid) AS total_rides,
    ROUND(AVG(f.customer_rating)::numeric, 2) AS avg_customer_rating
FROM dw.fat_rid f
JOIN dw.dim_cus c ON f.srk_cus = c.srk_cus
GROUP BY c.customer_id
ORDER BY total_booking_value DESC
LIMIT 5;

