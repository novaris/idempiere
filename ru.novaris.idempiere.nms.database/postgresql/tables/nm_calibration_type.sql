\o logs/NM_Calibration_Type.log
DROP TABLE IF EXISTS NM_Calibration_Type CASCADE;
/* Create Table */
\qecho 'Create Table NM_Calibration_Type';
CREATE TABLE NM_Calibration_Type
 (NM_Calibration_Type_ID	NUMERIC(10) NOT NULL
 ,IsActive			CHAR(1) DEFAULT 'Y' NOT NULL
 ,Created			TIMESTAMP NOT NULL
 ,CreatedBy			NUMERIC(10) NOT NULL
 ,Updated			TIMESTAMP NOT NULL
 ,UpdatedBy			NUMERIC(10) NOT NULL
 ,Value				VARCHAR(40)  NOT NULL
 ,Name				VARCHAR(60)  NOT NULL
 ,Description			VARCHAR(255)
 ,Help				VARCHAR(2000)
 ,AD_Org_ID			NUMERIC(10) NOT NULL
 ,AD_Client_ID			NUMERIC(10) NOT NULL
 ,CONSTRAINT NM_Calibrate_Type_PKEY PRIMARY KEY (NM_Calibration_Type_ID)
 ) WITHOUT OIDS
;


\qecho 'Create Comments on NM_Calibration_Type';
COMMENT ON TABLE  NM_Calibration_Type IS 'Тип калибровочных значений';
COMMENT ON COLUMN NM_Calibration_Type.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Calibration_Type.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Calibration_Type.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Calibration_Type.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Calibration_Type.Description IS 'Описание';
COMMENT ON COLUMN NM_Calibration_Type.Help IS 'Подсказка';

/* Create Indexes */

\qecho 'Create Indexes on NM_Calibration_Type';
CREATE INDEX NM_Calibration_Type_Value_IDX ON NM_Calibration_Type (Value);
CREATE INDEX NM_Calibration_Type_Name_IDX ON NM_Calibration_Type (Name);
CREATE INDEX NM_Calibration_Type_IsActive_IDX ON NM_Module (IsActive);
CREATE INDEX NM_Calibration_Type_AD_Client_IDX ON NM_Module (AD_Client_ID);
CREATE INDEX NM_Calibration_Type_AD_Org_IDX ON NM_Module (AD_Org_ID);

/* Create Foreign Keys */


\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Calibration_Type
	ADD CONSTRAINT NM_Calibration_Type_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Calibration_Type
	ADD CONSTRAINT NM_Calibration_Type_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

/* Create Sequences

\qecho 'Create Sequence NM_Calibration_Type_SEQ';
CREATE SEQUENCE NM_Calibration_Type_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Calibration_Type_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Calibration_Type owner to adempiere';
ALTER TABLE NM_Calibration_Type OWNER TO adempiere;
