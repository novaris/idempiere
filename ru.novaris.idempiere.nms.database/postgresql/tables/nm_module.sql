\o logs/NM_Module.log
DROP TABLE IF EXISTS NM_Module CASCADE;
/* Create Table */
\qecho 'Create Table NM_Module';
CREATE TABLE NM_Module
 (NM_Module_ID				NUMERIC(10) NOT NULL
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,Created					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,Updatedby					NUMERIC(10)
 ,Name						VARCHAR(60) NOT NULL
 ,Description				VARCHAR(255)
 ,Help						VARCHAR(2000)
 ,GuaranteeDate				TIMESTAMP
 ,ModuleServiceDate			TIMESTAMP
 ,ModuleLogin				VARCHAR(30)
 ,ModulePasswd				VARCHAR(512)
 ,DataKey					VARCHAR(30) NOT NULL
 ,DataSig					VARCHAR(30)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,AD_User_ID				NUMERIC(10) NOT NULL
 ,C_Project_ID				NUMERIC(10) NOT NULL
 ,C_Bpartner_ID				NUMERIC(10) NOT NULL
 ,M_AttributeSetInstance_ID	NUMERIC(10) NOT NULL
 ,M_Product_ID				NUMERIC(10) NOT NULL
 ,A_Asset_ID				NUMERIC(10)
 ,NM_Protocol_ID			NUMERIC(10) NOT NULL
 ,NM_Module_UU				VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Module_PKEY	PRIMARY KEY (NM_Module_ID)
 ) WITHOUT OIDS
;

\qecho 'Create Comments on NM_Module';
COMMENT ON TABLE  NM_Module IS 'Модули мониторинга';
COMMENT ON COLUMN NM_Module.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Module.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Module.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Module.Name IS 'Наименование объекта';
COMMENT ON COLUMN NM_Module.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Module.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Module.Description IS 'Описание';
COMMENT ON COLUMN NM_Module.Help IS 'Подсказка';
COMMENT ON COLUMN NM_Module.GuaranteeDate IS 'Гарантийная дата';
COMMENT ON COLUMN NM_Module.ModuleServiceDate IS 'Дата последнего обслуживания';
COMMENT ON COLUMN NM_Module.ModuleLogin IS 'Логин пользователя для управления терминалом';
COMMENT ON COLUMN NM_Module.ModulePasswd IS 'Пароль пользователя для управления терминалом';
COMMENT ON COLUMN NM_Module.DataKey IS 'Ключ пакета данных (определяет принадлежность модуля)';
COMMENT ON COLUMN NM_Module.DataSig IS 'Сигнатура проверки данных';

/* Create Indexes */

\qecho 'Create Indexes on NM_Module';
CREATE INDEX NM_Module_IsActive_IDX ON NM_Module (IsActive);
CREATE INDEX NM_Module_AD_User_IDX ON NM_Module (AD_User_ID);
CREATE INDEX NM_Module_AD_Client_IDX ON NM_Module (AD_Client_ID);
CREATE INDEX NM_Module_AD_Org_IDX ON NM_Module (AD_Org_ID);
CREATE INDEX NM_Module_C_Bpartner_IDX ON NM_Module (C_Bpartner_ID);
CREATE INDEX NM_Module_M_Product_IDX ON NM_Module (M_Product_ID);
CREATE INDEX NM_Module_M_AttributeSetInstance_IDX ON NM_Module (M_AttributeSetInstance_ID);
CREATE INDEX NM_Module_Name_IDX ON NM_Module (Name);
CREATE INDEX NM_Module_NM_Protocol_IDX ON NM_Module (NM_Protocol_ID);
CREATE INDEX NM_Module_DataKey_IDX ON NM_Module (DataKey);
CREATE INDEX NM_Module_A_Asset_IDX ON NM_Module (A_Asset_ID);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_User';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_AD_User_FK FOREIGN KEY (AD_User_ID)
	REFERENCES AD_User (AD_User_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for C_Bpartner';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_C_Bpartner_FK FOREIGN KEY (C_Bpartner_ID)
	REFERENCES C_Bpartner (C_Bpartner_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for C_Project';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_C_Project_FK FOREIGN KEY (C_Project_ID)
	REFERENCES C_Project (C_Project_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for M_Product'
ALTER TABLE NM_Module
    ADD CONSTRAINT NM_Module_M_Product_FK FOREIGN KEY (M_Product_ID)
	REFERENCES M_Product (M_Product_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Protocol';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_NM_Protocol_FK FOREIGN KEY (NM_Protocol_ID)
	REFERENCES NM_Protocol (NM_Protocol_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for M_AttributeSetInstance';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_M_AttributeSetInstance_FK FOREIGN KEY (M_AttributeSetInstance_ID)
	REFERENCES M_AttributeSetInstance (M_AttributeSetInstance_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for A_Asset';
ALTER TABLE NM_Module
	ADD CONSTRAINT NM_Module_A_Asset_FK FOREIGN KEY (A_Asset_ID)
	REFERENCES A_Asset (A_Asset_ID)
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Module 
  ADD CONSTRAINT NM_Module_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));
/* Create Sequences

\qecho 'Create Sequence NM_Module_SEQ';
CREATE SEQUENCE NM_Module_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Module_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Module owner to adempiere';
ALTER TABLE NM_Module OWNER TO adempiere;
