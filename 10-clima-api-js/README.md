#  App del Clima con API

Aplicación del clima que consume la API de OpenWeatherMap.

## Funcionalidades
- Buscar clima por nombre de ciudad
- Muestra temperatura, sensación térmica, humedad, viento y visibilidad
- Iconos visuales según el clima
- Botones de acceso rápido para ciudades populares
- Funciona con datos de ejemplo si no tienes API key

## Configuración
1. Regístrate gratis en [openweathermap.org](https://openweathermap.org)
2. Ve a "API Keys" en tu perfil
3. Copia tu API key
4. En el archivo `index.html`, busca esta línea:
   ```javascript
   const API_KEY = 'TU_API_KEY';
   ```
5. Reemplaza `TU_API_KEY` con tu clave real

## Tecnologías
- HTML5
- CSS3 (glassmorphism)
- JavaScript con `fetch` y `async/await`
- API REST (OpenWeatherMap)

## Conceptos aprendidos
- Consumo de APIs externas
- Promesas y async/await
- Manejo de errores en peticiones HTTP
- Manipulación del DOM con datos de API
