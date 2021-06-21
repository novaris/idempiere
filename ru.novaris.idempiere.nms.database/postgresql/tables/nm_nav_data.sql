\o logs/NM_Nav_Data.log
DROP TABLE IF EXISTS NM_Nav_Data;
/* Create Table */
\qecho 'Create Table NM_Nav_Data';
CREATE TABLE NM_Nav_Data
 (Nav_ID			BIGINT NOT NULL
 ,Nav_Type			NUMERIC(10) NOT NULL
 ,NM_Module_ID		NUMERIC(10) NOT NULL
 ,Nav_Datetime		TIMESTAMP NOT NULL
 ,Nav_Latitude		FLOAT NOT NULL
 ,Nav_Longitude		FLOAT NOT NULL
 ,Nav_Hgeo			FLOAT NOT NULL
 ,Nav_Status		NUMERIC(10) NOT NULL
 ,Nav_Satelites		NUMERIC(10)
 ,Nav_Sog			FLOAT
 ,Nav_Course		FLOAT
 ,Nav_Sens_Data		HSTORE
 ,Created			TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
) WITHOUT OIDS TABLESPACE user_data;

\qecho 'Create Comments on NM_Nav_Data';
COMMENT ON TABLE  NM_Nav_Data IS 'Данные модуля';
COMMENT ON COLUMN NM_Nav_Data.NM_Module_ID IS 'ИД модуля';
COMMENT ON COLUMN NM_Nav_Data.Nav_Datetime IS 'Дата формирования данных в UTC';
COMMENT ON COLUMN NM_Nav_Data.Nav_Latitude IS 'Геогафическая широта';
COMMENT ON COLUMN NM_Nav_Data.Nav_Longitude IS 'Географическая долгота';
COMMENT ON COLUMN NM_Nav_Data.Nav_Hgeo IS 'Высота над уровнем моря';
COMMENT ON COLUMN NM_Nav_Data.Nav_Satelites IS 'Количество спутников';
COMMENT ON COLUMN NM_Nav_Data.Nav_Sog IS 'Скорость';
COMMENT ON COLUMN NM_Nav_Data.Nav_Course IS 'Направление (Курс)';
COMMENT ON COLUMN NM_Nav_Data.Nav_Type IS 'Тип записи';
COMMENT ON COLUMN NM_Nav_Data.Nav_Sens_Data IS 'Данные сенсоров';
COMMENT ON COLUMN NM_Nav_Data.Created IS 'Дата создания записи';
/* Create Indexes */

\qecho 'Create Indexes on NM_Nav_Data';
CREATE INDEX NM_Nav_Data_Nav_IDX ON NM_Nav_Data (Nav_ID) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_NM_Module_IDX ON NM_Nav_Data (NM_Module_ID) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Nav_Datetime_IDX ON NM_Nav_Data (Nav_Datetime) TABLESPACE user_ind;
CREATE INDEX NM_Nav_Data_Nav_Sens_Data_IDX ON NM_Nav_Data USING GIST(Nav_Sens_Data) TABLESPACE user_ind;


/* Create Foreign Keys */

/* Grants */
\qecho 'Grant NM_Nav_Data owner to adempiere';
ALTER TABLE NM_Nav_Data OWNER TO adempiere;


