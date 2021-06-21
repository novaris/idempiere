\o logs/NM_Service_Object_V.log
/* Create View */
\qecho 'Create View NM_Service_Object_V';
DROP VIEW IF EXISTS NM_Service_Object_V;

CREATE OR REPLACE VIEW NM_Service_Object_V
AS
   SELECT DISTINCT a.A_Asset_ID AS NM_Service_Object_V_ID,
          a.A_Asset_ID,
          a.AD_Client_ID,
          a.AD_Org_ID,
          a.Created,
          a.CreatedBy,
          a.Updated,
          a.UpdatedBy,
          a.Value,
          a.Name,
          a.Description,
          a.Help,
          a.M_Product_ID,
          a.SerNo,
          a.IsOwned,
          a.LocationComment,
          a.C_BPartner_ID,
          a.AD_User_ID,
          a.M_AttributeSetInstance_ID,
          a.C_Project_ID,
          a.Manufacturer,
          a.ManufacturedYear,
          l.Nav_Sens_Data->s.SensorKey AS Nav_Button_Status,
          ST_Distance_Sphere(ST_SetSRID(ST_Point(l.Nav_Longitude, l.Nav_Latitude), 4326),
          ST_SetSRID(ST_Point(l1.Nav_Longitude, l1.Nav_Latitude), 4326))/1000.0 AS Distance,
          s1.NM_Module_ID AS NM_Module_Client,
          s1.NM_Module_ID AS NM_Module_Client_ID,
          m.IsActive,
          'https://static-maps.yandex.ru/1.x/?&l=map,trf&lang=ru_RU&pt='||l.Nav_Longitude||','||l.Nav_Latitude||',pm2am~'||l1.Nav_Longitude||','||l1.Nav_Latitude||',pm2bm' AS Url
     FROM A_Asset a
     JOIN NM_Module m ON (a.A_Asset_ID = m.A_Asset_ID AND m.IsActive = 'Y')
     JOIN NM_Sensor s ON (m.NM_Module_ID = s.NM_Module_ID AND s.IsActive = 'Y' AND s.NM_Sensor_Type_ID = 6)
     JOIN NM_Nav_Data_Last l ON (l.NM_Module_ID = m.NM_Module_ID) -- AND l.Nav_Sens_Data->s.SensorKey = '0')
     JOIN NM_Sensor s1 ON (s1.IsActive = 'Y' AND s1.NM_Sensor_Type_ID = 5)
     JOIN NM_Nav_Data_Last l1 ON (l1.NM_Module_ID = s1.NM_Module_ID) -- AND l1.Nav_Sens_Data->s.SensorKey = '1')
     JOIN AD_User u ON u.AD_Client_ID = a.AD_Client_ID AND u.AD_Org_ID = a.AD_Org_ID AND u.IsActive = 'Y' 
     JOIN AD_User_Roles r ON u.AD_User_ID = r.AD_User_ID AND r.AD_Role_ID = 1000006 -- роль Диспетчер 
    WHERE a.IsActive = 'Y'
      AND m.IsActive = 'Y'
      AND s.IsActive = 'Y'
      AND a.A_Asset_Group_ID = 1000002 -- TODO требуется вынести в настройки!!!!
    ORDER BY distance
; 
ALTER TABLE NM_Service_Object_V
   OWNER TO adempiere;
