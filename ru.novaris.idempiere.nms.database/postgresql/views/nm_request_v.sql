\o logs/NM_Request_V.log
DROP VIEW IF EXISTS NM_Request_V;
/* Create View */
\qecho 'Create View NM_Request_V';
CREATE OR REPLACE VIEW NM_Request_V AS
   SELECT r1.AD_Org_ID
         ,r1.AD_Client_ID
         ,r1.R_Request_ID 
         ,r1.C_BPartner_ID
         ,r1.A_Asset_ID
         ,r1.AD_Org_ID AS AD_Org_New
     FROM R_Request r,
          R_Request r1,
          A_Asset a
    WHERE r.A_Asset_ID = a.A_Asset_ID
      AND r.R_Request_ID IS NOT NULL
      AND r.R_Request_ID =  r1.R_RequestRelated_ID
      AND r1.CloseDate IS NULL
      AND r1.IsActive = 'Y'      
    ;


/* Grants */
\qecho 'Grant NM_Request_V owner to adempiere';
ALTER VIEW NM_Request_V OWNER TO adempiere;
