\o logs/NM_Service_Provider_V.log
/* Create View */
\qecho 'Create View NM_Service_Provider_V';
DROP VIEW IF EXISTS NM_Service_Provider_V;

CREATE OR REPLACE VIEW NM_Service_Provider_V AS 
SELECT ROW_NUMBER() OVER(ORDER BY s.NM_Module_ID, s1.NM_Module_ID, p.M_Product_ID)  AS NM_Service_Provider_V_ID
      ,ro.AD_User_ID
      ,u.AD_Org_ID
      ,u.AD_Client_ID
      ,u.C_BPartner_ID
      ,p.M_Product_ID
      ,ro.AD_Role_ID -- определяем снаружи
      ,p.IsActive
      ,bl.C_BPartner_Location_ID
      ,u.Phone
      ,u.Name AS Uname
      ,u.Email
      ,a.Name
      ,s.NM_Module_ID
      ,s1.NM_Module_ID AS NM_Module_Client_ID
      ,a.A_Asset_ID
  FROM M_Product p 
  JOIN M_Product_PO po ON p.M_Product_ID = po.M_Product_ID AND po.IsActive = 'Y' -- ищем диспетчера услуги
  JOIN C_BPartner bp ON po.C_BPartner_ID = bp.C_BPartner_ID AND bp.IsActive = 'Y'
  JOIN AD_User u ON u.C_BPartner_ID = bp.C_BPartner_ID AND u.IsActive = 'Y'
  JOIN AD_User_Roles ro ON ro.AD_User_ID = u.AD_User_ID AND ro.IsActive = 'Y'
  JOIN C_BPartner_Location bl ON bl.C_BPartner_ID = bp.C_BPartner_ID  AND ro.IsActive = 'Y' AND ispayfrom = 'Y'
  JOIN A_Asset a ON u.AD_Client_ID = a.AD_Client_ID AND u.AD_Org_ID = a.AD_Org_ID AND u.IsActive = 'Y'
  JOIN NM_Module m ON a.A_Asset_ID = m.A_Asset_ID AND m.IsActive = 'Y'
  JOIN NM_Sensor s ON m.NM_module_id = s.NM_Module_ID AND s.IsActive = 'Y' AND s.NM_Sensor_Type_ID = 6::numeric
  JOIN NM_Nav_Data_Last l ON l.NM_Module_ID = m.NM_Module_ID AND (l.Nav_Sens_Data -> s.SensorKey::text) = '0'
  JOIN NM_Sensor s1 ON s1.IsActive = 'Y' AND s1.NM_Sensor_Type_ID = 5::numeric
  JOIN NM_Nav_Data_Last l1 ON l1.NM_Module_ID = s1.NM_Module_ID AND (l1.Nav_Sens_Data -> s1.SensorKey::text) = '1'
 WHERE p.IsActive = 'Y' 
 ORDER BY st_distance_sphere(st_setsrid(st_point(l.Nav_Longitude, l.Nav_Latitude), 4326), st_setsrid(st_point(l1.nav_longitude, l1.nav_latitude), 4326))
;
ALTER TABLE NM_Service_Provider_V
   OWNER TO adempiere;
;
