\o logs/NM_Sensor.log
DROP TABLE IF EXISTS NM_Sensor CASCADE;
/* Create Table */
\qecho 'Create Table NM_Sensor';
CREATE TABLE NM_Sensor
 (NM_Sensor_ID				NUMERIC(10) NOT NULL
 ,Name						VARCHAR(30) NOT NULL
 ,SensorKey					VARCHAR(30) NOT NULL
 ,Description				VARCHAR(255)
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,Created					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,UpdatedBy					NUMERIC(10) NOT NULL
 ,Help						VARCHAR(2000)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,M_Product_ID				NUMERIC(10) NOT NULL
 ,M_AttributeSetInstance_ID	NUMERIC(10)
 ,NM_Module_ID				NUMERIC(10) NOT NULL
 ,NM_Sensor_Type_ID			NUMERIC(10) NOT NULL
 ,NM_Sensor_UU				VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Sensor_PKEY PRIMARY KEY (NM_Sensor_ID)
 ,CONSTRAINT NM_Sensor_UKEY UNIQUE (NM_Module_ID, SensorKey, IsActive)
) WITHOUT OIDS;

\qecho 'Create Comments on NM_Sensor';
COMMENT ON TABLE  NM_Sensor IS 'Датчики';
COMMENT ON COLUMN NM_Sensor.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Sensor.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Sensor.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Sensor.Name IS 'Наименование датчика';
COMMENT ON COLUMN NM_Sensor.SensorKey IS 'Ключ датчика в данных';
COMMENT ON COLUMN NM_Sensor.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Sensor.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Sensor.Description IS 'Описание';
COMMENT ON COLUMN NM_Sensor.Help IS 'Подсказка';
/* Create Indexes */

\qecho 'Create Indexes on NM_Sensor';
CREATE INDEX NM_Sensor_IsActive_IDX ON NM_Sensor (IsActive);
CREATE INDEX NM_Sensor_NM_Module_IDX ON NM_Sensor (NM_Module_ID);
CREATE INDEX NM_Sensor_NM_Sensor_Type_IDX ON NM_Sensor (NM_Sensor_Type_ID);
CREATE INDEX NM_Sensor_AD_Client_IDX ON NM_Sensor (AD_Client_ID);
CREATE INDEX NM_Sensor_AD_Org_IDX ON NM_Sensor (AD_Org_ID);
CREATE INDEX NM_Sensor_Name_IDX ON NM_Sensor (Name);
CREATE INDEX NM_Sensor_SensorKey_IDX ON NM_Sensor (SensorKey);
CREATE INDEX NM_Sensor_M_AttributeSetInstance_IDX ON NM_Sensor (M_AttributeSetInstance_ID);

/* Create Unique Keys */
\qecho 'Create uniq key for SensorKey Module and IsActive';

/* Create Foreign Keys */
\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Sensor
	ADD CONSTRAINT NM_Sensor_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Sensor
	ADD CONSTRAINT NM_Sensor_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for M_AttributeSetInstance';
ALTER TABLE NM_Sensor
	ADD CONSTRAINT NM_Sensor_M_AttributeSetInstance_FK FOREIGN KEY (M_AttributeSetInstance_ID)
	REFERENCES M_AttributeSetInstance (M_AttributeSetInstance_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for M_Product';
ALTER TABLE NM_Sensor
	ADD CONSTRAINT NM_Sensor_M_Product_FK FOREIGN KEY (M_Product_ID)
	REFERENCES M_Product (M_Product_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Module';
ALTER TABLE NM_Sensor
	ADD CONSTRAINT NM_Sensor_NM_Module_FK FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Sensor_Type';
ALTER TABLE NM_Sensor
	ADD CONSTRAINT NM_Sensor_NM_Sensor_Type_FK FOREIGN KEY (NM_Sensor_Type_ID)
	REFERENCES NM_Sensor_Type (NM_Sensor_Type_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;



\qecho 'Create check IsActive';
ALTER TABLE NM_Sensor 
  ADD CONSTRAINT NM_Sensor_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));

/* Grants */
\qecho 'Grant NM_Sensor owner to adempiere';
ALTER TABLE NM_Sensor OWNER TO adempiere;


