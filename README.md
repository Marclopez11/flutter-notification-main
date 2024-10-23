# Climarec Push Notification

## Descripción

Climarec Push Notification es una aplicación Flutter diseñada para recibir notificaciones en los tres estados principales de tu dispositivo móvil (activo, en segundo plano y en modo inactivo).

Esta aplicacion mantiene  informados a tus usarios  de todas las  actualizaciones importantes de manera oportuna y eficaz.

- [x] Foreground
- [x] Background
- [x] Activa

## Configuración

### Configuración de Firebase para iOS

Para habilitar la recepción de notificaciones en dispositivos iOS, sigue estos pasos:

1. **Crea un Proyecto Firebase**:
   - Accede a [Firebase Console](https://console.firebase.google.com/).
   - Crea un nuevo proyecto o selecciona uno existente.

2. **Agrega tu Aplicación iOS**:
   - Dentro del proyecto de Firebase, ve a la sección de configuración de tu proyecto.
   - Haz clic en "Agregar App" y selecciona la plataforma iOS.
   - Sigue los pasos para registrar tu aplicación y descargar el archivo `GoogleService-Info.plist`.

3.1 Añadir el cerficado APNS  , a la hora de subirlo tener encuenta que el id  que hay que poner es el que genera el archivo apns , se puede conseguir en el apple/keys

3. **Configura el Entorno de Desarrollo**:
   - Abre tu proyecto de Flutter en Xcode.
   - Coloca el archivo `GoogleService-Info.plist` descargado en la raíz del proyecto de Xcode.

4. **Configura Firebase Cloud Messaging**:
   - Agrega el SDK de Firebase Cloud Messaging a tu proyecto Flutter (ver archivo `pubspec.yaml`).
   - Implementa la lógica de manejo de notificaciones push en tu aplicación Flutter.


### Configuración de Firebase para Android

Para habilitar la recepción de notificaciones en dispositivos Android, sigue estos pasos:

1. **Crea un Proyecto Firebase**:
   - Accede a [Firebase Console](https://console.firebase.google.com/).
   - Crea un nuevo proyecto o selecciona uno existente.

2. **Agrega tu Aplicación Android**:
   - Dentro del proyecto de Firebase, ve a la sección de configuración de tu proyecto.
   - Haz clic en "Agregar App" y selecciona la plataforma Android.
   - Sigue los pasos para registrar tu aplicación y descarga el archivo `google-services.json`.

3. **Configura el Entorno de Desarrollo**:
   - Coloca el archivo `google-services.json` descargado en la carpeta `android/app` de tu proyecto Flutter.

4. **Configura Firebase Cloud Messaging**:
   - Agrega el SDK de Firebase Cloud Messaging a tu proyecto Flutter (ver archivo `pubspec.yaml`).
   - Implementa la lógica de manejo de notificaciones push en tu aplicación Flutter.
