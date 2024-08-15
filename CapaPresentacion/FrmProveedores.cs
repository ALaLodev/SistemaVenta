﻿using CapaEntidad;
using CapaNegocio;
using CapaPresentacion.Utilidades;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CapaPresentacion
{
    public partial class FrmProveedores : Form
    {
        public FrmProveedores()
        {
            InitializeComponent();
        }

        private void FrmProveedores_Load(object sender, EventArgs e)
        {
            // => Recorre los roles en la BD y los muestra en el comboBox del formulario 
            cboEstado.Items.Add(new OpcionCombo() { Valor = 1, Texto = "Activo" });
            cboEstado.Items.Add(new OpcionCombo() { Valor = 0, Texto = "No Activo" });
            cboEstado.DisplayMember = "Texto";
            cboEstado.ValueMember = "Value";
            cboEstado.SelectedIndex = 0;

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


            //Mostrar todos los Proveedors
            List<Proveedor> listaProveedor = new CN_Proveedor().Listar();

            foreach (Proveedor item in listaProveedor)
            {
                dataGridViewData.Rows.Add(new object[]
                {
                    "",
                    item.IdProveedor,
                    item.Documento,
                    item.RazonSocial,
                    item.Correo,
                    item.Telefono,
                    item.Estado == true ? 1 : 0,
                    item.Estado == true ? "Activo" : "No Activo"
                });
            }
        }

        private void iconButton2_Click(object sender, EventArgs e)
        {
            string Mensaje = string.Empty;

            Proveedor obj_Proveedor = new Proveedor()
            {
                IdProveedor = Convert.ToInt32(txtId.Text),
                Documento = txtDocumento.Text,
                RazonSocial = txtRazonSocial.Text,
                Correo = txtCorreo.Text,
                Telefono = txtTelefono.Text,
                Estado = Convert.ToInt32(((OpcionCombo)cboEstado.SelectedItem).Valor) == 1 ? true : false
            };

            //Comprueba si anteriormente no hay un Proveedor. Si no lo hay lo crea y si lo hay actualiza los campos sin generar un nuevo id
            if (obj_Proveedor.IdProveedor == 0)
            {
                int IdProveedorGenerado = new CN_Proveedor().Registrar(obj_Proveedor, out Mensaje);

                //Muestar el Proveedor generado en el gridview
                if (IdProveedorGenerado != 0)
                {
                    dataGridViewData.Rows.Add(new object[] {"", IdProveedorGenerado, txtDocumento.Text, txtRazonSocial.Text, txtCorreo.Text, txtTelefono.Text,
                    ((OpcionCombo)cboEstado.SelectedItem).Valor.ToString(),
                    ((OpcionCombo)cboEstado.SelectedItem).Texto.ToString()
                });

                    Limpiar();
                }
                else
                {
                    MessageBox.Show(Mensaje);
                }
            }
            else
            {
                bool resultado = new CN_Proveedor().Editar(obj_Proveedor, out Mensaje);

                if (resultado)
                {
                    DataGridViewRow row = dataGridViewData.Rows[Convert.ToInt32(txtIndice.Text)];
                    row.Cells["Id"].Value = txtId.Text;
                    row.Cells["Documento"].Value = txtDocumento.Text;
                    row.Cells["RazonSocial"].Value = txtRazonSocial.Text;
                    row.Cells["Correo"].Value = txtCorreo.Text;
                    row.Cells["Telefono"].Value = txtTelefono.Text;
                    row.Cells["EstadoValor"].Value = ((OpcionCombo)cboEstado.SelectedItem).Valor.ToString();
                    row.Cells["Estado"].Value = ((OpcionCombo)cboEstado.SelectedItem).Texto.ToString();

                    Limpiar();
                }
                else
                {
                    MessageBox.Show(Mensaje);
                }
            }
        }
        private void Limpiar()
        {
            txtIndice.Text = "-";
            txtId.Text = "0";
            txtDocumento.Text = "";
            txtRazonSocial.Text = "";
            txtCorreo.Text = "";
            txtTelefono.Text = "";
            cboEstado.SelectedIndex = 0;

            txtDocumento.Select();
        }

        private void dataGridViewData_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {
            if (e.RowIndex < 0) return;

            if (e.ColumnIndex == 0)
            {
                e.Paint(e.CellBounds, DataGridViewPaintParts.All);

                var w = Properties.Resources.check_16.Width;
                var h = Properties.Resources.check_16.Height;
                var x = e.CellBounds.Left + (e.CellBounds.Width - w) / 2;
                var y = e.CellBounds.Top + (e.CellBounds.Height - h) / 2;

                e.Graphics.DrawImage(Properties.Resources.check_16, new Rectangle(x, y, w, h));
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
                    txtRazonSocial.Text = dataGridViewData.Rows[indice].Cells["RazonSocial"].Value.ToString();
                    txtCorreo.Text = dataGridViewData.Rows[indice].Cells["Correo"].Value.ToString();
                    txtTelefono.Text = dataGridViewData.Rows[indice].Cells["Telefono"].Value.ToString();

                    foreach (OpcionCombo oc in cboEstado.Items)
                    {
                        if (Convert.ToInt32(oc.Valor) == Convert.ToInt32(dataGridViewData.Rows[indice].Cells["EstadoValor"].Value))
                        {
                            cboEstado.SelectedIndex = cboEstado.Items.IndexOf(oc);
                            break;
                        }
                    }
                }
            }
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(txtId.Text) != 0)
            {
                if (MessageBox.Show("¿Desea eliminar el proveedor?", "Mensaje", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    string Mensaje = string.Empty;

                    Proveedor obj_Proveedor = new Proveedor()
                    {
                        IdProveedor = Convert.ToInt32(txtId.Text)
                    };

                    bool respuesta = new CN_Proveedor().Eliminar(obj_Proveedor, out Mensaje);

                    if (respuesta)
                    {
                        dataGridViewData.Rows.RemoveAt(Convert.ToInt32(txtIndice.Text));
                        Limpiar();
                    }
                    else
                    {
                        MessageBox.Show(Mensaje, "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }
                }
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            string columnaFiltro = ((OpcionCombo)cboBusqueda.SelectedItem).Valor.ToString();

            if (dataGridViewData.Rows.Count > 0)
            {
                foreach (DataGridViewRow row in dataGridViewData.Rows)
                {
                    if (row.Cells[columnaFiltro].Value.ToString().Trim().ToUpper().Contains(txtBusqueda.Text.Trim().ToUpper()))
                    {
                        row.Visible = true;
                    }
                    else
                    {
                        row.Visible = false;
                    }
                }
            }
        }

        private void btnLimpiarBuscador_Click(object sender, EventArgs e)
        {
            txtBusqueda.Text = "";

            foreach (DataGridViewRow row in dataGridViewData.Rows)
            {
                row.Visible = true;
            }
        }

        private void iconButton1_Click(object sender, EventArgs e)
        {
            Limpiar();
        }
    }
}
