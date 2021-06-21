\o logs/NM_Attribute.log
DROP TABLE IF EXISTS NM_Attribute CASCADE;
/* Create Table */
\qecho 'Create Table NM_Attribute';
CREATE TABLE NM_Attribute
 (NM_Attribute_ID				NUMERIC(10) NOT NULL
 ,Name						VARCHAR(60) NOT NULL
 ,SValue					VARCHAR(1023)
 ,NValue					NUMERIC
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,AttributeValueType		CHAR(1) DEFAULT 'S' NOT NULL
 ,Created					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,Updatedby					NUMERIC(10) NOT NULL 
 ,Description				VARCHAR(255)
 ,Help						VARCHAR(2000)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,NM_Attribute_UU			VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Attribute_PKEY PRIMARY KEY (NM_Attribute_ID)
 ) WITHOUT OIDS
;

\qecho 'Create Comments on NM_Attribute';
COMMENT ON TABLE  NM_Attribute IS 'Атрибуты профиля';
COMMENT ON COLUMN NM_Attribute.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Attribute.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Attribute.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Attribute.Name IS 'Наименование';
COMMENT ON COLUMN NM_Attribute.AttributeValueType IS 'Тип атрибута';
COMMENT ON COLUMN NM_Attribute.SValue IS 'Значение стоковое';
COMMENT ON COLUMN NM_Attribute.NValue IS 'Значение цифровое';
COMMENT ON COLUMN NM_Attribute.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Attribute.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Attribute.Description IS 'Описание';
COMMENT ON COLUMN NM_Attribute.Help IS 'Подсказка';

/* Create Indexes */

\qecho 'Create Indexes on NM_Attribute';
CREATE INDEX NM_Attribute_IsActive_IDX ON NM_Attribute (IsActive);
CREATE INDEX NM_Attribute_AD_Client_IDX ON NM_Attribute (AD_Client_ID);
CREATE INDEX NM_Attribute_AD_Org_IDX ON NM_Attribute (AD_Org_ID);
CREATE INDEX NM_Attribute_Name_IDX ON NM_Attribute (Name);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Attribute
	ADD CONSTRAINT NM_Attribute_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Attribute
	ADD CONSTRAINT NM_Attribute_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Attribute 
  ADD CONSTRAINT NM_Attribute_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));
/* Create Sequences

\qecho 'Create Sequence NM_Attribute_SEQ';
CREATE SEQUENCE NM_Attribute_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Attribute_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Attribute owner to adempiere';
ALTER TABLE NM_Attribute OWNER TO adempiere;
