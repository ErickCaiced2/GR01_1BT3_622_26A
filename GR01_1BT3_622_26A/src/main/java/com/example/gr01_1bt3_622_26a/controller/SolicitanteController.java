package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.validation.Valid;

import java.util.Optional;

@Controller
@RequestMapping("/solicitantes")
@RequiredArgsConstructor
public class SolicitanteController {

    private final SolicitanteService solicitanteService;

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

    @GetMapping("/{id}/eliminar")
    public String eliminarSolicitante(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        solicitanteService.eliminarSolicitante(id);
        redirectAttributes.addFlashAttribute("mensaje", "Solicitante eliminado");
        return "redirect:/";
    }
}

