package com.example.gr01_1bt3_622_26a.view;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Foto;
import java.util.List;

/**
 * Vista para renderizar el detalle de una mascota.
 */
public class DetalleMascotaView {

    private Mascota mascota;
    private List<Foto> fotos;

    /**
     * Carga los datos necesarios para la vista.
     */
    public void cargarDetalleMascota(Mascota mascota, List<Foto> fotos) {
        this.mascota = mascota;
        this.fotos = fotos;
    }

    /**
     * Renderiza el detalle de la mascota aplicando lógica para campos opcionales.
     * 
     * @return String con el detalle renderizado.
     */
    public String visualizarDetalleMascota() {
        if (mascota == null) {
            return "No hay datos de mascota para visualizar";
        }

        StringBuilder sb = new StringBuilder("Detalle de Mascota:\n");
        appendField(sb, "Nombre", mascota.getNombre());
        appendField(sb, "Especie", mascota.getTipo());
        appendField(sb, "Raza", mascota.getRaza());
        appendField(sb, "Edad", mascota.getEdad() + " años");
        appendField(sb, "Sexo", mascota.getGenero());
        appendField(sb, "Descripción", mascota.getDescripcion());
        appendField(sb, "Diagnósticos previos", formatDiagnosticos(mascota.getDiagnosticosPrevios()));
        
        sb.append("Fotografías: ").append(fotos != null ? fotos.size() : 0).append(" fotos cargadas");
        
        return sb.toString();
    }

    private void appendField(StringBuilder sb, String label, String value) {
        sb.append(label).append(": ").append(value).append("\n");
    }

    private String formatDiagnosticos(String diagnosticos) {
        if (diagnosticos == null || diagnosticos.trim().isEmpty()) {
            return "Sin diagnósticos previos";
        }
        return diagnosticos;
    }
}
