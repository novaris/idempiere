\qecho 'Create View NM_Service_Request_V';
\o logs/NM_Service_Request_V.log

DROP VIEW IF EXISTS NM_Service_Request_V;
CREATE OR REPLACE VIEW NM_Service_Request_V AS 
   SELECT DISTINCT r.R_Request_ID,
          DENSE_RANK() OVER(ORDER BY u1.AD_User_ID, r.R_Request_ID) AS NM_Service_Request_V_ID,
          r.Summary AS Summary,
          r.AD_Client_ID,
          a.AD_Org_ID,
          r.C_BPartner_ID,
          r.CreatedBy,
          r.Created,
          r.UpdatedBy,
          r.Updated,
          r.IsActive,
          r1.Summary AS S_Summary,
          r1.C_BPartner_ID AS S_BPartner_ID,
          r1.A_Asset_ID,
          b.Name AS Name,
          u1.Name AS uName,
          u1.Phone AS Phone,
          us.Phone AS Phone1,
          dp.Phone AS Phone2,
          a1.SerNO AS SerNO,
          a1.Name AS aName,
          p1.Name AS pName,
          p1.Value AS pValue,
          n1.Nav_Datetime,
          n1.Nav_Latitude,
          n1.Nav_Longitude,
          a.AD_User_ID,
          r.A_Asset_ID AS NM_Service_Object_V_ID,
          m.NM_Module_ID,
          m1.NM_Module_ID AS S_Module_ID,
          r.R_RequestRelated_ID,
          r.Processed,
          r.DateNextAction,
          r.R_Status_ID,
          (SELECT p.C_Project_ID 
             FROM C_Project p
             JOIN C_ProjectLine pl ON (pl.C_Project_ID = p.C_Project_ID) 
            WHERE now() BETWEEN COALESCE(p.DateContract,now()) AND COALESCE(p.DateFinish,now()) 
              AND r1.C_BPartner_ID = p.C_BPartner_ID -- требуется тестирование и возможно доработка
              AND r.M_Product_ID = pl.M_Product_ID
            ORDER BY p.DateContract DESC
            LIMIT 1) AS C_Project_ID,
          get_color_status(n.Nav_Sens_Data->s.SensorKey, r.R_Status_ID, n.Nav_DateTime) AS Nav_Color
     FROM R_Request r1
          INNER JOIN R_Request r ON (r.R_RequestRelated_ID = r1.R_Request_ID)
          LEFT JOIN A_Asset a ON (a.A_Asset_ID = r.A_Asset_ID)
          LEFT JOIN C_BPartner b ON (a.C_BPartner_ID = b.C_BPartner_ID)
          INNER JOIN A_Asset a1 ON (r1.A_Asset_ID = a1.A_Asset_ID)
          INNER JOIN AD_User u1 ON (a1.AD_User_ID = u1.AD_User_ID)
          INNER JOIN M_Product p1 ON (p1.M_Product_ID = a1.M_Product_ID)
          INNER JOIN NM_Module m1 ON (m1.A_Asset_ID = a1.A_Asset_ID)
          INNER JOIN NM_Nav_Data_Last n1 ON (m1.NM_Module_ID = n1.NM_Module_ID)
          LEFT JOIN M_Product p ON (p.M_Product_ID = a.M_Product_ID)
          LEFT JOIN NM_Module m ON (m.A_Asset_ID = a.A_Asset_ID)
          LEFT JOIN NM_Nav_Data_Last n ON (m.NM_Module_ID = n.NM_Module_ID)
          INNER JOIN NM_Sensor s ON (m.NM_Module_ID = s.NM_Module_ID AND s.IsActive = 'Y' AND s.NM_Sensor_Type_ID = 6)
          LEFT JOIN AD_User us ON (a.AD_User_ID = us.AD_User_ID)
          INNER JOIN AD_User u ON (u.C_BPartner_ID = r.C_BPartner_ID AND u.IsActive = 'Y')
          INNER JOIN AD_User dp ON (dp.AD_User_ID = r.AD_User_ID AND dp.IsActive = 'Y');

CREATE OR REPLACE FUNCTION Update_NM_Service_Request_V_TR()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $TRIGGER$
   DECLARE
      V_Processed    R_Request.Processed%TYPE;

   BEGIN
      IF TG_OP = 'INSERT' THEN
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       -- Определим финальный статус
       SELECT 'Y' 
         INTO V_Processed 
         FROM R_Status 
        WHERE R_Status_ID = NEW.R_Status_ID 
          AND IsClosed = 'Y' 
          AND IsFinalClose = 'Y';
       UPDATE R_Request 
          SET A_Asset_ID=NEW.NM_Service_Object_V_ID
             ,Updated=NEW.Updated
             ,UpdatedBy=NEW.UpdatedBy
             ,R_Status_ID=NEW.R_Status_ID
             ,Processed=COALESCE(V_Processed, Processed)
        WHERE R_Request_ID=OLD.R_Request_ID;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM R_Request WHERE R_Request_ID=OLD.R_Request_ID;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$TRIGGER$;


CREATE TRIGGER NM_Service_Request_V_TR
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      NM_Service_Request_V FOR EACH ROW EXECUTE PROCEDURE Update_NM_Service_Request_V_TR();

ALTER TABLE nm_service_request_v
   OWNER TO adempiere;
