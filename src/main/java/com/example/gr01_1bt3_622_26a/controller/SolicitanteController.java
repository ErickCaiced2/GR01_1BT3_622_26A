package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.DocumentoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.validation.Valid;
import jakarta.servlet.http.HttpSession;

import java.util.Optional;

@Controller
@RequestMapping("/solicitantes")
@RequiredArgsConstructor
@Slf4j
public class SolicitanteController {

    private final SolicitanteService solicitanteService;
    private final DocumentoService documentoService;

    @GetMapping("/registro")
    public String mostrarFormularioRegistro(Model model) {
        model.addAttribute("solicitante", new Solicitante());
        return "solicitantes/formularioRegistro";
    }

    @PostMapping("/registrar")
    public String registrarSolicitante(@Valid @ModelAttribute Solicitante solicitante,
                                      BindingResult bindingResult,
                                      RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            return "solicitantes/formularioRegistro";
        }

        if (solicitanteService.solicitanteExistePorEmail(solicitante.getEmail())) {
            redirectAttributes.addFlashAttribute("error", "El email ya está registrado");
            return "redirect:/solicitantes/registro";
        }

        if (solicitanteService.obtenerPorDocumento(solicitante.getDocumentoIdentidad()).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "El documento de identidad ya existe");
            return "redirect:/solicitantes/registro";
        }

        Solicitante solicitanteRegistrado = solicitanteService.crearSolicitante(solicitante);
        redirectAttributes.addFlashAttribute("mensaje", "¡Registro exitoso! Bienvenido " + solicitante.getNombre());
        return "redirect:/solicitantes/" + solicitanteRegistrado.getId();
    }

    @GetMapping("/{id}")
    public String verPerfil(@PathVariable Long id, Model model) {
        Optional<Solicitante> solicitante = solicitanteService.obtenerPorId(id);
        if (solicitante.isPresent()) {
            model.addAttribute("solicitante", solicitante.get());
            return "solicitantes/perfilSolicitante";
        }
        return "redirect:/";
    }

    @GetMapping("/{id}/editar")
    public String mostrarFormularioEditar(@PathVariable Long id, Model model) {
        Optional<Solicitante> solicitante = solicitanteService.obtenerPorId(id);
        if (solicitante.isPresent()) {
            model.addAttribute("solicitante", solicitante.get());
            return "solicitantes/formularioEditar";
        }
        return "redirect:/";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizarSolicitante(@PathVariable Long id,
                                       @Valid @ModelAttribute Solicitante solicitante,
                                       BindingResult bindingResult,
                                       RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            return "solicitantes/formularioEditar";
        }

        solicitante.setId(id);
        solicitanteService.actualizarSolicitante(solicitante);
        redirectAttributes.addFlashAttribute("mensaje", "Datos actualizados exitosamente");
        return "redirect:/solicitantes/" + id;
    }

    /**
     * T.2.5 - Mostrar página de carga de documentos
     *
     * Permite al solicitante autenticado acceder a la interfaz
     * de subida de documentos requeridos para validación.
     *
     * Protección: Solo el solicitante propietario puede acceder
     */
    @GetMapping("/{id}/documentos")
    public String mostrarVistaDocumentos(
            @PathVariable Long id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Obtener ID del solicitante desde sesión
        Long solicitanteIdSesion = (Long) session.getAttribute("solicitanteId");

        // Validar que el solicitante solo pueda ver sus propios documentos
        if (solicitanteIdSesion == null || !solicitanteIdSesion.equals(id)) {
            log.warn("Intento de acceso no autorizado a documentos del solicitante {}", id);
            redirectAttributes.addFlashAttribute("error", "No tienes permiso para acceder a estos documentos");
            return "redirect:/";
        }

        log.info("Accediendo a vista de documentos para solicitante {}", id);

        Optional<Solicitante> solicitante = solicitanteService.obtenerPorId(id);
        if (solicitante.isEmpty()) {
            log.warn("Solicitante {} no encontrado", id);
            redirectAttributes.addFlashAttribute("error", "Solicitante no encontrado");
            return "redirect:/";
        }

        model.addAttribute("solicitante", solicitante.get());
        model.addAttribute("solicitanteId", id);
        return "solicitantes/subir-documentos";
    }

    @GetMapping("/{id}/eliminar")
    public String eliminarSolicitante(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        solicitanteService.eliminarSolicitante(id);
        redirectAttributes.addFlashAttribute("mensaje", "Solicitante eliminado");
        return "redirect:/";
    }
}

