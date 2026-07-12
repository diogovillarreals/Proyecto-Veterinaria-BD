USE Proyecto_Veterinaria;
GO

-- Tarea 1: Procedimiento Almacenado

CREATE OR ALTER PROCEDURE SP_Cierre_Mensual_Veterinarios
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Tarea 2: Estructuras Temporales
    IF OBJECT_ID('tempdb..#ReporteMensual') IS NOT NULL
        DROP TABLE #ReporteMensual;

    CREATE TABLE #ReporteMensual (
        Cedula_Empleado VARCHAR(10),
        Nombre_Veterinario VARCHAR(20),
        Citas_Atendidas INT,
        Ingreso_Consultas DECIMAL(10,2),
        Ingreso_Insumos DECIMAL(10,2),
        Ingreso_Total DECIMAL(10,2)
    );

    
    -- Tarea 3: Ciclos (Iteración sobre el personal médico)
   
    DECLARE @CedulaActual VARCHAR(10);
    DECLARE @NombreActual VARCHAR(20);

    DECLARE cur_Veterinarios CURSOR FOR
    SELECT E.CEDULA_EMPLEADO, P.NOMBRE
    FROM EMPLEADO E
    JOIN PERSONA P ON E.CEDULA_EMPLEADO = P.CEDULA
    WHERE E.ROL LIKE '%Veterinario%';

    OPEN cur_Veterinarios;
    FETCH NEXT FROM cur_Veterinarios INTO @CedulaActual, @NombreActual;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @CantidadCitas INT = 0;
        DECLARE @TotalConsultas DECIMAL(10,2) = 0.00;
        DECLARE @TotalInsumos DECIMAL(10,2) = 0.00;

        SELECT 
            @CantidadCitas = COUNT(ID_CITA),
            @TotalConsultas = ISNULL(SUM(COSTO_CONSULTA), 0)
        FROM CITA_MEDICA
        WHERE CEDULA_EMPLEADO = @CedulaActual
          AND MONTH(FECHA_CITA) = @Mes
          AND YEAR(FECHA_CITA) = @Anio
          AND ESTADO = 'Completada';

        SELECT 
            @TotalInsumos = ISNULL(SUM(dbo.fn_Calcular_Total_Insumos(ID_CITA)), 0)
        FROM CITA_MEDICA
        WHERE CEDULA_EMPLEADO = @CedulaActual
          AND MONTH(FECHA_CITA) = @Mes
          AND YEAR(FECHA_CITA) = @Anio
          AND ESTADO = 'Completada';

        INSERT INTO #ReporteMensual (
            Cedula_Empleado, 
            Nombre_Veterinario, 
            Citas_Atendidas, 
            Ingreso_Consultas, 
            Ingreso_Insumos, 
            Ingreso_Total
        )
        VALUES (
            @CedulaActual, 
            @NombreActual, 
            @CantidadCitas, 
            @TotalConsultas, 
            @TotalInsumos, 
            (@TotalConsultas + @TotalInsumos)
        );

        FETCH NEXT FROM cur_Veterinarios INTO @CedulaActual, @NombreActual;
    END

    CLOSE cur_Veterinarios;
    DEALLOCATE cur_Veterinarios;

    -- Despliegue del reporte gerencial final
    SELECT * 
    FROM #ReporteMensual 
    ORDER BY Ingreso_Total DESC;

    DROP TABLE #ReporteMensual;
END;
GO


EXEC SP_Cierre_Mensual_Veterinarios @Mes = 5, @Anio = 2026;
GO