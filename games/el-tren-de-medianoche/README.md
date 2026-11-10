# El tren de medianoche — Demo 0.1

Juego web original en español (B2), de suspense y supervivencia narrativa.

## Cómo jugar

Abre `index.html` en un navegador moderno. Pulsa **COMENZAR EL VIAJE** para activar el audio. Elige acciones o escribe comandos en español. Consulta las pruebas, personas y cronología en el cuaderno. La partida se guarda automáticamente en `localStorage` del navegador.

## Publicar gratis en Netlify

1. Descomprime el ZIP.
2. Visita https://app.netlify.com/drop
3. Arrastra **la carpeta `el_tren_de_medianoche_demo`** que contiene `index.html` (o crea un ZIP del contenido de esa carpeta).
4. Copia el enlace HTTPS que te proporciona Netlify y compártelo.

No necesita instalación, cuentas de jugador ni claves API. Los archivos se sirven de forma estática.

## Sonido

Audio original generado mediante Web Audio API: motor del tren, vibración, pasos, golpes, papel, puertas y tensión. No incluye música ni grabaciones externas. El navegador exige una interacción inicial antes de reproducir audio. Hay control de silencio y volumen.

## Límites de esta versión

- Demo narrativa ramificada con finales convergentes; no es un juego 3D.
- El campo de texto interpreta una selección de intenciones en español; **no es un chatbot con IA generativa**. Si no reconoce la acción, sugiere usar las opciones.
- La duración depende del ritmo de lectura y exploración; el contenido es una demo corta y **no se garantiza una duración de 15–20 minutos**.
- Los datos se guardan únicamente en el navegador/dispositivo usado. Borrar los datos del sitio elimina el progreso.
- La investigación completa y la resolución del misterio quedan para capítulos posteriores.

## Estructura

- `index.html`: interfaz.
- `style.css`: diseño responsive y escena ilustrada mediante CSS.
- `game.js`: historia, estado, comandos, cuaderno, guardado y audio.

## Ampliación

Para incorporar diálogo libre real con IA se necesitará un backend, control de estado canónico, validación de acciones y gestión segura de credenciales. No se debe insertar una clave API en JavaScript público.