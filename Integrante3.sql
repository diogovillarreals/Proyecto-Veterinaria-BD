Use Proyecto_Veterinaria
Go

CREATE TABLE Auditoria_Citas (
    ID_Auditoria INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ID_Cita_Afectada INT NOT NULL,
    Accion_Realizada VARCHAR(50) NOT NULL,
    
   
    Estado_Anterior VARCHAR(20),
    Estado_Nuevo VARCHAR(20),
    Costo_Anterior DECIMAL(10,2),
    Costo_Nuevo DECIMAL(10,2),
    
    
    Usuario_DB VARCHAR(50) DEFAULT SYSTEM_USER,
    Fecha DATE DEFAULT GETDATE()
);

CREATE TRIGGER tr_controlCitas
    ON CITA_MEDICA
    AFTER UPDATE

    AS BEGIN 
        SET NOCOUNT ON;
            IF UPDATE (ESTADO) OR UPDATE (COSTO_CONSULTA)
            BEGIN 
            INSERT INTO Auditoria_Citas (ID_Cita_Afectada,Accion_Realizada,Estado_Anterior,Estado_Nuevo, Costo_Anterior, Costo_Nuevo)
            SELECT 
            i.ID_CITA,
            CASE 
                WHEN i.ESTADO = 'Cancelada' AND d.ESTADO <> 'Cancelada' THEN 'CANCELACIÓN DE CITA'
                WHEN i.COSTO_CONSULTA <> d.COSTO_CONSULTA THEN 'MODIFICACIÓN DE COSTO'
                ELSE 'CAMBIO DE ESTADO/COSTO'
            END,
            d.ESTADO,
            i.ESTADO,
            d.COSTO_CONSULTA,
            i.COSTO_CONSULTA
        FROM inserted i
        JOIN deleted d ON i.ID_CITA = d.ID_CITA
        WHERE i.ESTADO <> d.ESTADO OR i.COSTO_CONSULTA <> d.COSTO_CONSULTA;
    END
END;
GO



CREATE PROCEDURE SP_Aplicar_Descuento_VIP
    @ID_Cita INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Cedula_Cliente VARCHAR(10);
    DECLARE @Total_Mascotas INT;
    DECLARE @Costo_Actual DECIMAL(10,2);
    DECLARE @Nuevo_Costo DECIMAL(10,2);

    SELECT 
        @Cedula_Cliente = M.CEDULA_CLIENTE,
        @Costo_Actual = C.COSTO_CONSULTA
    FROM CITA_MEDICA C
    JOIN MASCOTA M ON C.ID_MASCOTA = M.ID_MASCOTA
    WHERE C.ID_CITA = @ID_Cita;

    SELECT @Total_Mascotas = COUNT(ID_MASCOTA)
    FROM MASCOTA
    WHERE CEDULA_CLIENTE = @Cedula_Cliente;

    IF @Total_Mascotas >= 3
    BEGIN
        SET @Nuevo_Costo = @Costo_Actual * 0.85; 

        UPDATE CITA_MEDICA
        SET COSTO_CONSULTA = @Nuevo_Costo
        WHERE ID_CITA = @ID_Cita;

        PRINT '====================================================';
        PRINT ' ALERTA DE SISTEMA: ¡CLIENTE VIP DETECTADO! ';
        PRINT '====================================================';
        PRINT 'Motivo: El cliente posee ' + CAST(@Total_Mascotas AS VARCHAR) + ' mascotas registradas.';
        PRINT 'Costo original: $' + CAST(@Costo_Actual AS VARCHAR);
        PRINT 'Descuento aplicado: 15%';
        PRINT 'NUEVO TOTAL A PAGAR: $' + CAST(@Nuevo_Costo AS VARCHAR);
        PRINT '====================================================';
    END
    ELSE
    BEGIN
        PRINT 'Proceso de cobro normal. El cliente posee ' + CAST(@Total_Mascotas AS VARCHAR) + ' mascota(s).';
        PRINT 'No aplica descuento por fidelización (se requieren mínimo 3).';
    END
END;
GO

