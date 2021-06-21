-- Function: get_color_status(character varying, numeric, timestamp)

-- DROP FUNCTION get_color_status(character varying, numeric, timestamp);

CREATE OR REPLACE FUNCTION get_color_status (
   IN i_button_status        CHARACTER VARYING,
   IN i_request_status       NUMERIC,
   IN i_nav_timestamp        TIMESTAMP)
   RETURNS int8
AS
$BODY$
DECLARE
   /*
   6 - Ораньжевый
   5 - Синий
   4 - Жёлтый
   3 - Фиолетовый
   2 - Светло серый
   1 - Зелёный
   0 - Красный
  -1 - Прозрачный
   */
   n_color    int8;
BEGIN
   IF (i_nav_timestamp < (now() - INTERVAL '1 HOUR')) THEN
     n_color := 0; -- красный
   ELSIF (i_button_status IS NULL) THEN
     n_color := -1; -- нет цвета
   ELSIF (i_button_status = '0') THEN
     IF (i_request_status IS NULL) THEN
        n_color := 1;
     ELSIF (i_request_status IN (100500, 100550)) THEN
        n_color := 6;
     ELSIF (i_request_status IN (100375, 100400, 100450)) THEN
        n_color := 4;
     END IF;
   ELSIF (i_button_status = '1') THEN
     IF (i_request_status IS NULL) THEN
        n_color := 2;
     ELSIF (i_request_status IN (100450, 100500)) THEN
        n_color := 5;
     ELSIF (i_request_status IN (100550, 100600)) THEN
        n_color := 3;
     END IF;
   ELSE
     n_color := 0;
   END IF;
   RETURN n_color;
END;
$BODY$
   LANGUAGE plpgsql
   VOLATILE
   COST 100;
ALTER FUNCTION get_color_status(character varying, numeric, timestamp)
  OWNER TO adempiere;
