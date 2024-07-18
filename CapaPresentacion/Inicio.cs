using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using CapaEntidad;
using CapaNegocio;

using FontAwesome.Sharp;

namespace CapaPresentacion
{
    public partial class Inicio : Form
    {
        private static Usuario usuarioActual;
        private static IconMenuItem menuActivo = null;
        private static Form formularioActivo = null;

        //Constructor del formulario; Muestra en el formulario el usuario que a iniciado sesion
        public Inicio(Usuario objusuario = null)
        {
            if (objusuario == null) 
                usuarioActual = new Usuario() { NombreCompleto = "ADMIN PREDEFINIDO", IdUsuario = 3 };
            else
                usuarioActual = objusuario;

            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //Obtiene los permisos del usuario que se acaba de registar 
            List<Permiso> ListaPermisos = new CN_Permiso().Listar(usuarioActual.IdUsuario);

            //Depende de los permisos que tenga el usuario registrado muestra un menú u otro
            foreach (IconMenuItem iconmenu in menu.Items)
            {
                bool encontrado = ListaPermisos.Any(m=> m.NombreMenu == iconmenu.Name);

                if (encontrado == false)
                {
                    iconmenu.Visible = false;
                }
            }

            lbUsuario.Text = usuarioActual.NombreCompleto;
        }

        private void AbrirFormulario(IconMenuItem menu, Form formulario) 
        {
            if (menuActivo != null) // Marcando el icono seleccionado cambiandolo de color 
            {
                menuActivo.BackColor = Color.White;
            }

            menu.BackColor = Color.Silver;
            menuActivo = menu;     //---------------------------------------------------

            if (formularioActivo != null) 
            {
                formularioActivo.Close();
            }

            //Configurando el formulario
            formularioActivo = formulario;
            formulario.TopLevel = false;
            formulario.FormBorderStyle = FormBorderStyle.None;
            formulario.Dock = DockStyle.Fill;
            formulario.BackColor = Color.SteelBlue;

            //Agregando el formulario al contenedor
            contenedor.Controls.Add(formulario);
            formulario.Show();

        }
        private void menuUsuarios_Click(object sender, EventArgs e)
        {
            AbrirFormulario((IconMenuItem)sender, new FrmUsuarios());
        }

        private void submenuCategoria_Click(object sender, EventArgs e)
        {
            AbrirFormulario(menuMantenedor, new FrmCategoria());
        }

        private void submenuProducto_Click(object sender, EventArgs e)
        {
            AbrirFormulario(menuMantenedor, new FrmProducto());
        }

        private void submenuRegistrarVenta_Click(object sender, EventArgs e)
        {
            AbrirFormulario(menuVentas, new FrmVentas());
        }
        private void submenuVerDetalleVenta_Click(object sender, EventArgs e)
        {
            AbrirFormulario(menuVentas, new FrmDetalleVenta());
        }
        private void submenuRegCompra_Click(object sender, EventArgs e)
        {
            AbrirFormulario(menuCompras, new FrmCompras());
        }
        private void submenuDetalleCompra_Click(object sender, EventArgs e)
        {
            AbrirFormulario(menuCompras, new FrmDetalleCompra());
        }
        private void menuClientes_Click(object sender, EventArgs e)
        {
            AbrirFormulario((IconMenuItem)sender, new FrmClientes());
        }
        private void iconMenuItem1_Click(object sender, EventArgs e)
        {
            AbrirFormulario((IconMenuItem)sender, new FrmProveedores());
        }
        private void menuReportes_Click(object sender, EventArgs e)
        {
            AbrirFormulario((IconMenuItem)sender, new FrmReportes());
        }
        private void label1_Click(object sender, EventArgs e)
        {

        }
        private void iconMenuItem4_Click(object sender, EventArgs e)
        {

        }

        

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void lbUsuario_Click(object sender, EventArgs e)
        {

        }

        private void menuMantenedor_Click(object sender, EventArgs e)
        {

        }

        private void menuCompras_Click(object sender, EventArgs e)
        {

        }

        private void menuTitulo_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }
    }
}
