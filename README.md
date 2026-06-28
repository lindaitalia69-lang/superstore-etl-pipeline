# 🛒 Superstore ETL Pipeline

## Descripción
Pipeline ETL completo construido con KNIME Analytics Platform sobre el dataset 
Superstore Sales de Kaggle. Implementa un modelo dimensional en esquema estrella 
con carga en AWS RDS MySQL y resúmenes analíticos en MongoDB Atlas.

## 🏗️ Arquitectura
CSV (Kaggle) → KNIME ETL → AWS RDS MySQL → MongoDB Atlas

## 📊 Modelo Dimensional
- **FactVentas** — Tabla de hechos con métricas de ventas
- **DimProducto** — Dimensión de productos (categoría, subcategoría)
- **DimCliente** — Dimensión de clientes (segmento, región)
- **DimTiempo** — Dimensión temporal (año, mes, trimestre)

## 🛠️ Tecnologías
- KNIME Analytics Platform
- MySQL / AWS RDS
- MongoDB Atlas
- SQL

## 📁 Archivos
- `Examen_2.knwf` — Workflow KNIME completo
- `superstore_dw.sql` — Script de creación de tablas
- `queries_mongodb.txt` — Queries de agregación MongoDB
- `resumen_categoria.json` — Resumen analítico por categoría
- `resumen_region.json` — Resumen analítico por región

## 📈 Resultados
| Tabla | Registros |
|-------|-----------|
| DimProducto | 1,862 |
| DimCliente | 793 |
| DimTiempo | 1,237 |
| FactVentas | 9,994 |

## 🔗 Dataset
[Superstore Sales Dataset - Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
