\o logs/NM_Attribute_Trl.log
DROP TABLE IF EXISTS NM_Attribute_Trl CASCADE;
/* Create Table */
\qecho 'Create Table NM_Attribute_Trl';
CREATE TABLE NM_Attribute_Trl
 (NM_Attribute_ID			NUMERIC(10) NOT NULL
 ,Name						VARCHAR(60) NOT NULL
 ,AD_Language				VARCHAR(6) NOT NULL
 ,Created					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,Updatedby					NUMERIC(10) NOT NULL 
 ,Description				VARCHAR(255)
 ,Help						VARCHAR(2000)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,NM_Attribute_Trl_UU		VARCHAR(36) DEFAULT NULL
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,IsTranslated				CHAR(1) DEFAULT 'N' NOT NULL
 ,CONSTRAINT NM_Attribute_Trl_PKEY PRIMARY KEY (NM_Attribute_ID, AD_Language)
 ) WITHOUT OIDS
;

\qecho 'Create Comments on NM_Attribute_Trl';
COMMENT ON TABLE  NM_Attribute_Trl IS 'Атрибуты профиля';
COMMENT ON COLUMN NM_Attribute_Trl.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Attribute_Trl.IsTranslated IS 'Переведено?';
COMMENT ON COLUMN NM_Attribute_Trl.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Attribute_Trl.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Attribute_Trl.Name IS 'Наименование';
COMMENT ON COLUMN NM_Attribute_Trl.AD_Language IS 'Язык';
COMMENT ON COLUMN NM_Attribute_Trl.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Attribute_Trl.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Attribute_Trl.Description IS 'Описание';
COMMENT ON COLUMN NM_Attribute_Trl.Help IS 'Подсказка';

/* Create Indexes */

\qecho 'Create Indexes on NM_Attribute_Trl';
CREATE INDEX NM_Attribute_Trl_IsActive_IDX ON NM_Attribute_Trl (IsActive);
CREATE INDEX NM_Attribute_Trl_AD_Client_IDX ON NM_Attribute_Trl (AD_Client_ID);
CREATE INDEX NM_Attribute_Trl_AD_Org_IDX ON NM_Attribute_Trl (AD_Org_ID);
CREATE INDEX NM_Attribute_Trl_Name_IDX ON NM_Attribute_Trl (Name);
CREATE INDEX NM_Attribute_Trl_AD_Language_IDX ON NM_Attribute_Trl (AD_Language);
CREATE INDEX NM_Attribute_Trl_NM_Attribute_IDX ON NM_Attribute_Trl (NM_Attribute_ID);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Attribute_Trl
	ADD CONSTRAINT NM_Attribute_Trl_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Attribute_Trl
	ADD CONSTRAINT NM_Attribute_Trl_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Language';
ALTER TABLE NM_Attribute_Trl
	ADD CONSTRAINT NM_Attribute_Trl_AD_Language_FK FOREIGN KEY (AD_Language)
	REFERENCES AD_Language (AD_Language)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Attribute';
ALTER TABLE NM_Attribute_Trl
	ADD CONSTRAINT NM_Attribute_Trl_NM_Attribute_FK FOREIGN KEY (NM_Attribute_ID)
	REFERENCES NM_Attribute (NM_Attribute_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Attribute_Trl 
  ADD CONSTRAINT NM_Attribute_Trl_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));

\qecho 'Create check IsTranslated';
ALTER TABLE NM_Attribute_Trl 
  ADD CONSTRAINT NM_Attribute_Trl_IsTranslated_CHK CHECK (IsTranslated = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));
/* Create Sequences

\qecho 'Create Sequence NM_Attribute_Trl_SEQ';
CREATE SEQUENCE NM_Attribute_Trl_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Attribute_Trl_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Attribute_Trl owner to adempiere';
ALTER TABLE NM_Attribute_Trl OWNER TO adempiere;
