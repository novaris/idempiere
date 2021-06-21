\o logs/NM_Event_Button_V.log
DROP VIEW IF EXISTS NM_Event_Button_V;
/* Create View */
\qecho 'Create Table NM_Event_Button_V';


CREATE OR REPLACE VIEW NM_Event_Button_V AS
 SELECT DISTINCT m.nm_module_id,
    a.a_asset_id,
    a.ad_user_id,
    a.ad_org_id,
    a.ad_client_id,
    a.c_bpartner_id,
    a.name,
    u.phone,
    l.nav_sens_data -> s.sensorkey::text AS nav_sens_data,
    l.nav_datetime,
    l.created,
    l.createdby,
    l.updated,
    l.updatedby,
    l.nav_id
   FROM nm_module m
     JOIN nm_sensor s 
       ON m.nm_module_id = s.nm_module_id 
      AND s.isactive = 'Y'::bpchar 
      AND s.nm_sensor_type_id = 5::numeric
     JOIN a_asset a 
       ON a.a_asset_id = m.a_asset_id 
      AND a.ad_user_id IS NOT NULL 
      AND a.isactive = 'Y'::bpchar 
      AND a.ad_user_id IS NOT NULL
     JOIN ad_user u 
       ON a.ad_user_id = u.ad_user_id
     JOIN nm_nav_data_last l 
       ON l.nm_module_id = m.nm_module_id 
      AND (exist(l.nav_sens_data, s.sensorkey::text) AND (l.nav_sens_data -> s.sensorkey::text) = '1'::text) 
      AND l.nav_datetime > (now() - '01:00:00'::interval hour)
  WHERE m.isactive = 'Y'::bpchar
    AND NOT (EXISTS 
       (SELECT '1'::text AS text
          FROM r_request r
         WHERE r.a_asset_id = a.a_asset_id 
           AND r.closedate IS NULL 
           AND r.r_requestrelated_id IS NULL 
           AND r.isactive = 'Y'::bpchar 
           AND r.processed = 'N'::bpchar 
           AND r.r_requesttype_id = 100000::numeric
        UNION
        SELECT '1'::text AS text
          FROM r_request r
              ,r_request r1
          WHERE r.a_asset_id = a.a_asset_id 
            AND r.r_request_id = r1.r_requestrelated_id 
            AND r1.closedate IS NULL 
            AND r1.isactive = 'Y'::bpchar 
            AND r1.processed = 'N'::bpchar 
            AND r.r_requesttype_id = 100000::numeric)
       );


/* Grants */
\qecho 'Grant NM_Event_Button_V owner to adempiere';
ALTER VIEW NM_Event_Button_V OWNER TO adempiere;
