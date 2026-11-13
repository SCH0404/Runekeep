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

-- Datos ampliados para probar listados, filtros, relaciones y flujos transaccionales.
INSERT INTO usuarios
    (usuario_id, nombre_usuario, correo, hash_contrasena, estado)
VALUES
    (4, 'sombra_ludica', 'sombra.ludica@example.test', '$argon2id$v=19$test-hash-sombra', 'activo'),
    (5, 'circuito_verde', 'circuito.verde@example.test', '$argon2id$v=19$test-hash-circuito', 'activo'),
    (6, 'admin_arcadia', 'admin.arcadia@example.test', '$argon2id$v=19$test-hash-admin', 'activo');

INSERT INTO perfiles
    (usuario_id, avatar_url, descripcion, visibilidad_perfil, visibilidad_biblioteca, zona_horaria)
VALUES
    (4, 'https://cdn.example.test/avatars/sombra.png', 'Fan de los roguelikes y las expediciones nocturnas.', 'publico', 'seguidores', 'America/Argentina/Buenos_Aires'),
    (5, 'https://cdn.example.test/avatars/circuito.png', 'Coleccionista de juegos cooperativos.', 'publico', 'publico', 'Europe/Madrid'),
    (6, NULL, 'Cuenta administrativa de pruebas.', 'privado', 'privado', 'UTC');

INSERT INTO sesiones_autenticacion
    (sesion_id, usuario_id, token_hash, dispositivo, expira_en)
VALUES
    (3, 4, 'test-session-hash-sombra', 'Firefox en Linux', now() + interval '14 days'),
    (4, 5, 'test-session-hash-circuito', 'Safari en iPad', now() + interval '20 days');

INSERT INTO videojuegos
    (videojuego_id, titulo, edicion, descripcion, fecha_lanzamiento, portada_url)
VALUES
    (3, 'Islas de Bruma', 'Edición explorador', 'Aventura narrativa entre islas flotantes.', '2022-07-14', 'https://cdn.example.test/games/islas-bruma.png'),
    (4, 'Circuito Solar', 'Edición arcade', 'Carreras pixel-art con pistas generadas.', '2025-02-21', 'https://cdn.example.test/games/circuito-solar.png'),
    (5, 'Crónicas del Umbral', 'Edición coleccionista', 'RPG táctico de escuadrones y reliquias.', '2021-11-06', 'https://cdn.example.test/games/cronicas-umbral.png');

INSERT INTO identificadores_externos_videojuego
    (identificador_id, videojuego_id, fuente, id_externo)
VALUES
    (3, 3, 'catalogo_demo', 'ISLAS-BRUMA-001'),
    (4, 4, 'catalogo_demo', 'CIRCUITO-SOLAR-001'),
    (5, 5, 'catalogo_demo', 'CRONICAS-UMBRAL-001');

INSERT INTO videojuegos_personales
    (videojuego_personal_id, usuario_id, titulo, edicion, plataforma_texto)
VALUES
    (2, 4, 'Dungeon de Medianoche', 'Prototipo 0.8', 'PC'),
    (3, 5, 'Jardín Mecánico', 'Build de pruebas', 'PC');

INSERT INTO generos
    (genero_id, nombre)
VALUES
    (4, 'Roguelike'),
    (5, 'Carreras'),
    (6, 'Táctico');

INSERT INTO videojuegos_generos (videojuego_id, genero_id)
VALUES
    (3, 2), (3, 4),
    (4, 3), (4, 5),
    (5, 1), (5, 6);

INSERT INTO plataformas
    (plataforma_id, nombre, tipo)
VALUES
    (4, 'Arcadia Handheld', 'movil'),
    (5, 'Nebula Desktop', 'pc');

INSERT INTO videojuegos_plataformas
    (videojuego_plataforma_id, videojuego_id, plataforma_id, fecha_lanzamiento_plataforma, requisitos)
VALUES
    (4, 3, 2, '2022-07-14', '{"minimo":{"ram_gb":4}}'),
    (5, 4, 4, '2025-02-21', '{"bateria_minutos":120}'),
    (6, 5, 5, '2021-11-06', '{"minimo":{"ram_gb":16,"gpu":"RX 6600"}}');

INSERT INTO empresas
    (empresa_id, nombre)
VALUES
    (3, 'Taller Bruma'),
    (4, 'Arcadia Labs');

INSERT INTO creditos_videojuegos (videojuego_id, empresa_id, funcion)
VALUES
    (3, 3, 'desarrolladora'),
    (4, 4, 'desarrolladora'),
    (5, 3, 'distribuidora');

INSERT INTO cuentas_plataforma
    (cuenta_plataforma_id, usuario_id, plataforma_id, id_externo, token_cifrado, estado, sincronizacion_automatica)
VALUES
    (3, 4, 5, 'sombra-desktop-demo', 'enc:v1:test-token-sombra', 'activa', true),
    (4, 5, 4, 'circuito-handheld-demo', 'enc:v1:test-token-circuito', 'activa', true);

INSERT INTO sincronizaciones
    (sincronizacion_id, cuenta_plataforma_id, estado, iniciada_en, finalizada_en, detalle_error)
VALUES
    (3, 3, 'completada', now() - interval '5 days', now() - interval '5 days' + interval '4 minutes', NULL),
    (4, 4, 'ejecutando', now() - interval '8 minutes', NULL, NULL);

INSERT INTO entradas_biblioteca
    (entrada_id, usuario_id, videojuego_id, estado, favorito, valoracion, resena)
VALUES
    (4, 1, 3, 'pendiente', false, NULL, NULL),
    (5, 2, 1, 'jugando', true, 10, 'La cooperativa funciona muy bien con amigos.'),
    (6, 3, 2, 'abandonado', false, 6, 'Interesante, aunque requiere más tiempo del esperado.');

INSERT INTO entradas_biblioteca
    (entrada_id, usuario_id, videojuego_personal_id, estado, favorito, valoracion, resena)
VALUES
    (7, 4, 2, 'jugando', true, 8, 'Prototipo prometedor para una sesión corta.'),
    (8, 5, 3, 'completado', false, 9, 'Una experiencia compacta y muy colorida.');

INSERT INTO entradas_biblioteca
    (entrada_id, usuario_id, videojuego_id, estado, favorito, valoracion)
VALUES
    (9, 4, 5, 'pendiente', false, NULL);

INSERT INTO posesiones_juego
    (posesion_id, entrada_id, videojuego_id, videojuego_plataforma_id, cuenta_plataforma_id, usuario_id, origen, importado_en)
VALUES
    (2, 5, 1, 2, 2, 2, 'importado', now() - interval '6 hours'),
    (3, 9, 5, 6, 3, 4, 'importado', now() - interval '5 days');

INSERT INTO sesiones_juego (sesion_juego_id, entrada_id, inicio, fin)
VALUES
    (3, 5, now() - interval '6 hours', now() - interval '5 hours' - interval '15 minutes'),
    (4, 5, now() - interval '2 hours', now() - interval '1 hour' - interval '20 minutes'),
    (5, 7, now() - interval '4 days', now() - interval '4 days' + interval '50 minutes'),
    (6, 8, now() - interval '3 days', now() - interval '3 days' + interval '2 hours'),
    (7, 8, now() - interval '2 days', now() - interval '2 days' + interval '1 hour' + interval '10 minutes');

INSERT INTO configuraciones_lanzamiento
    (configuracion_id, entrada_id, plataforma_id, ruta_local, argumentos)
VALUES
    (3, 5, 1, 'C:\Juegos\NebulaDrift\NebulaDrift.exe', '--fullscreen'),
    (4, 7, NULL, 'C:\Juegos\DungeonMedianoche\Dungeon.exe', '--safe-mode'),
    (5, 9, 5, 'D:\Runekeep\CronicasUmbral.exe', '--language es');

INSERT INTO etiquetas (etiqueta_id, usuario_id, nombre)
VALUES
    (4, 4, 'Roguelikes'),
    (5, 4, 'Por probar'),
    (6, 5, 'Cooperativos'),
    (7, 5, 'Favoritos del mes');

INSERT INTO etiquetas_entradas (entrada_id, etiqueta_id, usuario_id)
VALUES
    (7, 4, 4),
    (9, 5, 4),
    (5, 6, 5),
    (8, 7, 5);

INSERT INTO logros (logro_id, nombre, descripcion, condicion)
VALUES
    (3, 'Piloto solar', 'Completa una carrera en Circuito Solar.', '{"juegos_completados":1}'),
    (4, 'Maestro táctico', 'Alcanza cinco sesiones en un RPG táctico.', '{"sesiones_tacticas":5}'),
    (5, 'Cronista social', 'Publica tres mensajes en comunidades.', '{"publicaciones_comunidad":3}');

INSERT INTO logros_usuarios
    (usuario_id, logro_id, progreso, obtenido_en)
VALUES
    (4, 4, 3, NULL),
    (5, 3, 1, now() - interval '1 day'),
    (5, 5, 2, NULL),
    (6, 5, 0, NULL);

INSERT INTO articulos_cosmeticos
    (articulo_cosmetico_id, tipo, nombre, descripcion, rareza, categoria, ranura, recurso_visual)
VALUES
    (4, 'mascota', 'Gato cometa', 'Mascota con una estela de partículas.', 'epico', 'animal', NULL, 'https://cdn.example.test/items/comet-cat.png'),
    (5, 'accesorio', 'Antena lunar', 'Accesorio para mascotas exploradoras.', 'raro', 'cabeza', 'cabeza', 'https://cdn.example.test/items/moon-antenna.png'),
    (6, 'fondo', 'Ciudad crepuscular', 'Fondo urbano para perfiles nocturnos.', 'poco_comun', 'ciudad', 'perfil', 'https://cdn.example.test/items/twilight-city.png'),
    (7, 'mascota', 'Mini gólem', 'Compañero de piedra para expediciones.', 'legendario', 'fantasia', NULL, 'https://cdn.example.test/items/mini-golem.png');

INSERT INTO paquetes_moneda
    (paquete_moneda_id, nombre, cantidad_moneda, precio_real, codigo_moneda)
VALUES
    (3, 'Cofre de temporada', 7000, 19.99, 'USD');

INSERT INTO publicaciones_tienda
    (publicacion_tienda_id, articulo_cosmetico_id, precio_moneda_virtual, disponible_desde, activo)
VALUES
    (5, 4, 1100, now() - interval '12 days', true),
    (6, 5, 650, now() - interval '12 days', true),
    (7, 6, 300, now() - interval '12 days', true);

INSERT INTO publicaciones_tienda
    (publicacion_tienda_id, paquete_moneda_id, disponible_desde, activo)
VALUES
    (8, 3, now() - interval '12 days', true);

INSERT INTO carteras (usuario_id, saldo)
VALUES
    (3, 1500),
    (4, 1000),
    (5, 1500),
    (6, 0);

INSERT INTO compras_tienda
    (compra_id, usuario_id, publicacion_tienda_id, costo_moneda_virtual, estado)
VALUES
    (2, 2, 2, 800, 'completada'),
    (3, 5, 5, 1100, 'completada');

INSERT INTO pagos
    (pago_id, usuario_id, paquete_moneda_id, proveedor, id_transaccion_externa, importe, codigo_moneda, estado)
VALUES
    (2, 2, 2, 'proveedor_demo', 'txn-demo-0002', 9.99, 'USD', 'aprobado'),
    (3, 5, 3, 'proveedor_demo', 'txn-demo-0003', 19.99, 'USD', 'aprobado');

INSERT INTO movimientos_cartera
    (movimiento_id, usuario_id, compra_id, cantidad, tipo, clave_idempotencia)
VALUES
    (3, 2, 2, -800, 'debito', 'test-compra-0002'),
    (4, 5, 3, -1100, 'debito', 'test-compra-0003');

INSERT INTO movimientos_cartera
    (movimiento_id, usuario_id, pago_id, cantidad, tipo, clave_idempotencia)
VALUES
    (5, 2, 2, 3500, 'credito', 'test-pago-0002'),
    (6, 5, 3, 7000, 'credito', 'test-pago-0003');

INSERT INTO articulos_inventario
    (articulo_inventario_id, usuario_id, articulo_cosmetico_id, compra_id, metodo_adquisicion)
VALUES
    (4, 2, 2, 2, 'tienda'),
    (5, 5, 4, 3, 'tienda'),
    (6, 5, 5, NULL, 'logro'),
    (7, 3, 6, NULL, 'administrador'),
    (8, 4, 7, NULL, 'regalo');

INSERT INTO mascotas_usuarios
    (mascota_usuario_id, articulo_inventario_id, usuario_id, apodo)
VALUES
    (2, 5, 5, 'Cometa'),
    (3, 8, 4, 'Rocoso');

UPDATE perfiles
   SET mascota_seleccionada_id = 2
 WHERE usuario_id = 5;

UPDATE perfiles
   SET mascota_seleccionada_id = 3
 WHERE usuario_id = 4;

INSERT INTO fondos_equipados
    (usuario_id, articulo_inventario_id)
VALUES
    (3, 7);

INSERT INTO accesorios_equipados
    (mascota_usuario_id, usuario_id, articulo_inventario_id, ranura)
VALUES
    (2, 5, 6, 'cabeza');

INSERT INTO seguimientos (seguidor_id, seguido_id)
VALUES
    (4, 1),
    (5, 4),
    (6, 1);

INSERT INTO bloqueos (bloqueador_id, bloqueado_id)
VALUES
    (4, 6),
    (5, 3);

INSERT INTO comunidades
    (comunidad_id, creador_id, nombre, descripcion, reglas, visibilidad)
VALUES
    (3, 4, 'Navegantes de la Bruma', 'Rutas, teorías y capturas de Islas de Bruma.', 'Sin spoilers sin aviso.', 'publica'),
    (4, 5, 'Circuito de Medianoche', 'Retos semanales de carreras pixel-art.', 'Competir con respeto.', 'publica');

INSERT INTO intereses (interes_id, nombre)
VALUES
    (3, 'Carreras'),
    (4, 'Roguelike');

INSERT INTO comunidades_intereses (comunidad_id, interes_id)
VALUES
    (3, 2),
    (3, 4),
    (4, 3);

INSERT INTO membresias_comunidad
    (comunidad_id, usuario_id, estado, rol, ingresada_en)
VALUES
    (3, 4, 'aceptada', 'administrador', now() - interval '6 days'),
    (3, 1, 'aceptada', 'miembro', now() - interval '5 days'),
    (3, 5, 'aceptada', 'moderador', now() - interval '2 days'),
    (4, 5, 'aceptada', 'administrador', now() - interval '4 days'),
    (4, 4, 'aceptada', 'miembro', now() - interval '3 days');

INSERT INTO publicaciones
    (publicacion_id, autor_id, videojuego_id, comunidad_id, texto, visibilidad)
VALUES
    (4, 4, 3, 3, 'Encontré una ruta secreta hacia la isla del faro.', 'comunidad'),
    (5, 5, 4, 4, '¿Quién se apunta al reto de tres vueltas sin chocar?', 'comunidad'),
    (6, 4, NULL, NULL, 'Mi prototipo de mazmorra ya tiene jefe final.', 'seguidores'),
    (7, 5, 5, NULL, 'Las batallas tácticas de Crónicas del Umbral son intensas.', 'publica'),
    (8, 6, NULL, NULL, 'Recordatorio: revisen las reglas antes de reportar contenido.', 'publica');

INSERT INTO reacciones (usuario_id, publicacion_id)
VALUES
    (1, 4),
    (5, 4),
    (4, 5),
    (1, 7),
    (2, 8);

INSERT INTO comentarios
    (comentario_id, publicacion_id, autor_id, texto)
VALUES
    (4, 4, 1, 'La ruta del faro también aparece en mi mapa.'),
    (5, 5, 4, 'Me apunto al reto del fin de semana.'),
    (6, 7, 5, 'La segunda misión fue mi favorita.');

INSERT INTO comentarios
    (comentario_id, publicacion_id, autor_id, comentario_padre_id, texto)
VALUES
    (7, 4, 5, 4, 'Gracias por avisar del spoiler.');

INSERT INTO reportes
    (reporte_id, reportante_id, comentario_id, motivo, estado)
VALUES
    (2, 5, 4, 'Reporte de prueba para validar la revisión de comentarios.', 'en_revision');

INSERT INTO acciones_moderacion
    (accion_moderacion_id, reporte_id, moderador_id, accion, detalle)
VALUES
    (2, 2, 6, 'solicitar_contexto', 'Se solicitó contexto adicional al reportante.');

INSERT INTO notificaciones
    (notificacion_id, usuario_id, actor_id, tipo, referencia_tipo, referencia_id)
VALUES
    (5, 4, 5, 'reaccion', 'publicacion', 4),
    (6, 5, 4, 'comentario', 'publicacion', 5),
    (7, 4, NULL, 'logro', 'logro', 4),
    (8, 5, NULL, 'sincronizacion', 'sincronizacion', 4);

INSERT INTO dispositivos_push
    (dispositivo_push_id, usuario_id, plataforma, token_hash, token_cifrado)
VALUES
    (3, 4, 'web', 'test-push-hash-sombra', 'enc:v1:test-push-token-sombra'),
    (4, 5, 'ios', 'test-push-hash-circuito', 'enc:v1:test-push-token-circuito');

INSERT INTO preferencias_recomendacion (usuario_id, habilitadas)
VALUES
    (4, true),
    (5, false),
    (6, false);

INSERT INTO recomendaciones_ocultas (usuario_id, videojuego_id)
VALUES
    (4, 2),
    (5, 3),
    (6, 4);

INSERT INTO actividad_usuario
    (actividad_id, usuario_id, tipo, referencia_tipo, referencia_id, datos)
VALUES
    (4, 4, 'sesion_juego_creada', 'sesion_juego', 5, '{"minutos":50}'),
    (5, 5, 'compra_realizada', 'compra', 3, '{"origen":"tienda"}'),
    (6, 5, 'comunidad_creada', 'comunidad', 4, '{"visibilidad":"publica"}'),
    (7, 6, 'reporte_revisado', 'reporte', 2, '{"accion":"solicitar_contexto"}');

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
