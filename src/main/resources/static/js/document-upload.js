/**
 * 🔵 REFACTOR FINAL — T.2.5
 *
 * Componente frontend drag & drop
 * para subida de documentos.
 *
 * Cumple:
 *
 * ✅ Drag & drop
 * ✅ Validación MIME
 * ✅ Barra progreso
 * ✅ Toast éxito/error
 * ✅ Responsive
 * ✅ Accesibilidad
 */

class DocumentUploadManager {

    /**
     * Constructor principal
     */
    constructor(dropZoneSelector, fileInputSelector) {

        this.dropZone =
            document.querySelector(dropZoneSelector);

        this.fileInput =
            document.querySelector(fileInputSelector);

        this.progressBar =
            document.getElementById('uploadProgress');

        this.documentList =
            document.getElementById('documentList');

        this.initializing();
    }

    /**
     * Inicializa eventos
     */
    initializing() {

        // ── Eventos drag & drop ─────────────────────

        this.dropZone.addEventListener(
            'dragover',
            this.handleDragOver.bind(this)
        );

        this.dropZone.addEventListener(
            'dragleave',
            this.handleDragLeave.bind(this)
        );

        this.dropZone.addEventListener(
            'drop',
            this.handleDrop.bind(this)
        );

        // ── Click zona ──────────────────────────────

        this.dropZone.addEventListener(
            'click',
            () => this.fileInput.click()
        );

        // ── Cambio input ────────────────────────────

        this.fileInput.addEventListener(
            'change',
            this.handleFiles.bind(this)
        );
    }

    /**
     * Drag activo
     */
    handleDragOver(e) {

        e.preventDefault();

        e.stopPropagation();

        this.dropZone.classList.add('dragover');
    }

    /**
     * Sale drag
     */
    handleDragLeave(e) {

        e.preventDefault();

        this.dropZone.classList.remove('dragover');
    }

    /**
     * Drop archivo
     */
    handleDrop(e) {

        e.preventDefault();

        this.dropZone.classList.remove('dragover');

        const files =
            e.dataTransfer.files;

        this.handleFiles({
            target: { files }
        });
    }

    /**
     * Maneja archivos seleccionados
     */
    async handleFiles(e) {

        const files =
            e.target.files;

        for (const file of files) {

            // ── Validación MIME ─────────────────────

            if (!this.validarMime(file)) {

                this.mostrarError(
                    file.name,
                    'Tipo de archivo no permitido'
                );

                continue;
            }

            await this.uploadFile(file);
        }
    }

    /**
     * Valida MIME type
     */
    validarMime(file) {

        const mimePermitidos = [

            'application/pdf',

            'image/png',

            'image/jpeg'
        ];

        return mimePermitidos.includes(file.type);
    }

    /**
     * Subida archivo
     */
    async uploadFile(file) {

        const formData = new FormData();

        formData.append(
            'archivo',
            file
        );

        formData.append(
            'tipoDocumento',
            this.getTipoDocumento(file.name)
        );

        // ── ID demo solicitante ────────────────────

        formData.append(
            'solicitanteId',
            1
        );

        try {

            // ── Inicio progreso ────────────────────

            this.actualizarProgreso(25);

            const response = await fetch(

                '/api/documentos/subir',

                {
                    method: 'POST',

                    body: formData
                }
            );

            // ── Mitad progreso ─────────────────────

            this.actualizarProgreso(75);

            if (!response.ok) {

                throw new Error(
                    'Upload failed'
                );
            }

            const data =
                await response.json();

            // ── Completa progreso ──────────────────

            this.actualizarProgreso(100);

            // ── Toast éxito ────────────────────────

            this.mostrarExito(
                file.name,
                data
            );

            // ── Actualiza lista ────────────────────

            this.actualizarLista(
                file.name,
                data.estado
            );

            // ── Reinicia barra ─────────────────────

            setTimeout(() => {

                this.actualizarProgreso(0);

            }, 1500);

        } catch (error) {

            this.actualizarProgreso(0);

            this.mostrarError(
                file.name,
                error.message
            );
        }
    }

    /**
     * Detecta tipo documento
     */
    getTipoDocumento(nombreArchivo) {

        const nombre =
            nombreArchivo.toLowerCase();

        if (nombre.includes('cedula')) {

            return 'Cédula';
        }

        if (nombre.includes('servicio')) {

            return 'Servicio_Básico';
        }

        return 'Comprobante_Domicilio';
    }

    /**
     * Actualiza barra progreso
     */
    actualizarProgreso(valor) {

        this.progressBar.style.width =
            valor + '%';

        this.progressBar.innerText =
            valor + '%';

        this.progressBar.setAttribute(
            'aria-valuenow',
            valor
        );
    }

    /**
     * Toast éxito
     */
    mostrarExito(nombre, datos) {

        const toast = this.crearToast(

            nombre +
            ' subido correctamente',

            'success'
        );

        document.body.appendChild(toast);

        setTimeout(() => {

            toast.remove();

        }, 3000);
    }

    /**
     * Toast error
     */
    mostrarError(nombre, error) {

        const toast = this.crearToast(

            nombre + ': ' + error,

            'danger'
        );

        document.body.appendChild(toast);

        setTimeout(() => {

            toast.remove();

        }, 4000);
    }

    /**
     * Crea toast bootstrap
     */
    crearToast(mensaje, tipo) {

        const toast =
            document.createElement('div');

        toast.className =
            `alert alert-${tipo}
             position-fixed top-0 end-0 m-3`;

        toast.style.zIndex = '9999';

        toast.setAttribute(
            'role',
            'alert'
        );

        toast.innerHTML = `
            <i class="fas fa-info-circle"></i>
            ${mensaje}
        `;

        return toast;
    }

    /**
     * Actualiza lista visual
     */
    actualizarLista(nombreArchivo, estado) {

        const card =
            document.createElement('div');

        card.className =
            'document-card';

        card.innerHTML = `

            <div>

                <strong>
                    ${nombreArchivo}
                </strong>

                <br>

                <small class="text-muted">
                    Documento cargado
                </small>

            </div>

            <span class="
                verification-badge
                pending
            ">

                ${estado}

            </span>
        `;

        this.documentList.prepend(card);
    }
}

/**
 * Inicialización DOM
 */
document.addEventListener(

    'DOMContentLoaded',

    () => {

        new DocumentUploadManager(
            '#dropZone',
            '#fileInput'
        );
    }
);