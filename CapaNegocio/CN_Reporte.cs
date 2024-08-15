using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Reporte
    {
        private CD_Reporte objcd_reporte = new CD_Reporte();

        public List<ReporteCompra> Compra(string FechaInicio, string FechaFin, int IdProveedor)
        {
            return objcd_reporte.Compra(FechaInicio, FechaFin, IdProveedor);
        }
        public List<ReporteVenta> Venta(string FechaInicio, string FechaFin)
        {
            return objcd_reporte.Venta(FechaInicio, FechaFin);
        }
    }
}
