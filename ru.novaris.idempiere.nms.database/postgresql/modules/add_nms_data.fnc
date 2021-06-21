-- Function: add_nms_data(character varying, numeric, timestamp with time zone, double precision, double precision, numeric, numeric, double precision, double precision, double precision, hstore, numeric)

-- DROP FUNCTION add_nms_data(character varying, numeric, timestamp with time zone, double precision, double precision, numeric, numeric, double precision, double precision, double precision, hstore, numeric);

CREATE OR REPLACE FUNCTION add_nms_data (
   IN i_uid         CHARACTER VARYING,
   IN i_protocol    numeric,
   IN i_datetime    timestamp WITH TIME ZONE,
   IN i_latitude    DOUBLE PRECISION,
   IN i_longitude   DOUBLE PRECISION,
   IN i_status      numeric,
   IN i_satelites   numeric,
   IN i_sog         DOUBLE PRECISION,
   IN i_course      DOUBLE PRECISION,
   IN i_hgeo        DOUBLE PRECISION,
   IN i_sens        hstore,
   IN i_type        numeric)
   RETURNS int8
AS
$BODY$

DECLARE
   module_id    nm_module.nm_module_id%TYPE;
   n_rec        nm_nav_data.nav_id%TYPE;
   last_id      nm_nav_data_last.nav_id%TYPE;
   last_date    nm_nav_data_last.nav_datetime%TYPE;
   max_future   TIMESTAMP;
BEGIN
   SELECT n.nm_module_id
     INTO module_id
     FROM nm_module n
    WHERE n.datakey = i_uid AND n.nm_protocol_id = i_protocol;

   IF (module_id IS NULL)
   THEN
      RAISE EXCEPTION 'Несуществующий модуль. Указан код модуля: %, Протокол: %', i_uid, i_protocol
      USING HINT = 'Проверьте настройки модуля в системе.';
   END IF;

   SELECT nextval ('nav_seq')
     INTO n_rec;

   INSERT INTO nm_nav_data (nav_id,
                            nav_type,
                            nm_module_id,
                            nav_datetime,
                            nav_latitude,
                            nav_longitude,
                            nav_hgeo,
                            nav_status,
                            nav_satelites,
                            nav_sog,
                            nav_course,
                            nav_sens_data,
                            created)
        VALUES (n_rec,
                i_type,
                module_id,
                i_datetime,
                i_latitude,
                i_longitude,
                i_hgeo,
                i_status,
                i_satelites,
				i_sog,
                i_course,
                i_sens,
                now ());

   -- Обновим в таблице последней активности
   SELECT l.nav_id, l.nav_datetime
     INTO last_id, last_date
     FROM nm_nav_data_last l
    WHERE l.nm_module_id = module_id;

   max_future := current_timestamp + INTERVAL '1 HOURS';

   IF     last_id IS NOT NULL
      AND (i_datetime >= last_date AND i_datetime <= max_future)
   THEN
      UPDATE nm_nav_data_last
         SET nav_course = i_course,
             nav_datetime = i_datetime,
             nav_hgeo = i_hgeo,
             nav_latitude = i_latitude,
             nav_longitude = i_longitude,
             nav_nav_id = n_rec,
             updated = current_timestamp,
             nav_satelites = i_satelites,
             nav_status = i_status,
             nav_sog = i_sog,
             nav_type = i_type,
             nav_sens_data = i_sens
       WHERE nav_id = last_id;
   ELSIF last_id IS NOT NULL AND i_datetime > max_future
   THEN
      RAISE NOTICE 'Дата в будущем. Превышение более 1 часа: % Модуль: %',
      i_datetime, module_id;
   ELSIF last_id IS NOT NULL AND i_datetime < last_date
   THEN
      RAISE NOTICE 'Дата меньше дата в таблице последних данных. Дата пакета:  % Дата в таблице: %',
      i_datetime, last_date;
   ELSIF last_id IS NOT NULL
   THEN
      RAISE NOTICE 'Неверная дата: %', i_datetime;
   ELSE
      SELECT nextval ('navl_seq')
        INTO last_id;

      INSERT INTO nm_nav_data_last (nav_id,
                                    nav_nav_id,
                                    nav_type,
                                    nav_datetime,
                                    nav_latitude,
                                    nav_longitude,
                                    nav_hgeo,
                                    nav_status,
                                    nav_satelites,
                                    nav_sog,
                                    nav_course,
                                    nav_sens_data,
                                    ad_org_id,
                                    ad_client_id,
                                    nm_module_id,
                                    created,
                                    createdby,
                                    updated,
                                    updatedby)
           VALUES (last_id,
                   n_rec,
                   i_type,
                   i_datetime,
                   i_latitude,
                   i_longitude,
                   i_hgeo,
                   i_status,
                   i_satelites,
                   i_sog,
                   i_course,
                   i_sens,
                   0,
                   0,
                   module_id,
                   current_timestamp,
                   0,
                   current_timestamp,
                   0);
   END IF;

   RETURN n_rec;
END;
$BODY$
   LANGUAGE plpgsql
   VOLATILE
   COST 100;
ALTER FUNCTION add_nms_data(character varying, numeric, timestamp with time zone, double precision, double precision, numeric, numeric, double precision, double precision, double precision, hstore, numeric)
  OWNER TO adempiere;
