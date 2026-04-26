USE ride_hailing;

DELIMITER //

-- 1. Crear un viaje solicitado por un rider

DROP PROCEDURE IF EXISTS sp_crear_viaje//

CREATE PROCEDURE sp_crear_viaje (
    IN p_id_rider BIGINT,
    IN p_id_metodo_pago BIGINT,
    IN p_origen_lat DECIMAL(10,7),
    IN p_origen_lng DECIMAL(10,7),
    IN p_origen_direccion VARCHAR(255),
    IN p_destino_lat DECIMAL(10,7),
    IN p_destino_lng DECIMAL(10,7),
    IN p_destino_direccion VARCHAR(255),
    IN p_importe_estimado DECIMAL(10,2)
)
BEGIN
    DECLARE v_id_viaje BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM rider
        WHERE id_usuario = p_id_rider
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El rider indicado no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM metodo_pago
        WHERE id_metodo_pago = p_id_metodo_pago
          AND id_usuario = p_id_rider
          AND activo = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El método de pago no existe, no está activo o no pertenece al rider';
    END IF;

    INSERT INTO viaje (
        id_rider,
        id_driver_asignado,
        id_metodo_pago,
        estado,
        fecha_solicitud,
        origen_lat,
        origen_lng,
        origen_direccion,
        destino_lat,
        destino_lng,
        destino_direccion,
        importe_estimado,
        importe_final
    )
    VALUES (
        p_id_rider,
        NULL,
        p_id_metodo_pago,
        'SOLICITADO',
        NOW(),
        p_origen_lat,
        p_origen_lng,
        p_origen_direccion,
        p_destino_lat,
        p_destino_lng,
        p_destino_direccion,
        p_importe_estimado,
        p_importe_estimado
    );

    SET v_id_viaje = LAST_INSERT_ID();

    INSERT INTO auditoria_evento (
        tabla_afectada,
        id_registro,
        accion,
        detalle,
        usuario_bd,
        fecha_evento
    )
    VALUES (
        'viaje',
        v_id_viaje,
        'INSERT',
        CONCAT('Viaje creado mediante procedimiento almacenado. ID: ', v_id_viaje),
        CURRENT_USER(),
        NOW()
    );

    COMMIT;

    SELECT v_id_viaje AS id_viaje_creado;
END//


-- 2. Enviar una oferta a un conductor

DROP PROCEDURE IF EXISTS sp_enviar_oferta//

CREATE PROCEDURE sp_enviar_oferta (
    IN p_id_viaje BIGINT,
    IN p_id_driver BIGINT
)
BEGIN
    DECLARE v_estado_viaje VARCHAR(30);
    DECLARE v_id_oferta BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM viaje
        WHERE id_viaje = p_id_viaje
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El viaje indicado no existe';
    END IF;

    SELECT estado
    INTO v_estado_viaje
    FROM viaje
    WHERE id_viaje = p_id_viaje
    FOR UPDATE;

    IF v_estado_viaje <> 'SOLICITADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solo se pueden enviar ofertas para viajes en estado SOLICITADO';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM driver
        WHERE id_usuario = p_id_driver
          AND estado_driver = 'ACTIVO'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El conductor no existe o no está activo';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM oferta
        WHERE id_viaje = p_id_viaje
          AND id_driver = p_id_driver
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ya existe una oferta para ese conductor en ese viaje';
    END IF;

    INSERT INTO oferta (
        id_viaje,
        id_driver,
        fecha_envio,
        estado_oferta,
        fecha_respuesta
    )
    VALUES (
        p_id_viaje,
        p_id_driver,
        NOW(),
        'PENDIENTE',
        NULL
    );

    SET v_id_oferta = LAST_INSERT_ID();

    INSERT INTO auditoria_evento (
        tabla_afectada,
        id_registro,
        accion,
        detalle,
        usuario_bd,
        fecha_evento
    )
    VALUES (
        'oferta',
        v_id_oferta,
        'INSERT',
        CONCAT('Oferta enviada mediante procedimiento al conductor ', p_id_driver),
        CURRENT_USER(),
        NOW()
    );

    COMMIT;

    SELECT v_id_oferta AS id_oferta_creada;
END//

-- 3. Aceptar una oferta

DROP PROCEDURE IF EXISTS sp_aceptar_oferta//

CREATE PROCEDURE sp_aceptar_oferta (
    IN p_id_oferta BIGINT
)
BEGIN
    DECLARE v_id_viaje BIGINT;
    DECLARE v_id_driver BIGINT;
    DECLARE v_estado_oferta VARCHAR(30);
    DECLARE v_estado_viaje VARCHAR(30);
    DECLARE v_driver_asignado BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM oferta
        WHERE id_oferta = p_id_oferta
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La oferta indicada no existe';
    END IF;

    SELECT id_viaje, id_driver, estado_oferta
    INTO v_id_viaje, v_id_driver, v_estado_oferta
    FROM oferta
    WHERE id_oferta = p_id_oferta
    FOR UPDATE;

    IF v_estado_oferta <> 'PENDIENTE' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solo se pueden aceptar ofertas pendientes';
    END IF;

    SELECT estado, id_driver_asignado
    INTO v_estado_viaje, v_driver_asignado
    FROM viaje
    WHERE id_viaje = v_id_viaje
    FOR UPDATE;

    IF v_estado_viaje <> 'SOLICITADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El viaje ya no está en estado SOLICITADO';
    END IF;

    IF v_driver_asignado IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El viaje ya tiene un conductor asignado';
    END IF;

    UPDATE oferta
    SET estado_oferta = 'ACEPTADA',
        fecha_respuesta = NOW()
    WHERE id_oferta = p_id_oferta;

    UPDATE oferta
    SET estado_oferta = 'RECHAZADA',
        fecha_respuesta = COALESCE(fecha_respuesta, NOW())
    WHERE id_viaje = v_id_viaje
      AND id_oferta <> p_id_oferta
      AND estado_oferta = 'PENDIENTE';

    UPDATE viaje
    SET id_driver_asignado = v_id_driver,
        estado = 'ACEPTADO',
        fecha_aceptacion = NOW()
    WHERE id_viaje = v_id_viaje;

    INSERT INTO auditoria_evento (
        tabla_afectada,
        id_registro,
        accion,
        detalle,
        usuario_bd,
        fecha_evento
    )
    VALUES (
        'viaje',
        v_id_viaje,
        'UPDATE',
        CONCAT('Viaje aceptado mediante procedimiento por el conductor ', v_id_driver),
        CURRENT_USER(),
        NOW()
    );

    COMMIT;

    SELECT
        v_id_viaje AS id_viaje,
        v_id_driver AS id_driver_asignado,
        'OFERTA_ACEPTADA' AS resultado;
END//


-- 4. Finalizar un viaje

DROP PROCEDURE IF EXISTS sp_finalizar_viaje//

CREATE PROCEDURE sp_finalizar_viaje (
    IN p_id_viaje BIGINT,
    IN p_distancia_km DECIMAL(8,2),
    IN p_duracion_min DECIMAL(8,2),
    IN p_importe_final DECIMAL(10,2)
)
BEGIN
    DECLARE v_estado_viaje VARCHAR(30);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM viaje
        WHERE id_viaje = p_id_viaje
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El viaje indicado no existe';
    END IF;

    SELECT estado
    INTO v_estado_viaje
    FROM viaje
    WHERE id_viaje = p_id_viaje
    FOR UPDATE;

    IF v_estado_viaje NOT IN ('ACEPTADO', 'EN_CURSO') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solo se pueden finalizar viajes ACEPTADOS o EN_CURSO';
    END IF;

    UPDATE viaje
    SET estado = 'FINALIZADO',
        fecha_inicio = COALESCE(fecha_inicio, NOW()),
        fecha_fin = NOW(),
        distancia_km = p_distancia_km,
        duracion_min = p_duracion_min,
        importe_final = p_importe_final
    WHERE id_viaje = p_id_viaje;

    INSERT INTO auditoria_evento (
        tabla_afectada,
        id_registro,
        accion,
        detalle,
        usuario_bd,
        fecha_evento
    )
    VALUES (
        'viaje',
        p_id_viaje,
        'UPDATE',
        'Viaje finalizado mediante procedimiento almacenado',
        CURRENT_USER(),
        NOW()
    );

    COMMIT;

    SELECT p_id_viaje AS id_viaje_finalizado;
END//


-- 5. Registrar una incidencia

DROP PROCEDURE IF EXISTS sp_registrar_incidencia//

CREATE PROCEDURE sp_registrar_incidencia (
    IN p_id_viaje BIGINT,
    IN p_id_usuario_reporta BIGINT,
    IN p_tipo_incidencia VARCHAR(50),
    IN p_descripcion VARCHAR(255)
)
BEGIN
    DECLARE v_id_incidencia BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM viaje
        WHERE id_viaje = p_id_viaje
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El viaje indicado no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM usuario
        WHERE id_usuario = p_id_usuario_reporta
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario que reporta la incidencia no existe';
    END IF;

    INSERT INTO incidencia (
        id_viaje,
        id_usuario_reporta,
        tipo_incidencia,
        descripcion,
        estado_incidencia,
        fecha_reporte,
        fecha_resolucion
    )
    VALUES (
        p_id_viaje,
        p_id_usuario_reporta,
        p_tipo_incidencia,
        p_descripcion,
        'ABIERTA',
        NOW(),
        NULL
    );

    SET v_id_incidencia = LAST_INSERT_ID();

    INSERT INTO auditoria_evento (
        tabla_afectada,
        id_registro,
        accion,
        detalle,
        usuario_bd,
        fecha_evento
    )
    VALUES (
        'incidencia',
        v_id_incidencia,
        'INSERT',
        'Incidencia registrada mediante procedimiento almacenado',
        CURRENT_USER(),
        NOW()
    );

    COMMIT;

    SELECT v_id_incidencia AS id_incidencia_creada;
END//

DELIMITER ;