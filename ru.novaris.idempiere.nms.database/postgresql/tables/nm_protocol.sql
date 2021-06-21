\o logs/NM_Protocol.log
DROP TABLE IF EXISTS NM_Protocol CASCADE;
/* Create Table */
\qecho 'Create Table NM_Protocol';
CREATE TABLE NM_Protocol
 (NM_Protocol_ID			NUMERIC(10) NOT NULL
 ,IsActive					CHAR(1) DEFAULT 'Y' NOT NULL
 ,Created					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,CreatedBy					NUMERIC(10) NOT NULL
 ,Updated					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
 ,Updatedby					NUMERIC(10)
 ,Name						VARCHAR(60) NOT NULL
 ,Description				VARCHAR(255)
 ,Help						VARCHAR(2000)
 ,URL						VARCHAR(120)
 ,DataPort					NUMERIC(5)
 ,AD_Org_ID					NUMERIC(10) NOT NULL
 ,AD_Client_ID				NUMERIC(10) NOT NULL
 ,NM_Protocol_UU			VARCHAR(36) DEFAULT NULL
 ,CONSTRAINT NM_Protocol_PKEY PRIMARY KEY (NM_Protocol_ID)
 ) WITHOUT OIDS
;

\qecho 'Create Comments on NM_Protocol';
COMMENT ON TABLE  NM_Protocol IS 'Протокол взаимодействия модулей мониторинга';
COMMENT ON COLUMN NM_Protocol.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Protocol.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Protocol.CreatedBy IS 'Создана';
COMMENT ON COLUMN NM_Protocol.Name IS 'Наименование объекта';
COMMENT ON COLUMN NM_Protocol.Updated IS 'Дата обновления';
COMMENT ON COLUMN NM_Protocol.UpdatedBy IS 'Обновлена';
COMMENT ON COLUMN NM_Protocol.Description IS 'Описание';
COMMENT ON COLUMN NM_Protocol.Help IS 'Подсказка';
COMMENT ON COLUMN NM_Protocol.URL IS 'Ссылка на документацию';
COMMENT ON COLUMN NM_Protocol.DataPort IS 'Порт по умолчанию для передачи данных';


/* Create Indexes */

\qecho 'Create Indexes on NM_Protocol';
CREATE INDEX NM_Protocol_IsActive_IDX ON NM_Protocol (IsActive);
CREATE INDEX NM_Protocol_AD_Client_IDX ON NM_Protocol (AD_Client_ID);
CREATE INDEX NM_Protocol_AD_Org_IDX ON NM_Protocol (AD_Org_ID);
CREATE INDEX NM_Protocol_Name_IDX ON NM_Protocol (Name);
CREATE INDEX NM_Protocol_DataPort_IDX ON NM_Protocol (DataPort);


/* Create Foreign Keys */

\qecho 'Create foreign key for AD_Client';
ALTER TABLE NM_Protocol
	ADD CONSTRAINT NM_Protocol_AD_Client_FK FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create foreign key for AD_Org';
ALTER TABLE NM_Protocol
	ADD CONSTRAINT NM_Protocol_AD_Org_FK FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;

\qecho 'Create check IsActive';
ALTER TABLE NM_Protocol 
  ADD CONSTRAINT NM_Protocol_IsActive_CHK CHECK (IsActive = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]));
/* Create Sequences

\qecho 'Create Sequence NM_Protocol_SEQ';
CREATE SEQUENCE NM_Protocol_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;

ALTER SEQUENCE NM_Protocol_SEQ OWNER TO Owner_Nms;

*/

/* Grants */
\qecho 'Grant NM_Protocol owner to adempiere';
ALTER TABLE NM_Protocol OWNER TO adempiere;
