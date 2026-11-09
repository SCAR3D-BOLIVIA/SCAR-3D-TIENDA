# Activar base de datos y autenticación de SCAR 3D

## Datos configurados
- Administrador autorizado: `rufranz.chiqui@gmail.com`
- WhatsApp: `+591 77748285`
- Correo de contacto: `rufranz.chiqui@gmail.com`
- Clientes: acceso público para ver catálogo y enviar pedidos.
- Administración: solo el correo administrador anterior.

## Paso 1 — Crear proyecto Supabase
1. Entra en https://supabase.com/ y crea una cuenta/proyecto con el correo administrador.
2. Crea un proyecto llamado `scar3d`.
3. Guarda la contraseña de base de datos en un gestor seguro; no la compartas en el chat.
4. En Project Settings > API copia Project URL y la publishable key (o anon key legacy).

## Paso 2 — Crear las tablas y reglas de seguridad
1. Abre SQL Editor dentro del proyecto.
2. Abre `supabase/schema.sql` de este paquete.
3. Copia y ejecuta el contenido completo.
4. En Authentication > Providers confirma que Email está habilitado.
5. En Authentication > URL Configuration, cuando publiques la web, añade la URL de GitHub Pages a Site URL y Redirect URLs.

## Paso 3 — Crear la cuenta única de administrador
1. En Authentication > Users, selecciona Add user / Create new user.
2. Crea el usuario `rufranz.chiqui@gmail.com` y define tú mismo una contraseña larga y única.
3. Desactiva el registro público de nuevos usuarios (Allow new users to sign up) en Authentication > Settings, si no necesitas cuentas de clientes.
4. Los clientes no necesitan cuenta para explorar y enviar pedidos.
5. La base de datos autoriza la gestión solo cuando el JWT autenticado contiene exactamente el correo `rufranz.chiqui@gmail.com`.

## Paso 4 — Conectar la PWA
1. Copia `supabase/config.example.js` como `supabase/config.js`.
2. Coloca el Project URL y la publishable/anon key.
3. No uses jamás `service_role` en el frontend.
4. Antes de publicar, verifica que RLS esté activo en las tablas y que solo el correo administrador pueda modificar productos/contactos/pedidos.

## Seguridad y alcance
Este paquete incorpora el esquema SQL, políticas RLS, bucket público de imágenes y la configuración de contacto. La PWA frontend sigue siendo el prototipo v3; la sincronización de catálogo, carga de imágenes, gestión de pedidos y login deben conectarse al proyecto Supabase con los valores reales antes de considerarse activos. No afirmes que la autenticación está operativa hasta probarla con el proyecto creado.

## Costos
Supabase ofrece un nivel gratuito sujeto a límites, cuotas, inactividad y cambios de sus condiciones. GitHub Pages ofrece alojamiento estático gratuito para repositorios públicos, sujeto a sus límites. Dominio propio opcional.
