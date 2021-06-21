\o logs/NM_Calibration.log
DROP TABLE IF EXISTS NM_Calibration CASCADE;
/* Create Table */
\qecho 'Create Table NM_Calibration';
CREATE TABLE NM_Calibration
 (NM_Calibration_ID		NUMERIC(10) NOT NULL
 ,Name				VARCHAR(60) NOT NULL
 ,Description			VARCHAR(255)
 ,IsActive			CHAR(1)
 ,Created			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy			NUMERIC(10) NOT NULL
 ,Updated			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,UpdatedBy			NUMERIC(10) NOT NULL
 ,Help				VARCHAR(2000)
 ,AD_Org_ID			NUMERIC(10) NOT NULL
 ,AD_Client_ID			NUMERIC(10) NOT NULL
 ,C_UOM_ID			NUMERIC(10) NOT NULL
 ,NM_Sensor_ID			NUMERIC(10) NOT NULL
 ,NM_Calibration_Type_ID	NUMERIC(10) NOT NULL
 ,NM_Calibration_UU		VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Calibration_PKEY PRIMARY KEY (NM_Calibration_ID)
 ) WITHOUT OIDS
;


\qecho 'Create Comments on NM_Calibration';
COMMENT ON TABLE  NM_Calibration IS 'Таррировка/Калибровка';
COMMENT ON COLUMN NM_Calibration.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Calibration.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Calibration.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Calibration.Name IS 'Наименование объекта';
COMMENT ON COLUMN NM_Calibration.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Calibration.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Calibration.Description IS 'Описание';
COMMENT ON COLUMN NM_Calibration.Help IS 'Подсказка';

/* Create Indexes */

\qecho 'Create Indexes on NM_Calibration';
CREATE INDEX NM_Calibration_IsActive_IDX ON NM_Calibration (IsActive);
CREATE INDEX NM_Calibration_AD_Client_IDX ON NM_Calibration (AD_Client_ID);
CREATE INDEX NM_Calibration_AD_Org_IDX ON NM_Calibration (AD_Org_ID);
CREATE INDEX NM_Calibration_C_UOM_IDX ON NM_Calibration (C_UOM_ID);
CREATE INDEX NM_Calibration_NM_Sensor_IDX ON NM_Calibration (NM_Sensor_ID);
CREATE INDEX NM_Calibration_Name_IDX ON NM_Calibration (Name);
CREATE INDEX NM_Calibration_Type_IDX ON NM_Calibration (NM_Calibration_Type_ID);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Calibration
	ADD CONSTRAINT NM_Calibration_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Calibration
	ADD CONSTRAINT NM_Calibration_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Sensor';
ALTER TABLE NM_Calibration
	ADD CONSTRAINT NM_Calibration_NM_Sensor_FK FOREIGN KEY (NM_Sensor_ID)
	REFERENCES NM_Sensor (NM_Sensor_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for C_UOM'
ALTER TABLE NM_Calibration
	ADD CONSTRAINT NM_Calibration_C_UOM_FK FOREIGN KEY (C_UOM_ID)
	REFERENCES C_UOM (C_UOM_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Calibration_Type';
ALTER TABLE NM_Calibration
	ADD CONSTRAINT NM_Calibration_NM_Calibration_Type_FK FOREIGN KEY (NM_Calibration_Type_ID)
	REFERENCES NM_Calibration_Type (NM_Calibration_Type_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Calibration 
  ADD CONSTRAINT NM_Calibration_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));
/* Create Sequences

\qecho 'Create Sequence NM_Calibration_SEQ';
CREATE SEQUENCE NM_Calibration_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Calibration_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Calibration owner to adempiere';
ALTER TABLE NM_Calibration OWNER TO adempiere;
