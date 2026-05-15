package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Usuario;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.UsuarioService;
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
    private final UsuarioService usuarioService;

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
     * Crea tanto un Usuario (credenciales) como un Solicitante (perfil)
     */
    @PostMapping("/crear")
    public String crearUsuario(@RequestParam String nombre,
                               @RequestParam String apellido,
                               @RequestParam String email,
                               @RequestParam String password,
                               @RequestParam String telefono,
                               @RequestParam(required = false) String direccion,
                               @RequestParam(required = false) String ciudad,
                               @RequestParam(required = false) String documentoIdentidad,
                               @RequestParam(required = false) String tipoDocumento,
                               RedirectAttributes redirectAttributes) {
        log.info("🔐 Creando nuevo usuario con email: {}", email);

        try {
            // Validar que el email no exista
            if (solicitanteService.solicitanteExistePorEmail(email)) {
                log.warn("⚠️ Intento de registro con email ya existente: {}", email);
                redirectAttributes.addFlashAttribute("error", "El email ya está registrado");
                return "redirect:/usuarios/registro";
            }

            // Validar que el documento no exista (HU2CA1)
            if (documentoIdentidad != null && !documentoIdentidad.isBlank()) {
                if (solicitanteService.obtenerPorDocumento(documentoIdentidad).isPresent()) {
                    log.warn("⚠️ Intento de registro con documento duplicado: {}", documentoIdentidad);
                    redirectAttributes.addFlashAttribute("error", "El documento de identidad ya existe");
                    return "redirect:/usuarios/registro";
                }
            }

            // 1️⃣ Crear Usuario (con credenciales)
            Usuario usuario = Usuario.builder()
                    .email(email)
                    .password(password) // Sin encriptación, en texto plano
                    .nombre(nombre + " " + apellido)
                    .rol(Usuario.RolUsuario.SOLICITANTE)
                    .estado("ACTIVO")
                    .documentoIdentidad(documentoIdentidad)
                    .build();

            Usuario usuarioCreado = usuarioService.guardarUsuario(usuario);
            log.info("✅ Usuario creado exitosamente con ID: {}", usuarioCreado.getId());

            // 2️⃣ Crear Solicitante (perfil)
            Solicitante solicitante = new Solicitante();
            solicitante.setNombre(nombre);
            solicitante.setApellido(apellido != null ? apellido : "");
            solicitante.setEmail(email);
            solicitante.setTelefono(telefono);
            solicitante.setDireccion(direccion);
            solicitante.setCiudad(ciudad);
            solicitante.setDocumentoIdentidad(documentoIdentidad);
            solicitante.setTipoDocumento(tipoDocumento);

            Solicitante solicitanteCreado = solicitanteService.crearSolicitante(solicitante);
            log.info("✅ Solicitante creado exitosamente con ID: {}", solicitanteCreado.getId());

            // Redirigir a login con mensaje de éxito
            redirectAttributes.addFlashAttribute("mensaje",
                    "¡Registro exitoso! Por favor, inicia sesión con tus credenciales.");
            return "redirect:/login";

        } catch (Exception e) {
            log.error("❌ Error al crear usuario: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Error al registrarse: " + e.getMessage());
            return "redirect:/usuarios/registro";
        }
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

