CREATE TABLE entrega (
    id INTEGER PRIMARY KEY,
    destinatario VARCHAR(100) NOT NULL,
    data_saida DATE DEFAULT CURRENT_DATE,
    hora_saida TIME DEFAULT LOCALTIME,
    previsao_entrega TIMESTAMP DEFAULT LOCALTIMESTAMP,
    data_entrega DATE DEFAULT CURRENT_DATE,
    hora_entrega TIME DEFAULT LOCALTIME,
    valor_frete NUMERIC(10,2) NOT NULL
);

INSERT INTO entrega
(id, destinatario, data_saida, hora_saida, previsao_entrega, data_entrega, hora_entrega, valor_frete) VALUES
(1, 'Mariana', '2026-10-10', '08:30', '2026-10-12 18:00', '2026-10-12', '14:00', 25.00),
(2, 'Mário', '2026-10-14', '13:20', '2026-10-16 12:00', '2026-10-16', '16:30', 32.00),
(3, 'Patricia', '2026-09-20', '19:10', '2026-09-22 20:00', '2026-09-22', '18:00', 18.00),
(4, 'Ana', '2026-08-05', '07:15',  '2026-08-07 10:00', '2026-08-07', '13:00', 40.00);

INSERT INTO entrega (id, destinatario, valor_frete) VALUES
(5, 'Camila', 27.00),
(6, 'Bruno', 22.00),
(7, 'Larissa', 35.00);

--Q1
SELECT destinatario, data_entrega as hoje FROM entrega
WHERE data_entrega = CURRENT_DATE;

--Q2
SELECT destinatario, data_entrega as setembro FROM entrega
WHERE EXTRACT(MONTH FROM data_entrega) = 9;

--Q3
SELECT destinatario, hora_entrega as "12 as 18hrs" FROM entrega
WHERE EXTRACT(HOUR FROM hora_entrega) > 12 AND EXTRACT(HOUR FROM hora_entrega) < 18
ORDER BY hora_entrega;

--Q4
SELECT destinatario, DATE_PART('day', data_entrega) as diaEntrega, DATE_PART('month', data_entrega) as mesEntrega, DATE_PART('year', data_entrega) as anoEntrega FROM entrega;

--Q5
SELECT destinatario, TO_CHAR(data_entrega, 'DD/MM/YYYY')as dataBR, TO_CHAR(hora_entrega, 'HH24:MI') horaBR FROM entrega;

--Q6
SELECT destinatario, data_entrega , AGE(NOW(), data_entrega) as tempo_decorrido FROM entrega;

--Q7
SELECT destinatario, valor_frete,
	CASE 
		WHEN valor_frete BETWEEN 00.00 AND 25.00 THEN 'Frete econômico'
		WHEN valor_frete BETWEEN 25.00 AND 39.99 THEN 'Frete intermediario'
		WHEN valor_frete >= 40.00 THEN 'Frete elevado'
	END AS tipoFrete
FROM entrega;

--Q8
SELECT EXTRACT(MONTH FROM data_entrega) as mesEntrega, COUNT(*) as qtdEntregas FROM entrega
GROUP BY EXTRACT(MONTH FROM data_entrega)
ORDER BY COUNT(*) DESC;
