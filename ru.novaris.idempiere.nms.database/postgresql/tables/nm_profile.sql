\o logs/NM_Profile.log
DROP TABLE IF EXISTS NM_Profile CASCADE;
/* Create Table */
\qecho 'Create Table NM_Profile';
CREATE TABLE NM_Profile
 (NM_Profile_ID				NUMERIC(10) NOT NULL
 ,Name						VARCHAR(60) NOT NULL
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,Created					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,Updatedby					NUMERIC(10)
 ,Description				VARCHAR(255)
 ,Help						VARCHAR(2000)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,C_Bpartner_ID				NUMERIC(10)
 ,M_AttributeSet_ID			NUMERIC(10)
 ,M_AttributeSetInstance_ID	NUMERIC(10)
 ,NM_Module_ID				NUMERIC(10)
 ,NM_Profile_UU				VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Profile_PKEY PRIMARY KEY (NM_Profile_ID)
 ) WITHOUT OIDS
;

\qecho 'Create Comments on NM_Profile';
COMMENT ON TABLE  NM_Profile IS 'Профили объектов';
COMMENT ON COLUMN NM_Profile.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Profile.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Profile.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Profile.Name IS 'Наименование';
COMMENT ON COLUMN NM_Profile.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Profile.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Profile.Description IS 'Описание';
COMMENT ON COLUMN NM_Profile.Help IS 'Подсказка';

/* Create Indexes */

\qecho 'Create Indexes on NM_Profile';
CREATE INDEX NM_Profile_IsActive_IDX ON NM_Profile (IsActive);
CREATE INDEX NM_Profile_AD_Client_IDX ON NM_Profile (AD_Client_ID);
CREATE INDEX NM_Profile_AD_Org_IDX ON NM_Profile (AD_Org_ID);
CREATE INDEX NM_Profile_C_Bpartner_IDX ON NM_Profile (C_Bpartner_ID);
CREATE INDEX NM_Profile_NM_Module_IDX ON NM_Profile (NM_Module_ID);
CREATE INDEX NM_Profile_M_AttributeSetInstance_IDX ON NM_Profile (M_AttributeSetInstance_ID);
CREATE INDEX NM_Profile_Name_IDX ON NM_Profile (Name);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Profile
	ADD CONSTRAINT NM_Profile_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Profile
	ADD CONSTRAINT NM_Profile_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for C_Bpartner';
ALTER TABLE NM_Profile
	ADD CONSTRAINT NM_Profile_C_Bpartner_FK FOREIGN KEY (C_Bpartner_ID)
	REFERENCES C_Bpartner (C_Bpartner_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Module'
ALTER TABLE NM_Profile
    ADD CONSTRAINT NM_Profile_NM_Module_FK FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for M_AttributeSetInstance';
ALTER TABLE NM_Profile
	ADD CONSTRAINT NM_Profile_M_AttributeSetInstance_FK FOREIGN KEY (M_AttributeSetInstance_ID)
	REFERENCES m_attributesetinstance (M_AttributeSetInstance_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Profile 
  ADD CONSTRAINT NM_Profile_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));
/* Create Sequences

\qecho 'Create Sequence NM_Profile_SEQ';
CREATE SEQUENCE NM_Profile_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Profile_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Profile owner to adempiere';
ALTER TABLE NM_Profile OWNER TO adempiere;
