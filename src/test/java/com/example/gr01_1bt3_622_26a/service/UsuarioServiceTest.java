package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Usuario;
import com.example.gr01_1bt3_622_26a.repository.UsuarioRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * TDD - CICLOS COMPLETADOS
 *
 * TEST 1: ✅ Crear Usuario (COMPLETADO: RED → GREEN → REFACTOR)
 * TEST 2: ✅ Registrar Usuario en BD (COMPLETADO: RED → GREEN → REFACTOR)
 * TEST 3: 🔴 Iniciar Sesión (INICIANDO: RED PHASE)
 *
 * Caso de Uso: Autenticación de Usuarios
 * Descripción: Validar credenciales y permitir login
 */
@DisplayName("TDD - Ciclo Completo: Usuario (RED → GREEN → REFACTOR)")
@ExtendWith(MockitoExtension.class)
public class UsuarioServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @InjectMocks
    private UsuarioService usuarioService;

    /**
     * ✅ TC1: Crear Usuario Exitosamente (Ya implementado)
     */
    @Test
    @DisplayName("TC1: Crear Usuario Exitosamente")
    void testCrearUsuario() {
        // ARRANGE
        String email = "juan@example.com";
        String password = "password123";
        String nombre = "Juan Pérez";

        // ACT
        Usuario usuario = Usuario.builder()
                .email(email)
                .password(password)
                .nombre(nombre)
                .estado("ACTIVO")
                .build();

        // ASSERT
        assertNotNull(usuario, "El usuario no debe ser nulo");
        assertEquals(email, usuario.getEmail(), "El email debe coincidir");
        assertEquals(password, usuario.getPassword(), "La contraseña debe coincidir");
        assertEquals(nombre, usuario.getNombre(), "El nombre debe coincidir");
        assertEquals("ACTIVO", usuario.getEstado(), "El estado debe ser ACTIVO");
    }

    /**
     * 🔴 RED: TC2 - Registrar Usuario en BD
     *
     * Este test FALLA porque:
     * - No existe UsuarioService
     * - No existe método registrarUsuario()
     * - No existe UsuarioRepository
     */
    @Test
    @DisplayName("TC2: Registrar Usuario en BD Exitosamente")
    void testRegistrarUsuarioEnBD() {
        // ARRANGE - Preparar datos
        String email = "carlos@example.com";
        String password = "password456";
        String nombre = "Carlos López";

        Usuario usuarioAGuardar = Usuario.builder()
                .email(email)
                .password(password)
                .nombre(nombre)
                .estado("ACTIVO")
                .build();

        // Mock: Simular que el repositorio guarda y retorna con ID
        Usuario usuarioGuardado = Usuario.builder()
                .id(1L)
                .email(email)
                .password(password)
                .nombre(nombre)
                .estado("ACTIVO")
                .build();

        when(usuarioRepository.save(any(Usuario.class))).thenReturn(usuarioGuardado);

        // ACT - Registrar usuario
        Usuario resultado = usuarioService.registrarUsuario(email, password, nombre);

        // ASSERT - Verificaciones
        assertNotNull(resultado, "El usuario registrado no debe ser nulo");
        assertEquals(email, resultado.getEmail(), "El email debe coincidir");
        assertEquals(nombre, resultado.getNombre(), "El nombre debe coincidir");
    }

    /**
     * 🔴 RED: TC3 - Iniciar Sesión
     *
     * Este test FALLA porque:
     * - No existe el método iniciarSesion() en UsuarioService
     * - No existe validación de contraseña
     */
    @Test
    @DisplayName("TC3: Iniciar Sesión Exitosamente")
    void testIniciarSesionExitoso() {
        // ARRANGE - Preparar datos
        String email = "juan@example.com";
        String password = "password123";

        Usuario usuarioEnBD = Usuario.builder()
                .id(1L)
                .email(email)
                .password(password)
                .nombre("Juan Pérez")
                .estado("ACTIVO")
                .rol(Usuario.RolUsuario.SOLICITANTE)
                .build();

        when(usuarioRepository.findByEmail(email)).thenReturn(java.util.Optional.of(usuarioEnBD));

        // ACT - Iniciar sesión (ESTO FALLA: método no existe)
        Usuario resultado = usuarioService.iniciarSesion(email, password);

        // ASSERT - Verificaciones
        assertNotNull(resultado, "El usuario no debe ser nulo");
        assertEquals(email, resultado.getEmail(), "El email debe coincidir");
        assertEquals(1L, resultado.getId(), "El ID debe coincidir");
    }

    /**
     * 🔴 RED: TC4 - Cerrar Sesión
     *
     * Este test FALLA porque:
     * - No existe el método cerrarSesion() en UsuarioService
     * - No existe lógica de logout
     */
    @Test
    @DisplayName("TC4: Cerrar Sesión Exitosamente")
    void testCerrarSesionExitoso() {
        // ARRANGE - Preparar datos
        Long usuarioId = 1L;

        Usuario usuarioActivo = Usuario.builder()
                .id(usuarioId)
                .email("juan@example.com")
                .password("password123")
                .nombre("Juan Pérez")
                .estado("ACTIVO")
                .rol(Usuario.RolUsuario.SOLICITANTE)
                .fechaUltimoLogin(java.time.LocalDateTime.now())
                .build();

        when(usuarioRepository.findById(usuarioId)).thenReturn(java.util.Optional.of(usuarioActivo));

        // ACT - Cerrar sesión (ESTO FALLA: método no existe)
        boolean resultado = usuarioService.cerrarSesion(usuarioId);

        // ASSERT - Verificaciones
        assertTrue(resultado, "El logout debe retornar true");
        assertNull(usuarioActivo.getFechaUltimoLogin(), "La fecha de último login debe limpiarse");
    }
}
