

select c.IdCompra,u.NombreCompleto,pr.Documento,pr.RazonSocial,c.TipoDocumento,c.numerodocumento,c.MontoTotal,convert(char(10),c.FechaRegistro,103)[FechaRegistro]
from COMPRA c
inner join USUARIO u on u.IdUsuario = c.IdUsuario
inner join PROveedor pr on pr.IdProveedor = c.IdProveedor
where c.NumeroDocumento = '00001'

select p.Nombre,dc.PrecioCompra,dc.Cantidad,dc.MontoTotal
from DETALLE_COMPRA dc
inner join PRODUCTO p on p.IdProducto = dc.IdProducto
where dc.IdCompra = 1


select * from DETALLE_VENTA where IdVenta = 10
select* from VENTA where NumeroDocumento = '00010'

select v.IdVenta,u.NombreCompleto,
v.DocumentoCliente,v.NombreCliente,
v.TipoDocumento,v.NumeroDocumento,
v.MontoPago,v.MontoCambio,v.MontoTotal,convert(char(10),v.FechaRegistro,103)[FechaRegistro]
from VENTA v
inner join USUARIO u on u.IdUsuario = v.IdUsuario
where v.NumeroDocumento = '00010'


select p.Nombre,dv.PrecioVenta,dv.Cantidad,dv.Subtotal 
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
where dv.IdVenta = 10


select 
CONVERT (char(10),c.FechaRegistro,103)[FechaRegisto],c.TipoDocumento,c.NumeroDocumento,c.MontoTotal,
u.NombreCompleto[UsuarioRegistro],
pr.Documento[DocumentoProveedor],pr.RazonSocial,
p.Codigo[CodigoProducto],p.Nombre[NombreProducto],ca.Descripcion[Categoria],dc.PrecioCompra,dc.PrecioVenta,dc.Cantidad,dc.MontoTotal[SubTotal]
from COMPRA c
inner join USUARIO u on u.Idusuario = c.IdUsuario
inner join PROVEEDOR pr on pr.IdProveedor = c.Idproveedor
inner join DETALLE_COMPRA dc on dc.IdCompra = c.IdCompra
inner join PRODUCTO p on p.IdCategoria = p.IdCategoria
inner join CATEGORIA ca on ca.IdCategoria = p.IdCategoria
where CONVERT(date,c.FechaRegistro) between '06/08/2024' and '14/08/2024'
and pr.IdProveedor = 2