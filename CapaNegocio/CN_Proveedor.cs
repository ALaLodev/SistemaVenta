using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Proveedor
    {
        private CD_Proveedor objcd_Proveedor = new CD_Proveedor();
        public List<Proveedor> Listar()
        {
            return objcd_Proveedor.Listar();
        }
        public int Registrar(Proveedor obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (obj.Documento == "")
            {
                Mensaje += "Introduzca número de Documento\n";
            }
            if (obj.RazonSocial == "")
            {
                Mensaje += "Introduzca la razon social del Proveedor\n";
            }
            if (obj.Correo == "")
            {
                Mensaje += "Introduzca el Correo\n";
            }
            if (obj.Telefono == "")
            {
                Mensaje += "Introduzca el Teléfono\n";
            }
            if (Mensaje != string.Empty)
            {
                return 0;
            }
            else
            {
                return objcd_Proveedor.Registrar(obj, out Mensaje);
            }

        }
        public bool Editar(Proveedor obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (obj.Documento == "")
            {
                Mensaje += "Introduzca número de Documento\n";
            }
            if (obj.RazonSocial == "")
            {
                Mensaje += "Introduzca la RazonSocial del Proveedor\n";
            }
            if (obj.Correo == "")
            {
                Mensaje += "Introduzca el Correo\n";
            }
            if (obj.Telefono == "")
            {
                Mensaje += "Introduzca el Teléfono\n";
            }
            if (Mensaje != string.Empty)
            {
                return false;
            }
            else
            {
                return objcd_Proveedor.Editar(obj, out Mensaje);
            }


        }
        public bool Eliminar(Proveedor obj, out string Mensaje)
        {
            return objcd_Proveedor.Eliminar(obj, out Mensaje);
        }
    }
}
