\o logs/NM_Nav_Data_Last.log
DROP TABLE IF EXISTS NM_Nav_Data_Last;
/* Create Table */
\qecho 'Create Table NM_Nav_Data_Last';
CREATE TABLE NM_Nav_Data_Last
 (Nav_ID			BIGINT NOT NULL
 ,Nav_Nav_ID		BIGINT NOT NULL
 ,Nav_Type			NUMERIC(10) NOT NULL
 ,Nav_Datetime		TIMESTAMP NOT NULL
 ,Nav_Latitude		FLOAT NOT NULL
 ,Nav_Longitude	FLOAT NOT NULL
 ,Nav_Hgeo			FLOAT NOT NULL
 ,Nav_Status		NUMERIC(10) NOT NULL
 ,Nav_Satelites	NUMERIC(10)
 ,Nav_Sog			FLOAT
 ,Nav_Course		FLOAT
 ,Nav_Sens_Data	HSTORE
 ,AD_Org_ID			NUMERIC(10) NOT NULL
 ,AD_Client_ID		NUMERIC(10) NOT NULL
 ,NM_Module_ID		NUMERIC(10) NOT NULL
 ,Created			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy			NUMERIC(10) DEFAULT 0 NOT NULL
 ,Updated			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,UpdatedBy			NUMERIC(10) DEFAULT 0 NOT NULL
) WITHOUT OIDS TABLESPACE user_data;

\qecho 'Create Comments on NM_Nav_Data_Last';
COMMENT ON TABLE  NM_Nav_Data_Last IS 'Данные модуля';
COMMENT ON COLUMN NM_Nav_Data_Last.NM_Module_ID IS 'ИД модуля';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Datetime IS 'Дата формирования данных в UTC';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Latitude IS 'Геогафическая широта';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Longitude IS 'Географическая долгота';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Hgeo IS 'Высота над уровнем моря';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Satelites IS 'Количество спутников';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Sog IS 'Скорость';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Course IS 'Направление (Курс)';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Type IS 'Тип записи';
COMMENT ON COLUMN NM_Nav_Data_Last.Nav_Sens_Data IS 'Данные сенсоров';
COMMENT ON COLUMN NM_Nav_Data_Last.Created IS 'Дата создания записи';
COMMENT ON COLUMN NM_Nav_Data_Last.Updated IS 'Дата обновления записи';

/* Create Indexes */
\qecho 'Create Indexes on NM_Nav_Data_Last';
CREATE INDEX NM_Nav_Data_Last_Nav_IDX ON NM_Nav_Data_Last (Nav_ID) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Last_NM_Module_IDX ON NM_Nav_Data_Last (NM_Module_ID) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Last_AD_Org_IDX ON NM_Nav_Data_Last (AD_Org_ID) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Last_AD_Client_IDX ON NM_Nav_Data_Last (AD_Client_ID) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Last_Nav_Datetime_IDX ON NM_Nav_Data_Last (Nav_Datetime) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Last_Nav_Sens_Data_IDX ON NM_Nav_Data_Last USING GIST(Nav_Sens_Data) TABLESPACE user_ind;


/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Nav_Data_Last
	ADD CONSTRAINT NM_Nav_Data_Last_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Nav_Data_Last
	ADD CONSTRAINT NM_Nav_Data_Last_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for NM_Module';
ALTER TABLE NM_Nav_Data_Last
	ADD CONSTRAINT NM_Nav_Data_Last_NM_Module_FK FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

/* Grants */
\qecho 'Grant NM_Nav_Data_Last owner to adempiere';
ALTER TABLE NM_Nav_Data_Last OWNER TO adempiere;
