\o logs/NM_Calibration_Value.log
DROP TABLE IF EXISTS NM_Calibration_Value CASCADE;
/* Create Table */
\qecho 'Create Table NM_Calibration_Value';
CREATE TABLE NM_Calibration_Value
 (NM_Calibration_Value_ID	NUMERIC(10) NOT NULL
 ,VSort				NUMERIC(5)
 ,NKey				NUMERIC
 ,NValue			NUMERIC
 ,SKey				VARCHAR(255)
 ,SValue			VARCHAR(1023)
 ,Created			TIMESTAMP NOT NULL
 ,CreatedBy			NUMERIC(10) NOT NULL
 ,Updated			TIMESTAMP NOT NULL
 ,UpdatedBy			NUMERIC(10) NOT NULL
 ,AD_Org_ID			NUMERIC(10) NOT NULL
 ,AD_Client_ID			NUMERIC(10) NOT NULL
 ,NM_Calibration_ID		NUMERIC(10) NOT NULL
 ,NM_Calibration_Value_UU	VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Calibrate_Value_PKEY PRIMARY KEY (NM_Calibration_Value_ID)
 ) WITHOUT OIDS
;


\qecho 'Create Comments on NM_Calibration_Value';
COMMENT ON TABLE  NM_Calibration_Value IS 'Калибровочные значения';
COMMENT ON COLUMN NM_Calibration_Value.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Calibration_Value.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Calibration_Value.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Calibration_Value.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Calibration_Value.VSort IS 'Порядковый номер измерения';
COMMENT ON COLUMN NM_Calibration_Value.SKey IS 'Измеренной значение типа строка';
COMMENT ON COLUMN NM_Calibration_Value.SValue IS 'Калибровочное значение типа строка';
COMMENT ON COLUMN NM_Calibration_Value.NKey IS 'Измеренной значение типа цифровое значение';
COMMENT ON COLUMN NM_Calibration_Value.NValue IS 'Калибровочное значение типа цифровое значение';

/* Create Indexes */

\qecho 'Create Indexes on NM_Calibration_Value';
CREATE INDEX NM_Calibration_Value_VSort_IDX ON NM_Calibration_Value (VSort);
CREATE INDEX NM_Calibration_Value_SKey_IDX ON NM_Calibration_Value (SKey);
CREATE INDEX NM_Calibration_Value_NKey_IDX ON NM_Calibration_Value (NKey);
CREATE INDEX NM_Calibration_Value_NM_Calibration_IDX ON NM_Calibration_Value (NM_Calibration_ID);
CREATE INDEX NM_Calibration_Value_AD_Client_IDX ON NM_Calibration_Value (AD_Client_ID);
CREATE INDEX NM_Calibration_Value_AD_Org_IDX ON NM_Calibration_Value (AD_Org_ID);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Calibration_Value
	ADD CONSTRAINT NM_Calibration_Value_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Calibration_Value
	ADD CONSTRAINT NM_Calibration_Value_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Calibration';
ALTER TABLE NM_Calibration_Value
	ADD CONSTRAINT NM_Calibration_Value_NM_Calibrate_FK FOREIGN KEY (NM_Calibration_ID)
	REFERENCES NM_Calibration (NM_Calibration_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

/* Create Sequences

\qecho 'Create Sequence NM_Calibration_Value_SEQ';
CREATE SEQUENCE NM_Calibration_Value_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Calibration_Value_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Calibration_Value owner to adempiere';
ALTER TABLE NM_Calibration_Value OWNER TO adempiere;
