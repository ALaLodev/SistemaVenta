using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidad
{
    public class Compra
    {
        public int IdCompra { get; set; }
        public Usuario Ob_Usuario { get; set; }
        public Proveedor Ob_Proveedor { get; set; }
        public string TipoDocumento { get; set; }
        public string NumDocumento { get; set; }
        public decimal MontoTotal { get; set; }
        public List<Detalle_Compra> Ob_Detalle_Compra { get; set; }
        public string FechaRegistro { get; set; }
    }
}
