USE Proyecto_Veterinaria
GO

--Tarea 1:
SELECT * FROM INSUMO; --Actualizaciones para los precios en la tabla INSUMOS

ALTER TABLE INSUMO ADD PRECIO_UNITARIO DECIMAL(18,2);

UPDATE INSUMO SET PRECIO_UNITARIO = 0.25 WHERE ID_INSUMO = 1; 
UPDATE INSUMO SET PRECIO_UNITARIO = 3.80 WHERE ID_INSUMO = 2; 
UPDATE INSUMO SET PRECIO_UNITARIO = 1.75 WHERE ID_INSUMO = 3; 
UPDATE INSUMO SET PRECIO_UNITARIO = 15.00 WHERE ID_INSUMO = 4; 
UPDATE INSUMO SET PRECIO_UNITARIO = 2.50 WHERE ID_INSUMO = 5; 

ALTER TABLE INSUMO --Asegura que los precios de los insumos no se pueden ingresar en negativo.
ADD CONSTRAINT CHK_PrecioUnitario CHECK (PRECIO_UNITARIO >= 0.00);
GO

SELECT * FROM EMPLEADO;

ALTER TABLE EMPLEADO --Asegura que el sueldo mínimo de los empleados no sea menor a $460.00.
ADD CONSTRAINT CHK_SueldoMinimo CHECK (SALARIO >= 460.00);
GO

--Tarea 2:
DROP TABLE HISTORIAL_MEDICO; --Eliminar la tabla original mal estructurada.
GO

CREATE TABLE HISTORIAL_MEDICO ( -- Crear la tabla con la relación 1:1 estricta.
    ID_MASCOTA INT PRIMARY KEY NOT NULL,     
    ALERGIAS VARCHAR(200) NOT NULL,
    CONDICIONES_CRONICAS VARCHAR(500) NOT NULL,
    FECHA_CREACION DATE NOT NULL,
    CONSTRAINT FK_HISTORIAL_MASCOTA FOREIGN KEY (ID_MASCOTA) REFERENCES MASCOTA(ID_MASCOTA)
);
GO

INSERT INTO HISTORIAL_MEDICO (ID_MASCOTA, ALERGIAS, CONDICIONES_CRONICAS, FECHA_CREACION) --Reinsertar datos a la nueva estructura.
VALUES 
(1, 'Ninguna', 'Displasia de cadera leve', '2025-01-15'),
(2, 'Alergia al pollo', 'Ninguna', '2025-01-15'),
(3, 'Ninguna', 'Problemas respiratorios', '2025-03-22'),
(4, 'Ninguna', 'Ninguna', '2026-05-01'),
(5, 'Sensibilidad a la anestesia', 'Ninguna', '2026-05-12');
GO

--Tarea 3: 
CREATE UNIQUE NONCLUSTERED INDEX UQ_IX_PERSONA_CORREO
ON PERSONA (CORREO);
GO --Crea un puntero en cada correo para facilitar su busqueda y evita que se ingrese un nuevo correo repetido a uno existente.

--Tarea 4:
CREATE NONCLUSTERED INDEX IX_CITAMEDICA_FECHA
ON CITA_MEDICA (FECHA_CITA);
GO --Crea un índice organizador para la columna de las fechas de las citas médicas.