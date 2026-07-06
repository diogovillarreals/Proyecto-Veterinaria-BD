CREATE DATABASE Proyecto_Veterinaria;
GO

USE Proyecto_Veterinaria;
GO

-- -------------------------------------------------------
-- FASE 1: CREACIÓN DE TABLAS (ESTRUCTURA ORIGINAL)
-- -------------------------------------------------------

CREATE TABLE PERSONA (
    CEDULA VARCHAR(10) PRIMARY KEY NOT NULL,
    NOMBRE VARCHAR(20) NOT NULL,
    CORREO VARCHAR(50) NOT NULL,
    CALLE VARCHAR(50) NOT NULL,
    NUMERO VARCHAR(10) NOT NULL,
    SECTOR VARCHAR(50) NOT NULL
);

CREATE TABLE TELEFONO_PERSONA (
    CEDULA_PERSONA VARCHAR(10) NOT NULL,
    NUM_PERSONA VARCHAR(10) NOT NULL,
    PRIMARY KEY (CEDULA_PERSONA, NUM_PERSONA),
    CONSTRAINT FK_TELEFONO_PER FOREIGN KEY (CEDULA_PERSONA) REFERENCES PERSONA(CEDULA)
);

CREATE TABLE EMPLEADO (
    CEDULA_EMPLEADO VARCHAR(10) PRIMARY KEY NOT NULL,
    ROL VARCHAR(50),
    SALARIO DECIMAL(10,2),
    CONSTRAINT FK_CEDULA_PER FOREIGN KEY (CEDULA_EMPLEADO) REFERENCES PERSONA(CEDULA)
);

CREATE TABLE CLIENTE (
    CEDULA_CLIENTE VARCHAR(10) PRIMARY KEY NOT NULL,
    FECHA_REGISTRO DATE NOT NULL,
    CONSTRAINT FK_CEDULA_CLI FOREIGN KEY (CEDULA_CLIENTE) REFERENCES PERSONA(CEDULA)
);

CREATE TABLE MASCOTA (
    ID_MASCOTA INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
    CEDULA_CLIENTE VARCHAR(10) NOT NULL,
    NOMBRE_MASCOTA VARCHAR(20) NOT NULL,
    ESPECIE VARCHAR(20) NOT NULL,
    RAZA VARCHAR(20) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    PESO_ACTUAL DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_MASCOTA_CLIENTE FOREIGN KEY (CEDULA_CLIENTE) REFERENCES CLIENTE(CEDULA_CLIENTE)
);

CREATE TABLE CITA_MEDICA (
    ID_CITA INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ID_MASCOTA INT NOT NULL,
    CEDULA_EMPLEADO VARCHAR(10) NOT NULL,
    FECHA_CITA DATE NOT NULL,
    MOTIVO VARCHAR(500) NOT NULL,
    DIAGNOSTICO_FINAL VARCHAR(1000) NOT NULL,
    COSTO_CONSULTA DECIMAL(10,2) NOT NULL,
    ESTADO VARCHAR(20) NOT NULL,
    CONSTRAINT FK_CITA_EMPLEADO FOREIGN KEY (CEDULA_EMPLEADO) REFERENCES EMPLEADO(CEDULA_EMPLEADO),
    CONSTRAINT FK_CITA_MASCOTA FOREIGN KEY (ID_MASCOTA) REFERENCES MASCOTA(ID_MASCOTA)
);

CREATE TABLE HISTORIAL_MEDICO (
    ID_MASCOTA INT NOT NULL,
    NUM_HISTORIAL INT NOT NULL,
    ALERGIAS VARCHAR(200) NOT NULL,
    CONDICIONES_CRONICAS VARCHAR(500) NOT NULL,
    FECHA_CREACION DATE NOT NULL,
    PRIMARY KEY(ID_MASCOTA, NUM_HISTORIAL),
    CONSTRAINT FK_HISTORIAL_MASCOTA FOREIGN KEY (ID_MASCOTA) REFERENCES MASCOTA(ID_MASCOTA)
);

CREATE TABLE INSUMO (
    ID_INSUMO INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NOMBRE_INSUMO VARCHAR(100) NOT NULL,
    UNIDAD_MEDIDA VARCHAR(30) NOT NULL
);

CREATE TABLE INSUMO_CONSUMIDO (
    ID_Cita INT NOT NULL,
    ID_Insumo INT NOT NULL,
    Cantidad_Utilizada DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ID_Cita, ID_Insumo),
    CONSTRAINT FK_CONSUMIDO_CITA FOREIGN KEY (ID_Cita) REFERENCES CITA_MEDICA(ID_Cita),
    CONSTRAINT FK_CONSUMIDO_INSUMO FOREIGN KEY (ID_Insumo) REFERENCES Insumo(ID_Insumo)
);
GO

-- -------------------------------------------------------
-- FASE 2: INSERCIÓN DE DATOS (POBLACIÓN)
-- -------------------------------------------------------

-- 1. Insertar en PERSONA
INSERT INTO PERSONA (CEDULA, NOMBRE, CORREO, CALLE, NUMERO, SECTOR) VALUES 
('1700000001', 'Juan Perez', 'juan.perez@email.com', 'Av. Amazonas', 'N34-12', 'La Mariscal'),
('1700000002', 'Maria Lopez', 'maria.lopez@email.com', 'Av. 6 de Diciembre', 'S12-45', 'El Batan'),
('1700000003', 'Carlos Gomez', 'carlos.gomez@email.com', 'Calle Guayaquil', 'Oe4-12', 'Centro Historico'),
('1700000004', 'Ana Torres', 'ana.torres@email.com', 'Av. Eloy Alfaro', 'N45-78', 'San Isidro'),
('1700000005', 'Luis Sanchez', 'luis.sanchez@email.com', 'Av. Shyris', 'N39-10', 'La Carolina'),
('1700000006', 'Laura Falconi', 'laura.falconi@email.com', 'Av. De la Prensa', 'N50-22', 'Cotocollao'),
('1700000007', 'Diego Andrade', 'diego.andrade@email.com', 'Calle Lerida', 'E12-15', 'La Vicentina'),
('1700000008', 'Patricio Estrella', 'patricio.e@email.com', 'Av. Patria', 'N10-44', 'La Colon'),
('1700000009', 'Elena Mendoza', 'elena.m@email.com', 'Av. Real Audiencia', 'N60-11', 'Ponceano');

-- 2. Insertar en TELEFONO_PERSONA
INSERT INTO TELEFONO_PERSONA (CEDULA_PERSONA, NUM_PERSONA) VALUES 
('1700000001', '0991111111'),
('1700000001', '022222222'),
('1700000002', '0993333333'),
('1700000004', '0994444444'),
('1700000005', '0995555555'),
('1700000009', '0999999991'),
('1700000009', '0999999992'),
('1700000009', '022999999');

-- 3. Insertar en CLIENTE
INSERT INTO CLIENTE (CEDULA_CLIENTE, FECHA_REGISTRO) VALUES 
('1700000001', '2025-01-15'),
('1700000002', '2025-03-22'),
('1700000003', '2026-05-01'),
('1700000006', '2026-05-10'),
('1700000007', '2026-05-12');

-- 4. Insertar en EMPLEADO
INSERT INTO EMPLEADO (CEDULA_EMPLEADO, ROL, SALARIO) VALUES 
('1700000004', 'Veterinario Cirujano', 1200.00),
('1700000005', 'Veterinario General', 850.00),
('1700000008', 'Veterinario Traumatologo', 1500.00);

-- 5. Insertar en INSUMO (ID_INSUMO se genera solo: 1, 2, 3, 4, 5)
INSERT INTO INSUMO (NOMBRE_INSUMO, UNIDAD_MEDIDA) VALUES 
('Jeringa 5ml', 'Unidad'),       
('Suero Fisiologico', 'Litro'),   
('Gasa Esteril', 'Paquete'),      
('Vacuna Antirrabica', 'Dosis'),  
('Anestesia General', 'Mililitro');

-- 6. Insertar en MASCOTA (ID_MASCOTA se genera solo: 1, 2, 3, 4, 5)
INSERT INTO MASCOTA (CEDULA_CLIENTE, NOMBRE_MASCOTA, ESPECIE, RAZA, FECHA_NACIMIENTO, PESO_ACTUAL) VALUES 
('1700000001', 'Max', 'Perro', 'Golden Retriever', '2020-05-10', 25.50), 
('1700000001', 'Luna', 'Gato', 'Siames', '2022-08-15', 4.20),           
('1700000002', 'Rocky', 'Perro', 'Bulldog', '2021-11-20', 18.00),        
('1700000003', 'Coco', 'Loro', 'Amazonico', '2023-01-05', 0.80),         
('1700000007', 'Thor', 'Perro', 'Pastor Aleman', '2024-02-10', 32.10);   

-- 7. Insertar en HISTORIAL_MEDICO 
INSERT INTO HISTORIAL_MEDICO (ID_MASCOTA, NUM_HISTORIAL, ALERGIAS, CONDICIONES_CRONICAS, FECHA_CREACION) VALUES 
(1, 1, 'Ninguna', 'Displasia de cadera leve', '2025-01-15'),
(2, 1, 'Alergia al pollo', 'Ninguna', '2025-01-15'),
(3, 1, 'Ninguna', 'Problemas respiratorios', '2025-03-22'),
(4, 1, 'Ninguna', 'Ninguna', '2026-05-01'),
(5, 1, 'Sensibilidad a la anestesia', 'Ninguna', '2026-05-12');

-- 8. Insertar en CITA_MEDICA (ID_CITA se genera solo: 1, 2, 3, 4, 5)
INSERT INTO CITA_MEDICA (ID_MASCOTA, CEDULA_EMPLEADO, FECHA_CITA, MOTIVO, DIAGNOSTICO_FINAL, COSTO_CONSULTA, ESTADO) VALUES 
(1, '1700000005', '2026-05-05', 'Control anual', 'Paciente sano', 35.00, 'Completada'),                    
(3, '1700000004', '2026-05-08', 'Problema al respirar', 'Infeccion respiratoria', 45.00, 'Completada'),     
(2, '1700000005', '2026-05-09', 'Vacunacion', 'Paciente sano, vacunado', 25.00, 'Completada'),              
(1, '1700000004', '2026-05-14', 'Cirugia por fractura', 'Fijacion de femur exitosa', 350.00, 'Completada'), 
(3, '1700000005', '2026-05-15', 'Control post-operatorio', 'Ninguno', 0.00, 'Cancelada');                   

-- 9. Insertar en INSUMO_CONSUMIDO 
INSERT INTO INSUMO_CONSUMIDO (ID_Cita, ID_Insumo, Cantidad_Utilizada) VALUES 
(1, 1, 1.00), 
(1, 4, 1.00), 
(2, 2, 0.50), 
(2, 3, 2.00), 
(3, 1, 1.00), 
(3, 4, 1.00), 
(4, 5, 15.00),
(4, 2, 2.00), 
(4, 3, 5.00); 
GO