CREATE DATABASE proyecto_ventas;
USE proyecto_ventas;

USE proyecto_ventas;

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    categoria VARCHAR(50)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    segmento VARCHAR(50),
    pais VARCHAR(50)
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    fecha DATE,
    id_producto INT,
    id_cliente INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    costo_unitario DECIMAL(10,2)
);

LOAD DATA INFILE 'D:/Users/OneDrive/Desktop/Proyecto_venta/productos.csv'
INTO TABLE productos
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/Users/OneDrive/Desktop/Proyecto_venta/clientes.csv'
INTO TABLE clientes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/Users/OneDrive/Desktop/Proyecto_venta/ventas.csv'
INTO TABLE ventas
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/productos.csv'
INTO TABLE productos
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clientes.csv'
INTO TABLE clientes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ventas.csv'
INTO TABLE ventas
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT *
FROM ventas
LIMIT 10;

-- ¿cuantas ventas hay en total y cual es el ingreso total ? -- 

SELECT 
	count(*) AS ventas_totales,
    sum( cantidad * precio_unitario ) AS ingreso_total,
    sum( cantidad * costo_unitario ) AS costo_total,
    sum( cantidad * precio_unitario ) - sum( cantidad * costo_unitario ) AS ganancia_total
FROM ventas;

-- ¿Cuál es el ingreso y ganancia por categoría de producto? --

SELECT 
		p.categoria,
        count(*) AS total_ventas,
        sum( v.cantidad * v.precio_unitario ) AS ingreso_total,
        sum( v.cantidad * v.costo_unitario ) AS costo_total,
        sum( v.cantidad * v.precio_unitario ) - sum( v.cantidad * v.costo_unitario ) AS ganancia_total,
        round((sum( v.cantidad * v.precio_unitario ) - sum( v.cantidad * v.costo_unitario )) / sum( v.cantidad * v.precio_unitario ) * 100, 2) AS margen_ptc
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.categoria
ORDER BY ganancia_total DESC;

-- ¿Cómo evolucionan las ventas mes a mes? ---

SELECT
		DATE_FORMAT(fecha, "%Y-%m") AS mes,
        count(*) total_ventas,
        SUM( cantidad * precio_unitario ) AS ingreso_total,
        SUM( cantidad * precio_unitario ) - SUM( cantidad * costo_unitario ) AS ganancia_total
FROM ventas
GROUP BY DATE_FORMAT(fecha, "%Y-%m")
ORDER BY mes ASC;

-- ¿Cuáles son los 5 mejores clientes? --

SELECT
		c.nombre_cliente,
        c.segmento,
        c.pais,
        COUNT(*) AS total_compras,
        SUM( v.cantidad * v.precio_unitario ) AS ingreso_total,
        SUM( v.cantidad * v.precio_unitario ) - SUM( v.cantidad * v.costo_unitario ) AS ganancias_totales
FROM ventas v
JOIN clientes c ON c.id_cliente = v.id_cliente 
GROUP BY c.id_cliente, c.nombre_cliente, c.segmento, c.pais
ORDER BY ingreso_total DESC
LIMIT 5; 
