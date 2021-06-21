\o logs/NM_Service_Object_Status_V.log
/* Create View */
\qecho 'Create View NM_Service_Object_Status_V';
DROP VIEW IF EXISTS NM_Service_Object_Status_V;

CREATE OR REPLACE VIEW NM_Service_Object_Status_V
AS
   SELECT DISTINCT a.A_Asset_ID AS NM_Service_Object_Status_V_ID,
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
          m.IsActive,
          u.Phone,
          u.Name AS uName,
          m.NM_Module_ID,
          'https://static-maps.yandex.ru/1.x/?&l=map,trf&lang=ru_RU&z=16&pt='||l.Nav_Longitude||','||l.Nav_Latitude||',pm2am' AS Url,
          r.NM_Service_Request_V_ID,
          r.R_Status_ID,
          get_color_status(l.Nav_Sens_Data->s.SensorKey, r.R_Status_ID, l.Nav_DateTime) AS Nav_Color,
          l.Nav_DateTime         
     FROM A_Asset a
     INNER JOIN NM_Module m ON (a.A_Asset_ID = m.A_Asset_ID AND m.IsActive = 'Y')
     INNER JOIN NM_Sensor s ON (m.NM_Module_ID = s.NM_Module_ID AND s.IsActive = 'Y' AND s.NM_Sensor_Type_ID = 6)
     INNER JOIN NM_Nav_Data_Last l ON (l.NM_Module_ID = m.NM_Module_ID)
     INNER JOIN AD_User u ON (a.AD_User_ID = u.AD_User_ID)
      LEFT JOIN NM_Service_Request_V r ON (r.NM_Service_Object_V_ID = a.A_Asset_ID AND r.IsActive = 'Y' AND r.Processed = 'N')
    WHERE a.IsActive = 'Y'
      AND m.IsActive = 'Y'
      AND s.IsActive = 'Y'
      AND a.A_Asset_Group_ID = 1000002 -- TODO требуется вынести в настройки!!!!
; 
ALTER TABLE NM_Service_Object_Status_V
   OWNER TO adempiere;
