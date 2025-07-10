# Tests de Integración para BankAIO

Este directorio contiene un conjunto completo de tests de integración para la aplicación BankAIO, específicamente enfocados en el flujo de autenticación y login.

## 📁 Estructura de Tests

### 1. `login_backend_states_test.dart`
Test principal que valida los estados del backend durante el proceso de login:
- ✅ Login exitoso con navegación a home
- ✅ Validación de campos vacíos
- ✅ Manejo de credenciales incorrectas
- ✅ Validación de email inválido
- ✅ Verificación completa de la interfaz
- ✅ Funcionalidad de toggle de visibilidad de contraseña

### 2. `login_comprehensive_test.dart`
Tests comprehensivos que cubren casos de uso avanzados:
- ✅ Flujo completo de login con validaciones detalladas
- ✅ Validación de múltiples formatos de email inválidos
- ✅ Prueba de múltiples credenciales incorrectas
- ✅ Verificación de accesibilidad y usabilidad
- ✅ Tests de rendimiento y timeouts

### 3. `login_states_test.dart`
Tests especializados en estados de la aplicación:
- ✅ Estado inicial de la aplicación
- ✅ Estados de carga durante autenticación
- ✅ Estados de éxito y navegación
- ✅ Estados de error con diferentes escenarios
- ✅ Transiciones de estado con múltiples intentos
- ✅ Persistencia y limpieza de estado

## 🚀 Ejecución de Tests

### Prerequisitos
1. **Firebase Emulators**: Los tests están configurados para usar emuladores de Firebase
2. **Credenciales de prueba**: Se utilizan credenciales específicas para testing

### Comandos de Ejecución

#### Ejecutar todos los tests de integración:
```bash
flutter test integration_test/
```

#### Ejecutar un test específico:
```bash
# Test principal de estados del backend
flutter test integration_test/login_backend_states_test.dart

# Test comprehensivo
flutter test integration_test/login_comprehensive_test.dart

# Test de estados de aplicación
flutter test integration_test/login_states_test.dart
```

#### Ejecutar con dispositivo específico:
```bash
flutter test integration_test/ -d <device_id>
```

#### Ejecutar con logging detallado:
```bash
flutter test integration_test/ --dart-define=FLUTTER_TEST_LOG_LEVEL=debug
```

## 🔧 Configuración

### Variables de Entorno
Los tests utilizan las siguientes configuraciones:
- `useEmulators: true` - Fuerza el uso de emuladores de Firebase
- Credenciales de prueba: `ccalispa@yahoo.es` / `carlitos1001`

### Firebase Emulators
Asegúrate de que los emuladores de Firebase estén ejecutándose:
```bash
firebase emulators:start
```

## 📊 Cobertura de Tests

### Escenarios Cubiertos

#### ✅ Flujos Positivos
- Login exitoso con credenciales válidas
- Navegación correcta a la pantalla de home
- Verificación de elementos de UI esperados

#### ❌ Flujos Negativos
- Campos vacíos (email y/o contraseña)
- Formatos de email inválidos
- Credenciales incorrectas
- Validaciones de formulario

#### 🎨 UI/UX
- Verificación de elementos de interfaz
- Toggle de visibilidad de contraseña
- Indicadores de carga
- Mensajes de error apropiados
- Accesibilidad básica

#### ⚡ Rendimiento
- Tiempos de carga de la aplicación
- Respuesta de la interfaz de usuario
- Timeouts apropiados

## 🔍 Debugging

### Logging Mejorado
Los tests incluyen logging detallado con emojis para fácil identificación:
- 🚀 Inicio de tests
- ✅ Operaciones exitosas
- ❌ Errores y fallos
- 🔍 Búsqueda de elementos
- ⏳ Esperas y timeouts
- 🧹 Limpieza de estado

### Helpers Disponibles

#### `pumpUntilFound()`
Función helper mejorada para esperar widgets con:
- Timeout configurable
- Logging detallado
- Manejo de errores mejorado
- Información de debugging

#### `waitForNoLoadingIndicators()`
Helper para esperar que terminen los indicadores de carga

#### `expectSnackBarWithMessage()`
Helper para verificar mensajes específicos en SnackBars

#### `clearAppState()`
Helper para limpiar el estado entre tests

## 🏗️ Arquitectura de Tests

### Principios Aplicados
1. **Aislamiento**: Cada test es independiente
2. **Reutilización**: Helpers comunes para operaciones repetitivas
3. **Claridad**: Logging descriptivo y estructura clara
4. **Robustez**: Manejo de timeouts y errores
5. **Cobertura**: Tests para casos positivos, negativos y edge cases

### Patrones Utilizados
- **Page Object Pattern**: Abstracciones para elementos de UI
- **Test Data Builders**: Datos de prueba estructurados
- **Fluent Assertions**: Verificaciones claras y expresivas

## 📝 Mantenimiento

### Agregar Nuevos Tests
1. Seguir la estructura existente con helpers
2. Incluir logging descriptivo
3. Manejar timeouts apropiadamente
4. Limpiar estado entre tests

### Actualizar Tests Existentes
1. Mantener compatibilidad con helpers existentes
2. Actualizar credenciales de prueba si es necesario
3. Ajustar timeouts según rendimiento de la app

## 🔐 Seguridad en Tests

### Credenciales de Prueba
- Las credenciales utilizadas son específicas para testing
- No se utilizan credenciales de producción
- Los emuladores aíslan completamente el entorno de testing

### Datos Sensibles
- No se almacenan datos sensibles en el código
- Las credenciales de prueba están diseñadas para ser públicas en el contexto de desarrollo

## 📈 Métricas y Reportes

### Información de Rendimiento
Los tests capturan métricas básicas de rendimiento:
- Tiempo de carga inicial de la aplicación
- Tiempo de respuesta de inputs de usuario
- Tiempo de navegación entre pantallas

### Reportes de Fallos
En caso de fallos, los tests proporcionan:
- Stack trace detallado
- Estado de la aplicación al momento del fallo
- Screenshots automáticos (si está configurado)
- Logs de debugging completos

---

## 🤝 Contribución

Para contribuir con nuevos tests o mejoras:
1. Mantener el estilo de logging existente
2. Incluir documentación para nuevos helpers
3. Probar en múltiples dispositivos/emuladores
4. Actualizar esta documentación según sea necesario
