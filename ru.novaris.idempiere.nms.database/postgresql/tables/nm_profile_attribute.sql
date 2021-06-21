\o logs/NM_Profile_Attribute.log
DROP TABLE IF EXISTS NM_Profile_Attribute CASCADE;
/* Create Table */
\qecho 'Create Table NM_Profile_Attribute';
CREATE TABLE NM_Profile_Attribute
 (NM_Profile_Attribute_ID	NUMERIC(10) NOT NULL
 ,NValue			NUMERIC
 ,SValue			VARCHAR(1023)
 ,Created			TIMESTAMP NOT NULL
 ,CreatedBy			NUMERIC(10) NOT NULL
 ,Updated			TIMESTAMP NOT NULL
 ,UpdatedBy			NUMERIC(10) NOT NULL
 ,AD_Org_ID			NUMERIC(10) NOT NULL
 ,AD_Client_ID		NUMERIC(10) NOT NULL
 ,NM_Profile_ID		NUMERIC(10) NOT NULL
 ,NM_Attribute_ID	NUMERIC(10) NOT NULL
 ,NM_Profile_Attribute_UU	VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Profile_Attribute_PKEY PRIMARY KEY (NM_Profile_Attribute_ID)
 ) WITHOUT OIDS
;


\qecho 'Create Comments on NM_Profile_Attribute';
COMMENT ON TABLE  NM_Profile_Attribute IS 'Значение атрибута профиля';
COMMENT ON COLUMN NM_Profile_Attribute.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Profile_Attribute.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Profile_Attribute.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Profile_Attribute.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Profile_Attribute.SValue IS 'Значение типа строка';
COMMENT ON COLUMN NM_Profile_Attribute.NValue IS 'Значение типа цифровое значение';

/* Create Indexes */

\qecho 'Create Indexes on NM_Profile_Attribute';
CREATE INDEX NM_Profile_Attribute_IDX ON NM_Profile_Attribute (NM_Profile_Attribute_ID);
CREATE INDEX NM_Profile_Attribute_NM_Profile_IDX ON NM_Profile_Attribute (NM_Profile_ID);
CREATE INDEX NM_Profile_Attribute_NM_Attribute_IDX ON NM_Profile_Attribute (NM_Attribute_ID);
CREATE INDEX NM_Profile_Attribute_AD_Client_IDX ON NM_Profile_Attribute (AD_Client_ID);
CREATE INDEX NM_Profile_Attribute_AD_Org_IDX ON NM_Profile_Attribute (AD_Org_ID);

/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Profile_Attribute
	ADD CONSTRAINT NM_Profile_Attribute_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Profile_Attribute
	ADD CONSTRAINT NM_Profile_Attribute_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Attribute';
ALTER TABLE NM_Profile_Attribute
	ADD CONSTRAINT NM_Profile_Attribute_NM_Attribute_FK FOREIGN KEY (NM_Attribute_ID)
	REFERENCES NM_Attribute (NM_Attribute_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Profile';
ALTER TABLE NM_Profile_Attribute
	ADD CONSTRAINT NM_Profile_Attribute_NM_Profile_FK FOREIGN KEY (NM_Profile_ID)
	REFERENCES NM_Profile (NM_Profile_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

/* Create Sequences

\qecho 'Create Sequence NM_Profile_Attribute_SEQ';
CREATE SEQUENCE NM_Profile_Attribute_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Profile_Attribute_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Profile_Attribute owner to adempiere';
ALTER TABLE NM_Profile_Attribute OWNER TO adempiere;
