using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using CapaPresentacion.Utilidades;

using CapaEntidad;
using CapaNegocio;

namespace CapaPresentacion
{
    public partial class FrmUsuarios : Form
    {
        public FrmUsuarios()
        {
            InitializeComponent();
        }
        private void FrmUsuarios_Load(object sender, EventArgs e)
        {
            // => Recorre los roles en la BD y los muestra en el comboBox del formulario 
            cboEstado.Items.Add(new OpcionCombo() { Valor = 1, Texto = "Activo"});
            cboEstado.Items.Add(new OpcionCombo() { Valor = 0, Texto = "No Activo" });
            cboEstado.DisplayMember = "Texto";
            cboEstado.ValueMember = "Value";
            cboEstado.SelectedIndex = 0;

            List<Rol> listaRol = new CN_Rol().Listar();

            foreach (Rol item in listaRol) 
            {
                cboRol.Items.Add(new OpcionCombo() { Valor = item.IdRol, Texto = item.Descripcion });
            }
            cboRol.DisplayMember = "Texto";
            cboRol.ValueMember = "Value";
            cboRol.SelectedIndex = 0;
            // <=-------------------------------------------------------------------------

            // Muestra  las columnas de GridView en el menu de búsqueda
            foreach (DataGridViewColumn columna in dataGridViewData.Columns)
            {
                if (columna.Visible == true && columna.Name != "btnSeleccionar")
                {
                    cboBusqueda.Items.Add(new OpcionCombo() { Valor = columna.Name, Texto = columna.HeaderText });
                }
            }
            cboBusqueda.DisplayMember = "Texto";
            cboBusqueda.ValueMember = "Value";
            cboBusqueda.SelectedIndex = 0;


            //Mostrar todos los usuarios
            List<Usuario> listaUsuario = new CN_Usuario().Listar();

            foreach (Usuario item in listaUsuario)
            {
                dataGridViewData.Rows.Add(new object[] {"", item.IdUsuario, item.Documento, item.NombreCompleto, item.Correo, item.Clave,
                    item.Ob_Rol.IdRol, item.Ob_Rol.Descripcion, item.Estado == true ? 1 : 0, item.Estado == true ? "Activo" : "No Activo"
                });
            }

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click_1(object sender, EventArgs e)
        {

        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
          //  dataGridViewData.Rows.Add(new object[] {"", txtId.Text, txtDocumento.Text, txtNombreCompleto.Text, txtCorreo.Text, txtClave.Text, 
          //     ((OpcionCombo)cboRol.SelectedItem).Valor.ToString(),
          //     ((OpcionCombo)cboRol.SelectedItem).Texto.ToString(),
          //     ((OpcionCombo)cboEstado.SelectedItem).Valor.ToString(),
          //     ((OpcionCombo)cboEstado.SelectedItem).Texto.ToString()
          // });

          //  Limpiar();
        }

        private void Limpiar()
        {
            txtIndice.Text = "-";
            txtId.Text = "0";
            txtDocumento.Text = "";
            txtNombreCompleto.Text = "";
            txtCorreo.Text = "";
            txtClave.Text = "";
            txtConfirmarClave.Text = "";
            cboRol.SelectedIndex = 0;
            cboEstado.SelectedIndex = 0;
        }

        private void label9_Click(object sender, EventArgs e)
        {

        }

        private void txtBusqueda_TextChanged(object sender, EventArgs e)
        {

        }
        private void dataGridViewData_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {
            if (e.RowIndex < 0) return;

            if (e.ColumnIndex == 0) 
            {
                e.Paint(e.CellBounds, DataGridViewPaintParts.All);

                var w = Properties.Resources.emblemdefault_103452.Width;
                var h = Properties.Resources.emblemdefault_103452.Height;
                var x = e.CellBounds.Left + (e.CellBounds.Width - w) / 2;
                var y = e.CellBounds.Top + (e.CellBounds.Height - h) / 2;

                e.Graphics.DrawImage(Properties.Resources.emblemdefault_103452, new Rectangle(x, y, w, h)) ;
                e.Handled = true;
            }
        }
        private void dataGridViewData_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (dataGridViewData.Columns[e.ColumnIndex].Name == "btnSeleccionar")
            {
                int indice = e.RowIndex;

                if (indice >= 0)
                {
                    txtIndice.Text = indice.ToString();


                    txtId.Text = dataGridViewData.Rows[indice].Cells["Id"].Value.ToString();
                    txtDocumento.Text = dataGridViewData.Rows[indice].Cells["Documento"].Value.ToString();
                    txtNombreCompleto.Text = dataGridViewData.Rows[indice].Cells["NombreCompleto"].Value.ToString();
                    txtCorreo.Text = dataGridViewData.Rows[indice].Cells["Correo"].Value.ToString();
                    txtClave.Text = dataGridViewData.Rows[indice].Cells["Clave"].Value.ToString();
                    txtConfirmarClave.Text = dataGridViewData.Rows[indice].Cells["Clave"].Value.ToString();

                    foreach (OpcionCombo oc in cboRol.Items)
                    {
                        if (Convert.ToInt32(oc.Valor) == Convert.ToInt32(dataGridViewData.Rows[indice].Cells["IdRol"].Value))
                        {
                            int indice_combo = cboRol.Items.IndexOf(oc);
                            cboRol.SelectedIndex = indice_combo;
                            break;
                        }
                    }

                    foreach (OpcionCombo oc in cboEstado.Items)
                    {
                        if (Convert.ToInt32(oc.Valor) == Convert.ToInt32(dataGridViewData.Rows[indice].Cells["EstadoValor"].Value))
                        {
                            int indice_combo = cboEstado.Items.IndexOf(oc);
                            cboEstado.SelectedIndex = indice_combo;
                            break;
                        }
                    }
                }
            }
        }
    }
}
