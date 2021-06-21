\o logs/NM_Sensor_Type.log
DROP TABLE IF EXISTS NM_Sensor_Type CASCADE;
/* Create Table */
\qecho 'Create Table NM_Sensor_Type';
CREATE TABLE NM_Sensor_Type
 (NM_Sensor_Type_ID			NUMERIC(10) NOT NULL
 ,Name						VARCHAR(60) NOT NULL
 ,Value						VARCHAR(40) NOT NULL
 ,Description				VARCHAR(255)
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,Created					TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP NOT NULL
 ,UpdatedBy					NUMERIC(10) NOT NULL
 ,Help						VARCHAR(2000)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,C_UOM_ID					NUMERIC(10) NOT NULL
 ,NM_Calibration_Type_ID	NUMERIC(10) NOT NULL
 ,NM_Sensor_Type_UU	VARCHAR(36) DEFAULT NULL 
 ,CONSTRAINT NM_Sensor_Type_PKEY PRIMARY KEY (NM_Sensor_Type_ID)
) WITHOUT OIDS;

\qecho 'Create Comments on NM_Sensor_Type';
COMMENT ON TABLE  NM_Sensor_Type IS 'Типы Датчиков';
COMMENT ON COLUMN NM_Sensor_Type.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Sensor_Type.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Sensor_Type.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Sensor_Type.Name IS 'Наименование типа';
COMMENT ON COLUMN NM_Sensor_Type.Value IS 'Ключ типа';
COMMENT ON COLUMN NM_Sensor_Type.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Sensor_Type.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Sensor_Type.Description IS 'Описание';
COMMENT ON COLUMN NM_Sensor_Type.Help IS 'Подсказка';
/* Create Indexes */

\qecho 'Create Indexes on NM_Sensor_Type';
CREATE INDEX NM_Sensor_Type_IsActive_IDX ON NM_Sensor_Type (IsActive);
CREATE INDEX NM_Sensor_Type_NM_Sensor_Type_IDX ON NM_Sensor_Type (NM_Sensor_Type_ID);
CREATE INDEX NM_Sensor_Type_NM_Calibration_Type_IDX ON NM_Sensor_Type (NM_Calibration_Type_ID);
CREATE INDEX NM_Sensor_Type_AD_Client_IDX ON NM_Sensor_Type (AD_Client_ID);
CREATE INDEX NM_Sensor_Type_AD_Org_IDX ON NM_Sensor_Type (AD_Org_ID);
CREATE INDEX NM_Sensor_Type_C_UOM_IDX ON NM_Sensor_Type (C_UOM_ID);
CREATE INDEX NM_Sensor_Type_Name_IDX ON NM_Sensor_Type (Name);
CREATE INDEX NM_Sensor_Type_Value_IDX ON NM_Sensor_Type (Value);

/* Create Foreign Keys */
\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Sensor_Type
	ADD CONSTRAINT NM_Sensor_Type_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Sensor_Type
	ADD CONSTRAINT NM_Sensor_Type_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for C_UOM'
ALTER TABLE NM_Sensor_Type
	ADD CONSTRAINT NM_Sensor_Type_C_UOM_FK FOREIGN KEY (C_UOM_ID)
	REFERENCES C_UOM (C_UOM_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Calibration_Type'
ALTER TABLE NM_Sensor_Type
	ADD CONSTRAINT NM_Sensor_Type_NM_Calibration_Type_FK FOREIGN KEY (NM_Calibration_Type_ID)
	REFERENCES NM_Calibration_Type (NM_Calibration_Type_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


\qecho 'Create check IsActive';
ALTER TABLE NM_Sensor_Type 
  ADD CONSTRAINT NM_Sensor_Type_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));

/* Grants */
\qecho 'Grant NM_Sensor_Type owner to adempiere';
ALTER TABLE NM_Sensor_Type OWNER TO adempiere;

