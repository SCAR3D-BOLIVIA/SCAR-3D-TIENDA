# SCAR 3D PWA — versión 4 (preparación Supabase)

Esta versión incluye el logo oficial proporcionado por el usuario, catálogo, carrito de compra, edición de productos/contactos en modo demostración, PWA y el esquema SQL de seguridad para Supabase.

## Contacto configurado
- WhatsApp: +591 77748285
- Correo: rufranz.chiqui@gmail.com

## Acceso previsto
- Clientes: catálogo público y pedidos sin cuenta.
- Administrador único: rufranz.chiqui@gmail.com.
- Modificación de productos, contactos y pedidos: protegida por políticas RLS en Supabase.

## Archivos importantes
- `index.html`: frontend PWA.
- `manifest.webmanifest`, `sw.js`, `icons/`: instalación Android y caché.
- `supabase/schema.sql`: tablas, políticas RLS y bucket de imágenes.
- `supabase/config.example.js`: plantilla de credenciales públicas.
- `SUPABASE_SETUP.md`: instrucciones para activar el backend.

## Estado real
El esquema y las políticas están preparados, pero la base de datos no está conectada todavía porque falta crear el proyecto Supabase y obtener su URL y clave publishable/anon. El frontend de demostración aún almacena algunos datos en el navegador. Sigue `SUPABASE_SETUP.md` para activar el backend; después habrá que integrar y probar las llamadas desde la PWA.

## Seguridad
No incluir la clave `service_role` ni contraseñas en archivos públicos. La clave publishable/anon solo puede exponerse con RLS bien configurado. No usar la contraseña demo del prototipo en producción.

## Licencia
MIT.
