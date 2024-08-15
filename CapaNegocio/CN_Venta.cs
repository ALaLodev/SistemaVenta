using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Venta
    {
        private CD_Venta objcd_Venta = new CD_Venta();

        public bool RestarStock(int IdProducto, int Cantidad)
        {
            return objcd_Venta.RestarStock(IdProducto, Cantidad);
        }
        public bool SumarStock(int IdProducto, int Cantidad)
        {
            return objcd_Venta.SumarStock(IdProducto, Cantidad);
        }
        public int ObtenerCorrelativo()
        {
            return objcd_Venta.ObtenerCorrelativo();
        }
        public bool Registrar(Venta obj, DataTable Detalle_Venta, out string Mensaje)
        {
            return objcd_Venta.Registrar(obj, Detalle_Venta, out Mensaje);
        }

        public Venta ObtenerVenta(string Numero)
        {
            Venta oVenta = objcd_Venta.ObtenerVenta(Numero);

            if (oVenta.IdVenta != 0)
            {
                List<Detalle_Venta> oDetalleVenta = objcd_Venta.ObtenerDetalleVenta(oVenta.IdVenta);
                oVenta.oDetalle_Venta = oDetalleVenta;
            }
            return oVenta;
        }
    }
}
