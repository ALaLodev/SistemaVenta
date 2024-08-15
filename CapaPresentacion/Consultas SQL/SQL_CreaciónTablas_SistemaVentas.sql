create table ROL(
IdRol int primary key identity, 
Descripcion varchar (50),
FechaRegistro datetime default getdate()
)
go

create table PERMISO(
IdPermiso int primary key identity,
IdRol int references ROL (IdRol),
NombreMenu varchar (100),
FechaRegistro datetime default getdate()
)
go

create table PROVEEDOR(
IdProveedor int primary key identity,
Documento varchar(50),
RazonSocial varchar (50),
Correo varchar(50),
Telefono varchar(50),
Estado bit,
FechaRegistro datetime default getdate()
)
go

create table CLIENTE(
IdCliente int primary key identity,
Documento varchar(50),
NombreCompleto varchar (50),
Correo varchar(50),
Telefono varchar(50),
Estado bit,
FechaRegistro datetime default getdate()
)
go

create table USUARIO(
IdUsuario int primary key identity,
Documento varchar(50),
NombreCompleto varchar (50),
Correo varchar(50),
Clave varchar(50),
IdRol int references Rol(IdRol),
FechaRegistro datetime default getdate()
)
go

create table CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar(100),
Estado bit,
FechaRegistro datetime default getdate()
)
go

create table PRODUCTO(
IdProducto int primary key identity,
Codigo varchar(50),
Nombre varchar(100),
Descripcion varchar(500),
IdCategoria int references CATEGORIA(IdCategoria),
Stock int not null default 0,
PrecioCompra decimal (10,2) default 0,
PrecioVenta decimal (10,2) default 0,
Estado bit,
FechaRegistro datetime default getdate()
)
go

create table COMPRA(
IdCompra int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
IdProveedor int references PROVEEDOR(IdProveedor),
TipoDocumento varchar(50),
MontoTotal decimal(10,2),
FechaRegistro datetime default getdate()
)
go

create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity,
IdCompra int references COMPRA(IdCompra),
IdProducto int references PRODUCTO(IdProducto),
PrecioCompra decimal (10,2) default 0,
PrecioVenta decimal (10,2) default 0,
Cantidad int,
MontoTotal decimal(10,2),
FechaRegistro datetime default getdate()
)
go

create table VENTA(
IdVenta int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
TipoDocumento varchar(50),
NumeroDocumento varchar(50),
DocumentoCliente varchar(50),
NombreCliente varchar(100),
MontoPago decimal (10,2) default 0,
MontoCambio decimal (10,2) default 0,
MontoTotal decimal (10,2) default 0,
FechaRegistro datetime default getdate()
)
go

create table DETALLE_VENTA(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
PrecioVenta decimal (10,2),
Cantidad int,
Subtotal decimal(10,2),
FechaRegistro datetime default getdate()
)
go

create table NEGOCIO ( 
IdNegocio int primary key,
Nombre varchar(60),
NIF varchar(60),
Direccion varchar(60),
Logo varbinary(max) null
)

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------INSERTAR DATOS Y ROLES EN TABLAS----------------------------------------

 
insert into NEGOCIO(IdNegocio, Nombre,NIF,Direccion) values (1,'Proyecto Sistema de Ventas', 101010, 'av. prueba 123')

select IdNegocio,Nombre,NIF,Direccion from NEGOCIO where IdNegocio = 1

select Logo from NEGOCIO where IdNegocio = 1

select * from USUARIO

select * from PERMISO

select * FROM ROL

insert into PERMISO(IdRol, NombreMenu) values 
(1,'menuMantenedor'),
(1,'menuVentas'),
(1,'menuCompras'),
(1,'menuClientes'),
(1,'menuProveedores'),
(1,'menuReportes'),
(1,'menuAcercaDe')

insert into ROL (Descripcion) values ('EMPLEADO')

insert into PERMISO(IdRol, NombreMenu) values 
(2,'menuVentas'),
(2,'menuCompras'),
(2,'menuClientes'),
(2,'menuProveedores'),
(2,'menuAcercaDe')

insert into USUARIO (Documento, NombreCompleto, Correo, Clave, IdRol, Estado) values (20,'EMPLEADO', '@gmail.com', 222, 2, 1)

select p.IdRol, p.NombreMenu from PERMISO p
inner join ROL r on r.IdRol = p.IdRol
inner join USUARIO u on u.IdRol = r.IdRol
where u.IdUsuario = 3

