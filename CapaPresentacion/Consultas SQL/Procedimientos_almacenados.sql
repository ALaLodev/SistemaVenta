
/*--------------------------------------------PROCEDIMIENTOS PARA USUARIOS-----------------------------------------*/
--REGISTRAR USUARIOS
create proc sp_registrarusuario(
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @IdUsuarioResultado = 0
	set @Mensaje = ''

	if not exists (select * from USUARIO where Documento = @Documento)
	begin
		insert into USUARIO (Documento, NombreCompleto, Correo, Clave, IdRol, Estado) values
		(@Documento, @NombreCompleto, @Correo, @Clave, @IdRol, @Estado)

		set @IdUsuarioResultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'No se puede repetir el documento para más de un usuario'

end

------------------------------------------------------------------------------
--EDITAR USUARIOS
create proc sp_editarusuario(
@IdUsuario int,
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''

	if not exists (select * from USUARIO where Documento = @Documento and IdUsuario != @IdUsuario)
	begin
		update USUARIO set
		Documento = @Documento,
		NombreCompleto = @NombreCompleto, 
		Correo = @Correo, 
		Clave = @Clave, 
		IdRol = @IdRol, 
		Estado = @Estado
		where IdUsuario = @IdUsuario

		set @Respuesta = 1
	end
	else
		set @Mensaje = 'No se puede repetir el documento para más de un usuario'

end
---------------------------------------------------------------------
--ELIMINAR USUARIOS
CREATE PROCEDURE sp_eliminarusuario
(
    @IdUsuario int,
    @Respuesta bit OUTPUT,
    @Mensaje varchar(500) OUTPUT
)
AS
BEGIN
    SET @Respuesta = 0
    SET @Mensaje = ''
    DECLARE @pasoreglas bit = 1 -- Inicializamos a 1

    IF EXISTS (
        SELECT * 
        FROM COMPRA C
        INNER JOIN USUARIO U ON U.IdUsuario = C.IdUsuario
        WHERE U.IdUsuario = @IdUsuario
    )
    BEGIN
        SET @pasoreglas = 0
        SET @Respuesta = 0
        SET @Mensaje = @Mensaje + 'No se puede eliminar porque el usuario se encuentra relacionado a una COMPRA\n'
    END

    IF EXISTS (
        SELECT * 
        FROM VENTA V
        INNER JOIN USUARIO U ON U.IdUsuario = V.IdUsuario
        WHERE U.IdUsuario = @IdUsuario
    )
    BEGIN
        SET @pasoreglas = 0
        SET @Respuesta = 0
        SET @Mensaje = @Mensaje + 'No se puede eliminar porque el usuario se encuentra relacionado a una VENTA\n'
    END

    IF (@pasoreglas = 1)
    BEGIN
        DELETE FROM USUARIO WHERE IdUsuario = @IdUsuario
        SET @Respuesta = 1
        SET @Mensaje = 'Usuario eliminado exitosamente'
    END
END
---------------------------------------------------------------------
declare @Respuesta int
declare @Mensaje varchar (500)

exec sp_eliminarusuario 8, @Respuesta output, @Mensaje output

select @Respuesta

select @Mensaje

select * from USUARIO
-----------------------------------------------------------------------
/*---------------------------------------PROCEDIMIENTOS PARA CATEGORIAS-------------------------------------------------*/

--PROCEDIMIENTO PARA GUARDAR CATEGORIA
CREATE PROCEDURE sp_RegistraCategoria
(
	@Descripcion VARCHAR(50),	
	@Resultado INT OUTPUT,
	@Estado bit,
	@Mensaje VARCHAR (500) OUTPUT
) 
AS
BEGIN
	SET @Resultado =0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
		BEGIN
			INSERT INTO CATEGORIA (Descripcion, Estado) VALUES (@Descripcion, @Estado)
			SET @Resultado = SCOPE_IDENTITY()
		END
	ELSE
		SET @Mensaje = 'No se puede repetir la descripción de una categoría'
END

--PROCEDIMIENTO PARA MODIFICAR CATEGORIA
CREATE PROCEDURE sp_ModificarCategoria
(
	@IdCategoria INT, 
	@Descripcion VARCHAR(50),
	@Estado bit,
	@Resultado INT OUTPUT,
	@Mensaje VARCHAR (500) OUTPUT
) 
AS
BEGIN
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion AND IdCategoria != @IdCategoria)
		UPDATE CATEGORIA 
		SET Descripcion = @Descripcion, Estado = @Estado
		WHERE IdCategoria = @IdCategoria
	ELSE
		BEGIN
			SET @Resultado = 0
			SET @Mensaje = 'No se puede repetir la descripción de una categoría'
		END	
END

--PROCEDIMIENTO PARA ELIMINAR CATEGORIA
CREATE PROCEDURE sp_EliminarCategoria
(
	@IdCategoria INT, 
	@Resultado INT OUTPUT,
	@Mensaje VARCHAR (500) OUTPUT
) 
AS
BEGIN
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM CATEGORIA c
				   INNER JOIN PRODUCTO p ON p.IdCategoria = c.IdCategoria
				   WHERE c.IdCategoria = @IdCategoria
				   )
		BEGIN
			DELETE TOP(1) FROM CATEGORIA WHERE IdCategoria = @IdCategoria
		END
	ELSE
		BEGIN
			SET @Resultado = 0
			SET @Mensaje = 'No se puede eliminar, la categoria se encuentra relacionada a un producto'
		END	
END

-----------------------------------------------------------------------------------------------------------------------
/*------------------------------------------------PROCEDIMIENTOS PARA PRODUCTO---------------------------------------------------*/

--REGISTAR PRODUCTO
CREATE PROCEDURE sp_registrarproducto
(
	@Codigo varchar(20),
	@Nombre varchar (20),
	@Descripcion varchar (30),
	@IdCategoria int,
	@Estado bit, 
	@Resultado int output, 
	@Mensaje varchar(500) output
) 
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Codigo = @Codigo)
		BEGIN
			INSERT INTO PRODUCTO (Codigo, Nombre, Descripcion, IdCategoria,Estado) VALUES (@Codigo, @Nombre, @Descripcion, @IdCategoria, @Estado)
			SET @Resultado = SCOPE_IDENTITY()
		END
	ELSE
		SET @Mensaje = 'Ya existe un producto con el mismo código'
END

--MODIFICAR PRODUCTO
CREATE PROCEDURE sp_modificarproducto
(
	@IdProducto int,
	@Codigo varchar(20),
	@Nombre varchar (20),
	@Descripcion varchar (30),
	@IdCategoria int,
	@Estado bit, 
	@Resultado int output, 
	@Mensaje varchar(500) output
) 
AS
BEGIN
	SET @Resultado = 1
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Codigo = @Codigo AND IdProducto != @IdProducto)
		UPDATE PRODUCTO SET
			Codigo = @Codigo,
			Nombre = @Nombre,
			Descripcion = @Descripcion,
			IdCategoria = @IdCategoria,
			Estado = @Estado
		WHERE IdProducto = @IdProducto
	ELSE
		BEGIN
			SET @Resultado = 0
			SET @Mensaje = 'Ya existe un producto con el mismo código'
		END
END

--ELIMINAR PRODUCTO
CREATE PROCEDURE sp_eliminarproducto
(
	@IdProducto int,
	@Respuesta bit output,
	@Mensaje varchar(500) output
)
AS
BEGIN
	SET @Respuesta = 0
	SET @Mensaje = ''
	DECLARE @pasoreglas bit = 1

	IF EXISTS (SELECT * FROM DETALLE_COMPRA dc INNER JOIN PRODUCTO p ON p.IdProducto = dc.IdProducto WHERE p.IdProducto =@IdProducto)
	BEGIN
		SET @pasoreglas = 0
		SET @Respuesta = 0
		SET @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado con una COMPRA\n'
	END

	IF EXISTS (SELECT * FROM DETALLE_VENTA dv INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto WHERE p.IdProducto = @IdProducto)
	BEGIN
		SET @pasoreglas = 0
		SET @Respuesta = 0
		SET @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado con una VENTA\n'
	END

	IF (@pasoreglas = 1)
		BEGIN
			DELETE FROM PRODUCTO WHERE IdProducto = @IdProducto
			SET @Respuesta = 1
		END
END

----------------------------------------------------------------------------------------------------------------------------------------------------------
/*--------------------------------------------------PROCEDIMIENTOS PARA CLIENTES------------------------------------------------------------------------*/

--CREAR CLIENTE 
CREATE PROCEDURE sp_registrarcliente
(
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
AS
BEGIN
	SET @Resultado = 0
	DECLARE @IdPersona int

	IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Documento = @Documento)
	BEGIN
		INSERT INTO CLIENTE (Documento, NombreCompleto, Correo, Telefono, Estado) VALUES (@Documento, @NombreCompleto, @Correo, @Telefono, @Estado)

		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje ='El número de documento ya existe'
END

--MODIFICAR CLIENTE
CREATE PROCEDURE sp_modificarcliente
(
@IdCliente int,
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
AS 
BEGIN
	SET @Resultado = 1
	DECLARE @IdPersona int

	IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Documento = @Documento AND IdCliente != @IdCliente)
	BEGIN
		UPDATE CLIENTE SET
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		WHERE IdCliente = @IdCliente
	END
	ELSE
	BEGIN
		SET @Resultado = 0
		SET @Mensaje = 'El número de documento ya existe'
	END
END

-----------------------------------------------------------------------------------------------------------------------------------
/*----------------------------------PROCEDIMIENTOS PARA PROVEEDORES--------------------------------------------------------------*/

--REGISTRAR PROVEEDORES
CREATE PROCEDURE sp_registrarProveedor
(
@Documento varchar(50),
@RazonSocial varchar (50),
@Correo varchar(50),
@Telefono varchar (50),
@Estado bit, 
@Resultado int output,
@Mensaje varchar (500) output
)
AS
BEGIN
	SET @Resultado = 0
	DECLARE @IdPersona int

	IF NOT EXISTS (SELECT * FROM PROVEEDOR WHERE Documento = @Documento)
	BEGIN
		INSERT INTO PROVEEDOR (Documento,RazonSocial,Correo,Telefono,Estado) VALUES (@Documento,@RazonSocial,@Correo,@Telefono,@Estado)

		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje = 'El número de documento ya exixte'
END

--MODIFICAR PROVEEDORES
create PROCEDURE sp_midificarProveedor
(
@IdProveedor int,
@Documento varchar(50),
@RazonSocial varchar (50),
@Correo varchar(50),
@Telefono varchar (50),
@Estado bit, 
@Resultado int output,
@Mensaje varchar (500) output
)
AS 
BEGIN
	SET @Resultado = 1
	DECLARE @IdPersona int

	IF NOT EXISTS (SELECT * FROM PROVEEDOR WHERE Documento = @Documento AND IdProveedor!= @IdProveedor)
	BEGIN
		UPDATE PROVEEDOR SET
		Documento = @Documento,
		RazonSocial = @RazonSocial,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado 
		WHERE IdProveedor = @IdProveedor
	END
	ELSE
	BEGIN
		SET @Resultado = 0
		SET @Mensaje = 'El número de documento ya existe'
	END
END

--ELIMINAR PROVEEDORES
CREATE PROCEDURE sp_eliminarProveedor
(
@IdProveedor int,
@Resultado bit output,
@Mensaje varchar(500) output
)
AS
BEGIN
	SET @Resultado= 1
	IF NOT EXISTS (SELECT * FROM PROVEEDOR p INNER JOIN COMPRA c ON p.IdProveedor = c.IdProveedor WHERE p.IdProveedor = c.IdProveedor)
	BEGIN
		DELETE TOP (1) FROM PROVEEDOR WHERE IdProveedor = @IdProveedor
	END
	ELSE
	BEGIN
		SET @Resultado = 0
		SET @Mensaje = 'El proveedor se encuentra relacionado a una compra'
	END
END

----------------------------------------------------------------------------------------------------------------------------------------------------
/* PROCESO PARA REGISTRAR UNA COMPRA */

CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE
(
[IdProducto] int NULL,
[PrecioCompra] decimal(18,2) NULL,
[PrecioVenta] decimal(18,2) NULL,	
[Cantidad] int NULL,
[MontoTotal] decimal(18,2)NULL
)
 
CREATE PROCEDURE sp_RegistarCompra
(
@IdUsuario int,
@IdProveedor int,
@TipoDocumento varchar(500),
@NumeroDocumento varchar(500),
@MontoTotal decimal(18,2),
@DetalleCompra [EDetalle_Compra] READONLY,
@Resultado bit output,
@Mensaje varchar(500) output
)
AS
BEGIN
	BEGIN TRY
		DECLARE	 @IdCompra int = 0
		SET @Resultado = 1
		SET @Mensaje = ''
		
		BEGIN TRANSACTION Registro
			INSERT INTO COMPRA (IdUsuario,IdProveedor,TipoDocumento,NumeroDocumento, MontoTotal) 
			VALUES (@IdUsuario,@IdProveedor,@TipoDocumento,@NumeroDocumento,@MontoTotal)

			SET @IdCompra = SCOPE_IDENTITY()

			INSERT INTO DETALLE_COMPRA (IdCompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal)
			SELECT @IdCompra, IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal FROM @DetalleCompra

			UPDATE p SET p.Stock = p.Stock + dc.Cantidad,
			p.PrecioCompra = dc.PrecioCompra,
			p.PrecioVenta = dc.PrecioVenta
			FROM PRODUCTO p
			INNER JOIN @DetalleCompra dc ON dc.IdProducto = p.IdProducto

		COMMIT TRANSACTION Registro

	END TRY
	BEGIN CATCH
		SET @Resultado = 0
		SET @Mensaje = ERROR_MESSAGE()
		rollback transaction Registro
	END CATCH
END

----------------------------------------------------------------------------------------------------------------------------------------------------
/* PROCESO PARA REGISTRAR UNA VENTA */

CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE
(
[IdProducto] int NULL,
[PrecioVenta] decimal(18,2) NULL,	
[Cantidad] int NULL,
[SubTotal] decimal(18,2)NULL
)

CREATE PROCEDURE sp_RegistrarVenta
(
@IdUsuario int,
@TipoDocumento varchar (500),
@NumeroDocumento varchar (500),
@DocumentoCliente varchar (500),
@NombreCliente varchar (500),
@MontoPago decimal (18,2),
@MontoCambio decimal (18,2),
@MontoTotal decimal (18,2),
@DetalleVenta [EDetalle_Venta] READONLY,
@Resultado bit output,
@Mensaje varchar (500) output
)
AS
BEGIN
	BEGIN TRY
		DECLARE @IdVenta int = 0
		SET @Resultado = 1
		SET @Mensaje = ''
		
		BEGIN TRANSACTION registro

			INSERT INTO VENTA(IdUsuario,TipoDocumento,NumeroDocumento,DocumentoCliente,NombreCliente,MontoPago,MontoCambio,MontoTotal)
			VALUES (@IdUsuario,@TipoDocumento,@NumeroDocumento,@DocumentoCliente,@NombreCliente,@MontoPago,@MontoCambio,@MontoTotal)
			SET @IdVenta = SCOPE_IDENTITY()

			INSERT INTO DETALLE_VENTA (IdVenta,IdProducto,PrecioVenta,Cantidad,Subtotal)
			SELECT @IdVenta,IdProducto,PrecioVenta,Cantidad,Subtotal FROM @DetalleVenta

		COMMIT TRANSACTION registro
	END TRY

	BEGIN CATCH
		SET @Resultado = 0
		SET @Mensaje = ERROR_MESSAGE()
		ROLLBACK TRANSACTION registro
	END CATCH
END

----------------------------------------------------------------------------------------------------------------------------------------------------
/*-------------------------------------------PROCEDIMIENTOS PARA REPORTES-------------------------------------------------------------------------*/

--REPORTE COMPRAS
CREATE PROC sp_ReporteCompras(
@FechaInicio varchar(50),
@FechaFin varchar(50),
@IdProveedor int
)
AS
BEGIN
	SET DATEFORMAT dmy;

	SELECT CONVERT (char(50),c.FechaRegistro,103)[FechaRegistro],c.TipoDocumento,c.NumeroDocumento,c.MontoTotal,
		u.NombreCompleto[UsuarioRegistro],pr.Documento[DocumentoProveedor],pr.RazonSocial,
		p.Codigo[CodigoProducto],p.Nombre[NombreProducto],ca.Descripcion[Categoria],dc.PrecioCompra,dc.PrecioVenta,dc.Cantidad,dc.MontoTotal[SubTotal]

		FROM COMPRA c
		INNER JOIN USUARIO u on u.Idusuario = c.IdUsuario
		INNER JOIN PROVEEDOR pr on pr.IdProveedor = c.Idproveedor
		INNER JOIN DETALLE_COMPRA dc on dc.IdCompra = c.IdCompra
		INNER JOIN PRODUCTO p on p.IdProducto = dc.IdProducto
		INNER JOIN CATEGORIA ca on ca.IdCategoria = p.IdCategoria
		WHERE c.FechaRegistro BETWEEN CONVERT(datetime, @FechaInicio, 103) AND CONVERT(datetime, @FechaFin, 103)
        AND pr.IdProveedor = IIF(@IdProveedor = 0, pr.IdProveedor, @IdProveedor)        -- "iif" es una ternaria. Si @idproveedor == 0 devuelve pr.IdProveedor, sino 
																				        --  devuelve la variable @IdProveedor											
END

exec sp_ReporteCompras '01/08/2024' , '14/08/2024', 0 -- Ejecucion del procedimiento //EJEMPLO//



--REPORTE VENTAS
CREATE PROC sp_ReporteVentas(
@FechaInicio varchar(10),
@FechaFin varchar(10)
)
AS
BEGIN
	SET DATEFORMAT dmy;

	SELECT CONVERT (char(10),v.FechaRegistro,103)[FechaRegistro],v.TipoDocumento,v.NumeroDocumento,v.MontoTotal,
		u.NombreCompleto[UsuarioRegistro],v.DocumentoCliente,v.NombreCliente,
		p.Codigo[CodigoProducto],p.Nombre[NombreProducto],ca.Descripcion[Categoria],dv.PrecioVenta,dv.Cantidad,dv.Subtotal

		FROM VENTA v
		INNER JOIN USUARIO u on u.Idusuario = v.IdUsuario
		INNER JOIN DETALLE_VENTA dv on dv.IdVenta = v.IdVenta
		INNER JOIN PRODUCTO p on p.IdProducto = dv.IdProducto
		INNER JOIN CATEGORIA ca on ca.IdCategoria = p.IdCategoria
		WHERE CONVERT(date,v.FechaRegistro) BETWEEN @FechaInicio AND @FechaFin	
END

exec sp_ReporteVentas '01/08/2024' ,'15/10/2024' -- Ejecucion procedimiento