\o logs/NM_Sensor_Type_Trl.log
DROP TABLE IF EXISTS NM_Sensor_Type_Trl CASCADE;
/* Create Table */
\qecho 'Create Table NM_Sensor_Type_Trl';
CREATE TABLE NM_Sensor_Type_Trl
 (NM_Sensor_Type_ID			NUMERIC(10) NOT NULL
 ,Name						VARCHAR(60) NOT NULL
 ,Value						VARCHAR(40) NOT NULL
 ,Description				VARCHAR(255)
 ,Help						VARCHAR(2000)
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,IsTranslated				CHAR(1) DEFAULT 'N' NOT NULL
 ,Created					TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP NOT NULL
 ,UpdatedBy					NUMERIC(10) NOT NULL
 ,AD_Language				VARCHAR(6) NOT NULL
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,NM_Sensor_Type_Trl_UU	VARCHAR(36) DEFAULT NULL 
 ,CONSTRAINT NM_Sensor_Type_Trl_PKEY PRIMARY KEY (NM_Sensor_Type_ID, AD_Language)
) WITHOUT OIDS;

\qecho 'Create Comments on NM_Sensor_Type_Trl';
COMMENT ON TABLE  NM_Sensor_Type_Trl IS 'Типы Датчиков';
COMMENT ON COLUMN NM_Sensor_Type_Trl.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Sensor_Type_Trl.IsTranslated IS 'Запись переведена?';
COMMENT ON COLUMN NM_Sensor_Type_Trl.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Sensor_Type_Trl.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Sensor_Type_Trl.Name IS 'Наименование типа';
COMMENT ON COLUMN NM_Sensor_Type_Trl.Value IS 'Ключ типа';
COMMENT ON COLUMN NM_Sensor_Type_Trl.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Sensor_Type_Trl.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Sensor_Type_Trl.Description IS 'Описание';
COMMENT ON COLUMN NM_Sensor_Type_Trl.Help IS 'Подсказка';
/* Create Indexes */

\qecho 'Create Indexes on NM_Sensor_Type_Trl';
CREATE INDEX NM_Sensor_Type_Trl_IsActive_IDX ON NM_Sensor_Type_Trl (IsActive);
CREATE INDEX NM_Sensor_Type_Trl_IsTranslated ON NM_Sensor_Type_Trl (IsTranslated);
CREATE INDEX NM_Sensor_Type_Trl_AD_Client_IDX ON NM_Sensor_Type_Trl (AD_Client_ID);
CREATE INDEX NM_Sensor_Type_Trl_AD_Org_IDX ON NM_Sensor_Type_Trl (AD_Org_ID);
CREATE INDEX NM_Sensor_Type_Trl_Name_IDX ON NM_Sensor_Type_Trl (Name);
CREATE INDEX NM_Sensor_Type_Trl_Value_IDX ON NM_Sensor_Type_Trl (Value);

/* Create Foreign Keys */
\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Sensor_Type_Trl
	ADD CONSTRAINT NM_Sensor_Type_Trl_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Sensor_Type_Trl
	ADD CONSTRAINT NM_Sensor_Type_Trl_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Sensor_Type'
ALTER TABLE NM_Sensor_Type_Trl
	ADD CONSTRAINT NM_Sensor_Type_Trl_NM_Sensor_Type_FK FOREIGN KEY (NM_Sensor_Type_ID)
	REFERENCES NM_Sensor_Type (NM_Sensor_Type_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Sensor_Type_Trl 
  ADD CONSTRAINT NM_Sensor_Type_Trl_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));

\qecho 'Create check IsTranslated';
ALTER TABLE NM_Sensor_Type_Trl 
  ADD CONSTRAINT NM_Sensor_Type_Trl_IsTranslated_CHK CHECK (IsTranslated = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));


/* Grants */
\qecho 'Grant NM_Sensor_Type_Trl owner to adempiere';
ALTER TABLE NM_Sensor_Type_Trl OWNER TO adempiere;

