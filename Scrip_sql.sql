CREATE DATABASE IF NOT EXISTS superstore_dw;
USE superstore_dw;


CREATE DATABASE IF NOT EXISTS superstore_dw
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE superstore_dw;

CREATE TABLE DimProducto (
  ProductoKey   INT          NOT NULL AUTO_INCREMENT,
  ProductID     VARCHAR(20)  NOT NULL,
  ProductName   VARCHAR(255) NOT NULL,
  Category      VARCHAR(50)  NOT NULL,
  SubCategory   VARCHAR(50)  NOT NULL,
  CONSTRAINT pk_DimProducto PRIMARY KEY (ProductoKey)
);

CREATE TABLE DimCliente (
  ClienteKey    INT          NOT NULL AUTO_INCREMENT,
  CustomerID    VARCHAR(20)  NOT NULL,
  CustomerName  VARCHAR(100) NOT NULL,
  Segment       VARCHAR(30)  NOT NULL,
  Region        VARCHAR(20)  NOT NULL,
  State         VARCHAR(50)  NOT NULL,
  CONSTRAINT pk_DimCliente PRIMARY KEY (ClienteKey)
);

CREATE TABLE DimTiempo (
  TiempoKey     INT          NOT NULL AUTO_INCREMENT,
  OrderDate     DATE         NOT NULL,
  Anio          INT          NOT NULL,
  Mes           INT          NOT NULL,
  Trimestre     INT          NOT NULL,
  NombreMes     VARCHAR(20)  NOT NULL,
  CONSTRAINT pk_DimTiempo PRIMARY KEY (TiempoKey)
);

CREATE TABLE FactVentas (
  VentaKey      INT            NOT NULL AUTO_INCREMENT,
  ProductoKey   INT            NOT NULL,
  ClienteKey    INT            NOT NULL,
  TiempoKey     INT            NOT NULL,
  Sales         DECIMAL(10,4)  NOT NULL,
  Quantity      INT            NOT NULL,
  Discount      DECIMAL(5,2)   NOT NULL,
  Profit        DECIMAL(10,4)  NOT NULL,
  CONSTRAINT pk_FactVentas  PRIMARY KEY (VentaKey),
  CONSTRAINT fk_Producto    FOREIGN KEY (ProductoKey)
    REFERENCES DimProducto(ProductoKey),
  CONSTRAINT fk_Cliente     FOREIGN KEY (ClienteKey)
    REFERENCES DimCliente(ClienteKey),
  CONSTRAINT fk_Tiempo      FOREIGN KEY (TiempoKey)
    REFERENCES DimTiempo(TiempoKey)
    
    
    
    USE superstore_dw;

DROP TABLE IF EXISTS FactVentas;

CREATE TABLE FactVentas (
  VentaKey    INT            PRIMARY KEY,
  ProductoKey INT            NOT NULL,
  ClienteKey  INT            NOT NULL,
  TiempoKey   INT            NOT NULL,
  Sales       DECIMAL(10,4)  NOT NULL,
  Quantity    INT            NOT NULL,
  Discount    DECIMAL(5,2)   NOT NULL,
  Profit      DECIMAL(10,4)  NOT NULL,
  CONSTRAINT fk_Producto FOREIGN KEY (ProductoKey)
    REFERENCES DimProducto(ProductoKey),
  CONSTRAINT fk_Cliente  FOREIGN KEY (ClienteKey)
    REFERENCES DimCliente(ClienteKey),
  CONSTRAINT fk_Tiempo   FOREIGN KEY (TiempoKey)
    REFERENCES DimTiempo(TiempoKey)
);

ALTER TABLE FactVentas 
MODIFY Sales DOUBLE NOT NULL,
MODIFY Discount DOUBLE NOT NULL,
MODIFY Profit DOUBLE NOT NULL;

-- =====================================================
-- EVIDENCIAS SQL - Examen_2
-- Data Warehouse: superstore_dw
-- =====================================================

USE superstore_dw;

-- =====================================================
-- 1. VERIFICACIÓN DE TABLAS CREADAS
-- =====================================================
SHOW TABLES;

-- =====================================================
-- 2. CONTEO DE REGISTROS POR TABLA
-- =====================================================
SELECT 'DimProducto'  AS Tabla, COUNT(*) AS Total_Registros FROM DimProducto
UNION ALL
SELECT 'DimCliente',              COUNT(*) FROM DimCliente
UNION ALL
SELECT 'DimTiempo',               COUNT(*) FROM DimTiempo
UNION ALL
SELECT 'FactVentas',              COUNT(*) FROM FactVentas;

-- =====================================================
-- 3. ESTRUCTURA DE CADA TABLA
-- =====================================================
DESCRIBE DimProducto;
DESCRIBE DimCliente;
DESCRIBE DimTiempo;
DESCRIBE FactVentas;

-- =====================================================
-- 4. MUESTRA DE DATOS (primeras 5 filas)
-- =====================================================
SELECT * FROM DimProducto  LIMIT 5;
SELECT * FROM DimCliente   LIMIT 5;
SELECT * FROM DimTiempo    LIMIT 5;
SELECT * FROM FactVentas   LIMIT 5;

-- =====================================================
-- 5. VALIDACIÓN DE FOREIGN KEYS (integridad referencial)
-- =====================================================
-- Ventas sin Producto válido
SELECT COUNT(*) AS Ventas_Sin_Producto
FROM FactVentas f
LEFT JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
WHERE p.ProductoKey IS NULL;

-- Ventas sin Cliente válido
SELECT COUNT(*) AS Ventas_Sin_Cliente
FROM FactVentas f
LEFT JOIN DimCliente c ON f.ClienteKey = c.ClienteKey
WHERE c.ClienteKey IS NULL;

-- Ventas sin Tiempo válido
SELECT COUNT(*) AS Ventas_Sin_Tiempo
FROM FactVentas f
LEFT JOIN DimTiempo t ON f.TiempoKey = t.TiempoKey
WHERE t.TiempoKey IS NULL;

-- =====================================================
-- 6. ANÁLISIS DE VENTAS POR DIMENSIÓN
-- =====================================================

-- Ventas totales por Categoría de Producto
SELECT 
    p.Category,
    COUNT(f.VentaKey)        AS Total_Transacciones,
    ROUND(SUM(f.Sales), 2)   AS Total_Ventas,
    ROUND(SUM(f.Profit), 2)  AS Total_Ganancia,
    ROUND(AVG(f.Discount)*100, 2) AS Descuento_Promedio_Pct
FROM FactVentas f
JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
GROUP BY p.Category
ORDER BY Total_Ventas DESC;

-- Ventas totales por Segmento de Cliente
SELECT 
    c.Segment,
    COUNT(f.VentaKey)       AS Total_Transacciones,
    ROUND(SUM(f.Sales), 2)  AS Total_Ventas,
    ROUND(SUM(f.Profit), 2) AS Total_Ganancia
FROM FactVentas f
JOIN DimCliente c ON f.ClienteKey = c.ClienteKey
GROUP BY c.Segment
ORDER BY Total_Ventas DESC;

-- Ventas totales por Año
SELECT 
    t.Year,
    COUNT(f.VentaKey)       AS Total_Transacciones,
    ROUND(SUM(f.Sales), 2)  AS Total_Ventas,
    ROUND(SUM(f.Profit), 2) AS Total_Ganancia
FROM FactVentas f
JOIN DimTiempo t ON f.TiempoKey = t.TiempoKey
GROUP BY t.Year
ORDER BY t.Year;

-- =====================================================
-- 7. TOP 5 PRODUCTOS MÁS VENDIDOS
-- =====================================================
SELECT 
    p.ProductName,
    p.Category,
    COUNT(f.VentaKey)      AS Veces_Vendido,
    ROUND(SUM(f.Sales), 2) AS Total_Ventas
FROM FactVentas f
JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
GROUP BY p.ProductoKey, p.ProductName, p.Category
ORDER BY Total_Ventas DESC
LIMIT 5;

-- =====================================================
-- 8. TOP 5 CLIENTES CON MAYOR COMPRA
-- =====================================================
SELECT 
    c.CustomerName,
    c.Segment,
    c.Region,
    COUNT(f.VentaKey)      AS Total_Ordenes,
    ROUND(SUM(f.Sales), 2) AS Total_Compras
FROM FactVentas f
JOIN DimCliente c ON f.ClienteKey = c.ClienteKey
GROUP BY c.ClienteKey, c.CustomerName, c.Segment, c.Region
ORDER BY Total_Compras DESC
LIMIT 5;


