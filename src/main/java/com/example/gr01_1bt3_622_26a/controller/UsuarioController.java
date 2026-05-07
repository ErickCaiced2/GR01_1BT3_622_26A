package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * Controlador para registro y perfil de usuarios del sistema
 */
@Controller
@RequestMapping("/usuarios")
@RequiredArgsConstructor
@Slf4j
public class UsuarioController {

    private final SolicitanteService solicitanteService;

    /**
     * Mostrar formulario de registro de usuario
     */
    @GetMapping("/registro")
    public String mostrarFormularioRegistro(Model model) {
        log.info("Mostrando formulario de registro de usuario");
        model.addAttribute("solicitante", new Solicitante());
        return "usuarios/formularioRegistro";
    }

    /**
     * Crear usuario a partir del formulario de registro
     * Los datos del formulario coinciden con la entidad Solicitante
     */
    @PostMapping("/crear")
    public String crearUsuario(@RequestParam String nombre,
                               @RequestParam String apellido,
                               @RequestParam String email,
                               @RequestParam String telefono,
                               @RequestParam(required = false) String direccion,
                               @RequestParam(required = false) String ciudad,
                               @RequestParam(required = false) String documentoIdentidad,
                               @RequestParam(required = false) String tipoDocumento,
                               @RequestParam(required = false) String fechaNacimiento,
                               RedirectAttributes redirectAttributes) {
        log.info("Creando nuevo usuario con email: {}", email);

        if (solicitanteService.solicitanteExistePorEmail(email)) {
            redirectAttributes.addFlashAttribute("error", "El email ya está registrado");
            return "redirect:/usuarios/registro";
        }

        Solicitante solicitante = new Solicitante();
        solicitante.setNombre(nombre);
        solicitante.setApellido(apellido != null ? apellido : "");
        solicitante.setEmail(email);
        solicitante.setTelefono(telefono);
        solicitante.setDireccion(direccion);
        solicitante.setCiudad(ciudad);
        solicitante.setDocumentoIdentidad(documentoIdentidad);
        solicitante.setTipoDocumento(tipoDocumento);

        Solicitante creado = solicitanteService.crearSolicitante(solicitante);
        redirectAttributes.addFlashAttribute("mensaje", "¡Registro exitoso! Bienvenido " + nombre);
        return "redirect:/usuarios/" + creado.getId();
    }

    /**
     * Ver perfil de usuario
     */
    @GetMapping("/{id}")
    public String verPerfil(@PathVariable Long id, Model model) {
        log.info("Mostrando perfil de usuario con ID: {}", id);
        Optional<Solicitante> solicitante = solicitanteService.obtenerPorId(id);
        if (solicitante.isPresent()) {
            model.addAttribute("usuario", solicitante.get());
            return "usuarios/perfilUsuario";
        }
        return "redirect:/";
    }

    /**
     * Editar usuario — redirige al formulario de edición de solicitante
     */
    @GetMapping("/{id}/editar")
    public String editarUsuario(@PathVariable Long id) {
        return "redirect:/solicitantes/" + id + "/editar";
    }
}

