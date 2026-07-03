package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.dto.ContratoDTO;
import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.repository.AdopcionRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import com.example.gr01_1bt3_622_26a.service.mapper.AdopcionContratoMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.time.LocalDate;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * 🧪 Tests unitarios para ContratoService
 *
 * Valida que ambos caminos de generación de contrato (desde Adopcion y desde
 * Solicitud) usan la plantilla Thymeleaf a través del AdopcionContratoMapper,
 * en lugar de construir HTML manualmente.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("ContratoService - Tests unitarios")
class ContratoServiceTest {

    @Mock
    private AdopcionRepository adopcionRepository;

    @Mock
    private SolicitudRepository solicitudRepository;

    @Mock
    private TemplateEngine templateEngine;

    @Mock
    private AdopcionContratoMapper adopcionContratoMapper;

    @InjectMocks
    private ContratoService contratoService;

    @Test
    @DisplayName("generarContratoPDFDesdeSolicitud usa el mapper y la plantilla Thymeleaf de contrato")
    void generarContratoPDFDesdeSolicitudUsaMapperYPlantillaThymeleaf() {
        Solicitud solicitud = crearSolicitudAprobada();
        ContratoDTO contratoDTO = crearContratoDTO();

        when(solicitudRepository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(adopcionContratoMapper.toContratoDTODesdeSolicitud(solicitud)).thenReturn(contratoDTO);
        when(templateEngine.process(eq("contratos/contrato-adopcion-template"), any(Context.class)))
                .thenReturn("<html><body>Contrato de prueba</body></html>");

        byte[] pdf = contratoService.generarContratoPDFDesdeSolicitud(1L);

        assertNotNull(pdf, "El PDF generado no debe ser nulo");
        assertTrue(pdf.length > 0, "El PDF generado no debe estar vacío");

        verify(adopcionContratoMapper).toContratoDTODesdeSolicitud(solicitud);

        ArgumentCaptor<Context> contextCaptor = ArgumentCaptor.forClass(Context.class);
        verify(templateEngine).process(eq("contratos/contrato-adopcion-template"), contextCaptor.capture());
        Context contextoUsado = contextCaptor.getValue();
        assertEquals("Max", contextoUsado.getVariable("nombreMascota"));
        assertEquals("Juan Pérez", contextoUsado.getVariable("nombreAdoptante"));
    }

    @Test
    @DisplayName("generarContratoPDF (desde Adopcion) usa el mapper y la plantilla Thymeleaf de contrato")
    void generarContratoPDFUsaMapperYPlantillaThymeleaf() {
        Adopcion adopcion = Adopcion.builder().id(1L).build();
        ContratoDTO contratoDTO = crearContratoDTO();

        when(adopcionRepository.findById(1L)).thenReturn(Optional.of(adopcion));
        when(adopcionContratoMapper.toContratoDTO(adopcion)).thenReturn(contratoDTO);
        when(templateEngine.process(eq("contratos/contrato-adopcion-template"), any(Context.class)))
                .thenReturn("<html><body>Contrato de prueba</body></html>");

        byte[] pdf = contratoService.generarContratoPDF(1L);

        assertNotNull(pdf);
        assertTrue(pdf.length > 0);
        verify(adopcionContratoMapper).toContratoDTO(adopcion);
        verify(templateEngine).process(eq("contratos/contrato-adopcion-template"), any(Context.class));
    }

    @Test
    @DisplayName("generarContratoPDFDesdeSolicitud lanza excepción si la solicitud no existe")
    void generarContratoPDFDesdeSolicitudLanzaExcepcionSiNoExiste() {
        when(solicitudRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> contratoService.generarContratoPDFDesdeSolicitud(99L));
        verifyNoInteractions(adopcionContratoMapper, templateEngine);
    }

    private Solicitud crearSolicitudAprobada() {
        Solicitante solicitante = Solicitante.builder()
                .id(1L)
                .nombre("Juan")
                .apellido("Pérez")
                .email("juan@example.com")
                .telefono("0999999999")
                .documentoIdentidad("123456789")
                .build();

        Mascota mascota = Mascota.builder()
                .id(1L)
                .nombre("Max")
                .tipo("Perro")
                .raza("Labrador")
                .edad(3)
                .genero("Macho")
                .estado("Adoptado")
                .build();

        return Solicitud.builder()
                .id(1L)
                .solicitante(solicitante)
                .mascota(mascota)
                .estado("Aprobada")
                .build();
    }

    private ContratoDTO crearContratoDTO() {
        return ContratoDTO.builder()
                .adopcionId(1L)
                .nombreRefugio("Paws & Home Sanctuary")
                .representanteLegal("Administración Refugio")
                .nombreAdoptante("Juan Pérez")
                .cedulaAdoptante("123456789")
                .emailAdoptante("juan@example.com")
                .telefonoAdoptante("0999999999")
                .nombreMascota("Max")
                .tipoMascota("Perro")
                .razaMascota("Labrador")
                .edadMascota(3)
                .descripcionMascota("Juguetón")
                .colorMascota("Café")
                .vacunasMascota("Vacunación desde solicitud registrada")
                .fechaGeneracion(LocalDate.now())
                .numeroContrato("CONTRATO-SOL-1-123456")
                .build();
    }
}
