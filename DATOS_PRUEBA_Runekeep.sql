-- DATOS DE PRUEBA DE RUNEKEEP
-- ADVERTENCIA: este script elimina los datos del esquema runekeep.
-- Ejecútalo únicamente en una base de desarrollo o pruebas.

BEGIN;

SET search_path TO runekeep, public;

TRUNCATE TABLE
    usuarios,
    videojuegos,
    generos,
    plataformas,
    empresas,
    articulos_cosmeticos,
    paquetes_moneda,
    logros
RESTART IDENTITY CASCADE;

INSERT INTO usuarios
    (usuario_id, nombre_usuario, correo, hash_contrasena, estado)
VALUES
    (1, 'luna_arcana', 'luna.arcana@example.test', '$argon2id$v=19$test-hash-luna', 'activo'),
    (2, 'nexo_pixel', 'nexo.pixel@example.test', '$argon2id$v=19$test-hash-nexo', 'activo'),
    (3, 'moderador_demo', 'moderador@example.test', '$argon2id$v=19$test-hash-moderador', 'activo');

INSERT INTO perfiles
    (usuario_id, avatar_url, descripcion, visibilidad_perfil, visibilidad_biblioteca, zona_horaria)
VALUES
    (1, 'https://cdn.example.test/avatars/luna.png', 'Exploradora de mundos y coleccionista de logros.', 'publico', 'seguidores', 'America/Bogota'),
    (2, 'https://cdn.example.test/avatars/nexo.png', 'Jugador ocasional y creador de comunidades.', 'publico', 'publico', 'America/Mexico_City'),
    (3, NULL, 'Cuenta de moderación para pruebas.', 'privado', 'privado', 'UTC');

INSERT INTO sesiones_autenticacion
    (sesion_id, usuario_id, token_hash, dispositivo, expira_en)
VALUES
    (1, 1, 'test-session-hash-luna', 'Chrome en Windows', now() + interval '30 days'),
    (2, 2, 'test-session-hash-nexo', 'Aplicación móvil Android', now() + interval '30 days');

INSERT INTO tokens_recuperacion
    (token_id, usuario_id, token_hash, expira_en)
VALUES
    (1, 1, 'test-recovery-hash-luna', now() + interval '1 hour');

INSERT INTO videojuegos
    (videojuego_id, titulo, edicion, descripcion, fecha_lanzamiento, portada_url)
VALUES
    (1, 'Nebula Drift', 'Edición estándar', 'Aventura espacial cooperativa.', '2024-04-18', 'https://cdn.example.test/games/nebula-drift.png'),
    (2, 'Bosque de Runas', 'Edición definitiva', 'RPG de exploración y construcción.', '2023-09-02', 'https://cdn.example.test/games/bosque-runas.png');

INSERT INTO identificadores_externos_videojuego
    (identificador_id, videojuego_id, fuente, id_externo)
VALUES
    (1, 1, 'catalogo_demo', 'NEBULA-DRIFT-001'),
    (2, 2, 'catalogo_demo', 'BOSQUE-RUNAS-001');

INSERT INTO videojuegos_personales
    (videojuego_personal_id, usuario_id, titulo, edicion, plataforma_texto)
VALUES
    (1, 1, 'Proyecto Aurora', 'Demo local', 'PC');

INSERT INTO generos
    (genero_id, nombre)
VALUES
    (1, 'RPG'),
    (2, 'Aventura'),
    (3, 'Cooperativo');

INSERT INTO videojuegos_generos (videojuego_id, genero_id)
VALUES
    (1, 1), (1, 3), (2, 1), (2, 2);

INSERT INTO plataformas
    (plataforma_id, nombre, tipo)
VALUES
    (1, 'Windows', 'pc'),
    (2, 'Nebula Console', 'consola'),
    (3, 'Runekeep Cloud', 'servicio');

INSERT INTO videojuegos_plataformas
    (videojuego_plataforma_id, videojuego_id, plataforma_id, fecha_lanzamiento_plataforma, requisitos)
VALUES
    (1, 1, 1, '2024-04-18', '{"minimo":{"ram_gb":8,"gpu":"GTX 1060"},"recomendado":{"ram_gb":16}}'),
    (2, 1, 3, '2024-05-01', '{"latencia_maxima_ms":80}'),
    (3, 2, 1, '2023-09-02', '{"minimo":{"ram_gb":8}}');

INSERT INTO empresas
    (empresa_id, nombre)
VALUES
    (1, 'Estudio Aurora'),
    (2, 'Distribuciones Prisma');

INSERT INTO creditos_videojuegos (videojuego_id, empresa_id, funcion)
VALUES
    (1, 1, 'desarrolladora'),
    (1, 2, 'distribuidora'),
    (2, 1, 'desarrolladora');

INSERT INTO cuentas_plataforma
    (cuenta_plataforma_id, usuario_id, plataforma_id, id_externo, token_cifrado, estado, sincronizacion_automatica)
VALUES
    (1, 1, 1, 'luna-steam-demo', 'enc:v1:test-token-luna', 'activa', true),
    (2, 2, 3, 'nexo-cloud-demo', 'enc:v1:test-token-nexo', 'activa', false);

INSERT INTO sincronizaciones
    (sincronizacion_id, cuenta_plataforma_id, estado, iniciada_en, finalizada_en, detalle_error)
VALUES
    (1, 1, 'completada', now() - interval '20 minutes', now() - interval '10 minutes', NULL),
    (2, 2, 'fallida', now() - interval '2 hours', now() - interval '1 hour', 'Proveedor de prueba no disponible');

INSERT INTO entradas_biblioteca
    (entrada_id, usuario_id, videojuego_id, estado, favorito, valoracion, resena)
VALUES
    (1, 1, 1, 'jugando', true, 9, 'Excelente ambientación y banda sonora.'),
    (2, 2, 2, 'completado', false, 8, 'Una aventura corta pero muy cuidada.');

INSERT INTO entradas_biblioteca
    (entrada_id, usuario_id, videojuego_personal_id, estado, favorito)
VALUES
    (3, 1, 1, 'pendiente', false);

INSERT INTO posesiones_juego
    (posesion_id, entrada_id, videojuego_id, videojuego_plataforma_id, cuenta_plataforma_id, usuario_id, origen, importado_en)
VALUES
    (1, 1, 1, 1, 1, 1, 'importado', now() - interval '2 days');

INSERT INTO sesiones_juego (sesion_juego_id, entrada_id, inicio, fin)
VALUES
    (1, 1, now() - interval '3 hours', now() - interval '1 hour'),
    (2, 2, now() - interval '2 days', now() - interval '2 days' + interval '45 minutes');

INSERT INTO configuraciones_lanzamiento
    (configuracion_id, entrada_id, plataforma_id, ruta_local, argumentos)
VALUES
    (1, 1, 1, 'C:\Juegos\NebulaDrift\NebulaDrift.exe', '--windowed --language es'),
    (2, 3, NULL, 'C:\Juegos\ProyectoAurora\Aurora.exe', '--safe-mode');

INSERT INTO etiquetas (etiqueta_id, usuario_id, nombre)
VALUES
    (1, 1, 'Favoritos'),
    (2, 1, 'Jugar el fin de semana'),
    (3, 2, 'Completados');

INSERT INTO etiquetas_entradas (entrada_id, etiqueta_id, usuario_id)
VALUES
    (1, 1, 1),
    (3, 2, 1),
    (2, 3, 2);

INSERT INTO logros (logro_id, nombre, descripcion, condicion)
VALUES
    (1, 'Primera partida', 'Inicia tu primera sesión de juego.', '{"sesiones":1}'),
    (2, 'Explorador', 'Completa tres sesiones de juego.', '{"sesiones":3}');

INSERT INTO logros_usuarios
    (usuario_id, logro_id, progreso, obtenido_en)
VALUES
    (1, 1, 1, now() - interval '2 hours'),
    (1, 2, 2, NULL),
    (2, 1, 1, now() - interval '1 day');

INSERT INTO articulos_cosmeticos
    (articulo_cosmetico_id, tipo, nombre, descripcion, rareza, categoria, ranura, recurso_visual)
VALUES
    (1, 'mascota', 'Búho de neón', 'Mascota luminosa para el perfil.', 'raro', 'animal', NULL, 'https://cdn.example.test/items/owl.png'),
    (2, 'fondo', 'Cielo estrellado', 'Fondo animado para el perfil.', 'epico', 'espacio', 'perfil', 'https://cdn.example.test/items/sky.png'),
    (3, 'accesorio', 'Gafas prismáticas', 'Accesorio cosmético para mascotas.', 'poco_comun', 'rostro', 'cara', 'https://cdn.example.test/items/glasses.png');

INSERT INTO paquetes_moneda
    (paquete_moneda_id, nombre, cantidad_moneda, precio_real, codigo_moneda)
VALUES
    (1, 'Bolsa pequeña', 1200, 4.99, 'USD'),
    (2, 'Bolsa grande', 3500, 9.99, 'USD');

INSERT INTO publicaciones_tienda
    (publicacion_tienda_id, articulo_cosmetico_id, precio_moneda_virtual, disponible_desde, activo)
VALUES
    (1, 1, 500, now() - interval '30 days', true),
    (2, 2, 800, now() - interval '30 days', true);

INSERT INTO publicaciones_tienda
    (publicacion_tienda_id, paquete_moneda_id, disponible_desde, activo)
VALUES
    (3, 1, now() - interval '30 days', true),
    (4, 2, now() - interval '30 days', true);

INSERT INTO carteras (usuario_id, saldo)
VALUES
    (1, 1000),
    (2, 250);

INSERT INTO compras_tienda
    (compra_id, usuario_id, publicacion_tienda_id, costo_moneda_virtual, estado)
VALUES
    (1, 1, 1, 500, 'completada');

INSERT INTO pagos
    (pago_id, usuario_id, paquete_moneda_id, proveedor, id_transaccion_externa, importe, codigo_moneda, estado)
VALUES
    (1, 1, 1, 'proveedor_demo', 'txn-demo-0001', 4.99, 'USD', 'aprobado');

INSERT INTO movimientos_cartera
    (movimiento_id, usuario_id, compra_id, cantidad, tipo, clave_idempotencia)
VALUES
    (1, 1, 1, -500, 'debito', 'test-compra-0001');

INSERT INTO movimientos_cartera
    (movimiento_id, usuario_id, pago_id, cantidad, tipo, clave_idempotencia)
VALUES
    (2, 1, 1, 1200, 'credito', 'test-pago-0001');

INSERT INTO articulos_inventario
    (articulo_inventario_id, usuario_id, articulo_cosmetico_id, compra_id, metodo_adquisicion)
VALUES
    (1, 1, 1, 1, 'tienda'),
    (2, 1, 2, NULL, 'administrador'),
    (3, 1, 3, NULL, 'regalo');

INSERT INTO mascotas_usuarios
    (mascota_usuario_id, articulo_inventario_id, usuario_id, apodo)
VALUES
    (1, 1, 1, 'Pixel');

UPDATE perfiles
   SET mascota_seleccionada_id = 1
 WHERE usuario_id = 1;

INSERT INTO fondos_equipados
    (usuario_id, articulo_inventario_id)
VALUES
    (1, 2);

INSERT INTO accesorios_equipados
    (mascota_usuario_id, usuario_id, articulo_inventario_id, ranura)
VALUES
    (1, 1, 3, 'cara');

INSERT INTO seguimientos (seguidor_id, seguido_id)
VALUES
    (1, 2),
    (2, 1);

INSERT INTO bloqueos (bloqueador_id, bloqueado_id)
VALUES
    (2, 3);

INSERT INTO comunidades
    (comunidad_id, creador_id, nombre, descripcion, reglas, visibilidad)
VALUES
    (1, 2, 'Exploradores de Runekeep', 'Comunidad para compartir descubrimientos.', 'Respeto y contenido relacionado con videojuegos.', 'publica'),
    (2, 3, 'Moderación interna', 'Espacio privado para pruebas de moderación.', 'Solo personal autorizado.', 'privada');

INSERT INTO intereses (interes_id, nombre)
VALUES
    (1, 'RPG'),
    (2, 'Aventura');

INSERT INTO comunidades_intereses (comunidad_id, interes_id)
VALUES
    (1, 1),
    (1, 2);

INSERT INTO membresias_comunidad
    (comunidad_id, usuario_id, estado, rol, ingresada_en)
VALUES
    (1, 2, 'aceptada', 'administrador', now() - interval '10 days'),
    (1, 1, 'aceptada', 'miembro', now() - interval '5 days'),
    (2, 3, 'aceptada', 'administrador', now() - interval '10 days');

INSERT INTO publicaciones
    (publicacion_id, autor_id, videojuego_id, comunidad_id, texto, visibilidad)
VALUES
    (1, 1, 1, NULL, 'Estoy probando la nueva biblioteca de Runekeep.', 'publica'),
    (2, 1, 1, 1, '¿Qué plataforma recomiendan para Nebula Drift?', 'comunidad'),
    (3, 2, NULL, 1, 'Bienvenidos a la comunidad de exploradores.', 'comunidad');

INSERT INTO reacciones (usuario_id, publicacion_id)
VALUES
    (2, 1),
    (1, 3);

INSERT INTO comentarios
    (comentario_id, publicacion_id, autor_id, texto)
VALUES
    (1, 1, 2, 'La biblioteca se ve muy completa.'),
    (2, 1, 1, 'Gracias, todavía estoy agregando etiquetas.');

INSERT INTO comentarios
    (comentario_id, publicacion_id, autor_id, comentario_padre_id, texto)
VALUES
    (3, 1, 2, 1, 'También me gustó el sistema de filtros.');

INSERT INTO reportes
    (reporte_id, reportante_id, publicacion_id, motivo, estado)
VALUES
    (1, 2, 1, 'Reporte de prueba para validar el flujo de moderación.', 'pendiente');

INSERT INTO acciones_moderacion
    (accion_moderacion_id, reporte_id, moderador_id, accion, detalle)
VALUES
    (1, 1, 3, 'marcar_revision', 'Acción de prueba registrada por moderación.');

INSERT INTO notificaciones
    (notificacion_id, usuario_id, actor_id, tipo, referencia_tipo, referencia_id)
VALUES
    (1, 1, 2, 'reaccion', 'publicacion', 1),
    (2, 1, 2, 'comentario', 'publicacion', 1),
    (3, 1, NULL, 'logro', 'logro', 1),
    (4, 1, NULL, 'sincronizacion_fallida', 'sincronizacion', 2);

INSERT INTO dispositivos_push
    (dispositivo_push_id, usuario_id, plataforma, token_hash, token_cifrado)
VALUES
    (1, 1, 'web', 'test-push-hash-luna', 'enc:v1:test-push-token-luna'),
    (2, 2, 'android', 'test-push-hash-nexo', 'enc:v1:test-push-token-nexo');

INSERT INTO preferencias_recomendacion (usuario_id, habilitadas)
VALUES
    (1, true),
    (2, true);

INSERT INTO recomendaciones_ocultas (usuario_id, videojuego_id)
VALUES
    (1, 2);

INSERT INTO actividad_usuario
    (actividad_id, usuario_id, tipo, referencia_tipo, referencia_id, datos)
VALUES
    (1, 1, 'entrada_biblioteca_creada', 'entrada_biblioteca', 1, '{"origen":"catalogo"}'),
    (2, 1, 'logro_desbloqueado', 'logro', 1, '{"prueba":true}'),
    (3, 2, 'comunidad_creada', 'comunidad', 1, '{"visibilidad":"publica"}');

-- Deja las secuencias listas para nuevos registros después de los datos explícitos.
DO $$
DECLARE
    secuencia record;
BEGIN
    FOR secuencia IN
        SELECT
            c.table_name,
            c.column_name,
            pg_get_serial_sequence(format('%I.%I', c.table_schema, c.table_name), c.column_name) AS nombre_secuencia
        FROM information_schema.columns c
        WHERE c.table_schema = 'runekeep'
          AND c.is_identity = 'YES'
    LOOP
        IF secuencia.nombre_secuencia IS NOT NULL THEN
            EXECUTE format(
                'SELECT setval(%L, GREATEST(COALESCE((SELECT max(%I) FROM %I.%I), 1), 1), true)',
                secuencia.nombre_secuencia,
                secuencia.column_name,
                'runekeep',
                secuencia.table_name
            );
        END IF;
    END LOOP;
END;
$$;

COMMIT;
