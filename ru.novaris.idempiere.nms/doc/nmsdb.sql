

/* Create Tablespaces */

CREATE TABLESPACE user_data
 LOCATION 'null'
;


CREATE TABLESPACE user_ind
 LOCATION 'null'
;



/* Create Sequences */

CREATE SEQUENCE NM_Modules_SEQ INCREMENT 1 MINVALUE 1 MAXVALUE 9999999999 START 1;



/* Create Tables */

CREATE TABLE AD_Client
(
	AD_Client_ID numeric(10) NOT NULL,
	PRIMARY KEY (AD_Client_ID)
) WITHOUT OIDS;


CREATE TABLE AD_Org
(
	AD_Org_ID numeric(10) NOT NULL,
	PRIMARY KEY (AD_Org_ID)
) WITHOUT OIDS;


CREATE TABLE AD_User
(
	AD_User_ID numeric(10) NOT NULL,
	PRIMARY KEY (AD_User_ID)
) WITHOUT OIDS;


CREATE TABLE A_Asset
(
	A_Asset_ID numeric(10) NOT NULL,
	PRIMARY KEY (A_Asset_ID)
) WITHOUT OIDS;


CREATE TABLE C_Bpartner
(
	C_Bpartner_ID numeric(10) NOT NULL,
	PRIMARY KEY (C_Bpartner_ID)
) WITHOUT OIDS;


CREATE TABLE C_Project
(
	C_Project_ID numeric(10) NOT NULL,
	PRIMARY KEY (C_Project_ID)
) WITHOUT OIDS;


CREATE TABLE C_UOM
(
	C_UOM_ID numeric(10) NOT NULL,
	PRIMARY KEY (C_UOM_ID)
) WITHOUT OIDS;


CREATE TABLE M_AttributeSet
(
	M_AttributeSet_ID numeric(10) NOT NULL,
	PRIMARY KEY (M_AttributeSet_ID)
) WITHOUT OIDS;


CREATE TABLE M_AttributeSetInstance
(
	M_AttributeSetInstance_ID numeric(10) NOT NULL,
	PRIMARY KEY (M_AttributeSetInstance_ID)
) WITHOUT OIDS;


CREATE TABLE M_Product
(
	M_Product_ID numeric(10) NOT NULL,
	PRIMARY KEY (M_Product_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Attribute
(
	NM_Attribute_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	AD_Org_ID numeric(10) NOT NULL,
	Value varchar(40) NOT NULL,
	Name varchar(60) NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	Description varchar(255),
	Help varchar(2000),
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	PRIMARY KEY (NM_Attribute_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Calibration
(
	NM_Calibration_ID numeric(10) NOT NULL,
	NM_Calibration_Type_ID numeric(10) NOT NULL,
	Name varchar(60) NOT NULL,
	IsActive char(1) NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	Help varchar(2000),
	AD_Org_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	NM_Sensor_ID numeric(10) NOT NULL,
	C_UOM_ID numeric(10) NOT NULL,
	NM_Calibration_UU varchar(36),
	CONSTRAINT spcb_pk PRIMARY KEY (NM_Calibration_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Calibration_Type
(
	NM_Calibration_Type_ID numeric(10) NOT NULL,
	Value varchar(40) NOT NULL,
	Name varchar(60) NOT NULL,
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	Created timestamp NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	Description varchar(255),
	Help varchar(2000),
	AD_Org_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	NM_Calibration_Type_UU varchar(36),
	PRIMARY KEY (NM_Calibration_Type_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Calibration_Value
(
	NM_Calibration_Value_ID numeric(10) NOT NULL,
	VSort int NOT NULL,
	NKey numeric,
	NValue numeric,
	SKey varchar(255),
	SValue varchar(1024),
	Created timestamp NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	NM_Calibration_ID numeric(10) NOT NULL,
	AD_Org_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	NM_Calibration_Value_UU varchar(36),
	PRIMARY KEY (NM_Calibration_Value_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Module
(
	NM_Module_ID numeric(10) NOT NULL,
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedBy numeric(10),
	Name varchar(60) NOT NULL,
	Description varchar(255),
	Help varchar(2000),
	GuaranteeDate timestamp,
	ModuleServiceDate timestamp,
	M_AttributeSetInstance_ID numeric(10) NOT NULL,
	M_AttributeSet_ID numeric(10) NOT NULL,
	M_Product_ID numeric(10) NOT NULL,
	C_Project_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	AD_User_ID numeric(10) NOT NULL,
	C_Bpartner_ID numeric(10) NOT NULL,
	NM_Protocol_ID numeric(10) NOT NULL,
	NM_Module_UU varchar(36),
	NM_Module_Login varchar(30),
	NM_Module_Passwd varchar(512),
	DataKey varchar(30) NOT NULL,
	DataSig varchar(30),
	PRIMARY KEY (NM_Module_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Nav_Data
(
	Nav_ID bigint NOT NULL,
	Nav_Type int NOT NULL,
	NM_Module_ID numeric(10) NOT NULL,
	Nav_Datetime timestamp NOT NULL,
	Nav_Latitude float NOT NULL,
	Nav_Longitude float NOT NULL,
	Nav_Hgeo float,
	Nav_Status int NOT NULL,
	Nav_Satelites int,
	Nav_Sog float,
	Nav_Course float,
	Nav_Sens_Data text,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
) WITHOUT OIDS TABLESPACE user_data;


CREATE TABLE NM_Nav_Data_Last
(
	Navl_ID bigint NOT NULL,
	Navl_Type int NOT NULL,
	Navl_Nav_ID bigint,
	NM_Module_ID numeric(10) NOT NULL,
	Navl_Datetime timestamp NOT NULL,
	Navl_Latitude float NOT NULL,
	Navl_Longitude float NOT NULL,
	Navl_Hgeo float,
	Navl_Status int NOT NULL,
	Navl_Satelites int,
	Navl_Sog float,
	Navl_Course float,
	Navl_Sens_Data time,
	Created timestamp NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT dasl_pk PRIMARY KEY (Navl_ID)
) WITHOUT OIDS TABLESPACE user_data;


CREATE TABLE NM_Profile
(
	NM_Profile_ID numeric(10) NOT NULL CONSTRAINT prof_pk UNIQUE,
	AD_Org_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	M_AttributeSet_ID numeric(10),
	M_AttributeSetInstance_ID numeric(10),
	NM_Module_ID numeric(10),
	C_Bpartner_ID numeric(10),
	Name varchar(60) NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp NOT NULL,
	UpdatedBy numeric(10),
	Description varchar(255),
	Help varchar(2000),
	NM_Profile_UU varchar(36),
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	PRIMARY KEY (NM_Profile_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Profile_Attribute
(
	NM_Profile_Attribute_ID numeric(10) NOT NULL,
	NM_Profile_ID numeric(10) NOT NULL CONSTRAINT prof_pk UNIQUE,
	NM_Attribute_ID numeric(10) NOT NULL,
	Value varchar(40) NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	AD_Org_ID numeric(10) NOT NULL,
	PRIMARY KEY (NM_Profile_Attribute_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Protocol
(
	NM_Protocol_ID numeric(10) NOT NULL,
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	Name varchar(60) NOT NULL,
	Description varchar(255),
	Help varchar(2000),
	AD_Org_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	URL varchar(120),
	NM_Protocol_UU varchar(36),
	PRIMARY KEY (NM_Protocol_ID)
) WITHOUT OIDS;


CREATE TABLE NM_Sensor
(
	NM_Sensor_ID numeric(10) NOT NULL,
	NM_Module_ID numeric(10) NOT NULL,
	NM_Sensor_Type_ID numeric(10) NOT NULL,
	AD_Org_ID numeric(10) NOT NULL,
	AD_Client_ID numeric(10) NOT NULL,
	Name varchar(30) NOT NULL,
	SensorKey varchar(30) NOT NULL,
	Description varchar(255),
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	Created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	Help varchar(2000),
	NM_Sensor_UU varchar(36),
	M_AttributeSetInstance_ID numeric(10) NOT NULL,
	A_Asset_ID numeric(10),
	M_Product_ID numeric(10) NOT NULL,
	CONSTRAINT spsn_pk PRIMARY KEY (NM_Sensor_ID),
	CONSTRAINT SensorKey_UKEY UNIQUE (NM_Module_ID, SensorKey, IsActive)
) WITHOUT OIDS;


CREATE TABLE NM_Sensor_Type
(
	NM_Sensor_Type_ID numeric(10) NOT NULL,
	Value varchar(40) NOT NULL,
	Name varchar(60) NOT NULL,
	Description varchar(255),
	IsActive char(1) DEFAULT 'Y' NOT NULL,
	Created timestamp NOT NULL,
	CreatedBy numeric(10) NOT NULL,
	Updated timestamp NOT NULL,
	UpdatedBy numeric(10) NOT NULL,
	Help varchar(2000),
	AD_Client_ID numeric(10) NOT NULL,
	AD_Org_ID numeric(10) NOT NULL,
	C_UOM_ID numeric(10) NOT NULL,
	NM_Sensor_Type_UU varchar(36),
	NM_Calibration_Type_ID numeric(10) NOT NULL,
	CONSTRAINT spst_pk PRIMARY KEY (NM_Sensor_Type_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.gis_attr_types
(
	gstt_ID numeric(10) NOT NULL,
	gstt_name varchar(30) NOT NULL,
	gstt_desc varchar(1024) NOT NULL,
	CONSTRAINT gstt_pk PRIMARY KEY (gstt_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.gis_data
(
	gsdt_ID numeric(10) NOT NULL,
	gsdt_Gsob_ID numeric(10) NOT NULL,
	gsdt_gspt_ID numeric(10) NOT NULL,
	gsdt_date timestamp NOT NULL,
	gsdt_info varchar(100),
	CONSTRAINT gsdt_pk PRIMARY KEY (gsdt_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.gis_objects
(
	Gsob_ID numeric(10) NOT NULL,
	Gsob_gstp_ID numeric(10),
	Gsob_gser_ID int,
	Gsob_name varchar(30) NOT NULL,
	Gsob_desc varchar(2048) NOT NULL,
	Gsob_date timestamp NOT NULL,
	Gsob_date_close timestamp,
	Gsob_code varchar(100),
	CONSTRAINT Gsob_pk PRIMARY KEY (Gsob_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.gis_objects_attr
(
	gsat_ID numeric(10) NOT NULL,
	gsat_Gsob_ID numeric(10),
	gsat_gstt_ID numeric(10),
	gsat_attr int,
	gsat_attr1 float,
	gsat_attr2 float,
	CONSTRAINT gsat_pk PRIMARY KEY (gsat_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.gis_point_types
(
	gspt_ID numeric(10) NOT NULL,
	gspt_name varchar(100) NOT NULL,
	gspt_desc varchar(1024),
	gspt_date date NOT NULL,
	CONSTRAINT gspt_pk PRIMARY KEY (gspt_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.gis_types
(
	gstp_ID numeric(10) NOT NULL,
	gstp_code varchar(30) NOT NULL,
	gstp_name varchar(100) NOT NULL,
	gstp_desc varchar(1024),
	gstp_date timestamp NOT NULL,
	CONSTRAINT gstp_pk PRIMARY KEY (gstp_ID)
) WITHOUT OIDS;


CREATE TABLE owner_track.sprv_cis_info
(
	spcI_ID numeric(10) NOT NULL,
	spcI_code int NOT NULL,
	spcI_desc varchar(240),
	spcI_gstp_ID numeric(10) NOT NULL,
	CONSTRAINT spcI_pk PRIMARY KEY (spcI_ID)
) WITHOUT OIDS;



/* Create Foreign Keys */

ALTER TABLE NM_Attribute
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration_Type
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration_Value
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile_Attribute
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Protocol
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor_Type
	ADD FOREIGN KEY (AD_Client_ID)
	REFERENCES AD_Client (AD_Client_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Attribute
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration_Type
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration_Value
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile_Attribute
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Protocol
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor_Type
	ADD FOREIGN KEY (AD_Org_ID)
	REFERENCES AD_Org (AD_Org_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (AD_User_ID)
	REFERENCES AD_User (AD_User_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD FOREIGN KEY (A_Asset_ID)
	REFERENCES A_Asset (A_Asset_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (C_Bpartner_ID)
	REFERENCES C_Bpartner (C_Bpartner_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile
	ADD FOREIGN KEY (C_Bpartner_ID)
	REFERENCES C_Bpartner (C_Bpartner_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (C_Project_ID)
	REFERENCES C_Project (C_Project_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration
	ADD FOREIGN KEY (C_UOM_ID)
	REFERENCES C_UOM (C_UOM_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor_Type
	ADD FOREIGN KEY (C_UOM_ID)
	REFERENCES C_UOM (C_UOM_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (M_AttributeSet_ID)
	REFERENCES M_AttributeSet (M_AttributeSet_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile
	ADD FOREIGN KEY (M_AttributeSet_ID)
	REFERENCES M_AttributeSet (M_AttributeSet_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (M_AttributeSetInstance_ID)
	REFERENCES M_AttributeSetInstance (M_AttributeSetInstance_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile
	ADD FOREIGN KEY (M_AttributeSetInstance_ID)
	REFERENCES M_AttributeSetInstance (M_AttributeSetInstance_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD FOREIGN KEY (M_AttributeSetInstance_ID)
	REFERENCES M_AttributeSetInstance (M_AttributeSetInstance_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (M_Product_ID)
	REFERENCES M_Product (M_Product_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD FOREIGN KEY (M_Product_ID)
	REFERENCES M_Product (M_Product_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile_Attribute
	ADD FOREIGN KEY (NM_Attribute_ID)
	REFERENCES NM_Attribute (NM_Attribute_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration_Value
	ADD FOREIGN KEY (NM_Calibration_ID)
	REFERENCES NM_Calibration (NM_Calibration_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration
	ADD FOREIGN KEY (NM_Calibration_Type_ID)
	REFERENCES NM_Calibration_Type (NM_Calibration_Type_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor_Type
	ADD FOREIGN KEY (NM_Calibration_Type_ID)
	REFERENCES NM_Calibration_Type (NM_Calibration_Type_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Nav_Data
	ADD FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Nav_Data_Last
	ADD FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile
	ADD FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD FOREIGN KEY (NM_Module_ID)
	REFERENCES NM_Module (NM_Module_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Profile_Attribute
	ADD FOREIGN KEY (NM_Profile_ID)
	REFERENCES NM_Profile (NM_Profile_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Module
	ADD FOREIGN KEY (NM_Protocol_ID)
	REFERENCES NM_Protocol (NM_Protocol_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Calibration
	ADD FOREIGN KEY (NM_Sensor_ID)
	REFERENCES NM_Sensor (NM_Sensor_ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NM_Sensor
	ADD CONSTRAINT spsn_spst_fk FOREIGN KEY (NM_Sensor_Type_ID)
	REFERENCES NM_Sensor_Type (NM_Sensor_Type_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;


ALTER TABLE owner_track.gis_objects_attr
	ADD CONSTRAINT gsat_gstt_fk FOREIGN KEY (gsat_gstt_ID)
	REFERENCES owner_track.gis_attr_types (gstt_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;


ALTER TABLE owner_track.gis_data
	ADD CONSTRAINT gsdt_Gsob_fk FOREIGN KEY (gsdt_Gsob_ID)
	REFERENCES owner_track.gis_objects (Gsob_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;


ALTER TABLE owner_track.gis_objects_attr
	ADD CONSTRAINT gsat_Gsob_fk FOREIGN KEY (gsat_Gsob_ID)
	REFERENCES owner_track.gis_objects (Gsob_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;


ALTER TABLE owner_track.gis_data
	ADD CONSTRAINT gsdt_gspt_fk FOREIGN KEY (gsdt_gspt_ID)
	REFERENCES owner_track.gis_point_types (gspt_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;


ALTER TABLE owner_track.gis_objects
	ADD CONSTRAINT Gsob_gstp_fk FOREIGN KEY (Gsob_gstp_ID)
	REFERENCES owner_track.gis_types (gstp_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;


ALTER TABLE owner_track.sprv_cis_info
	ADD CONSTRAINT spcI_gstp_fk FOREIGN KEY (spcI_gstp_ID)
	REFERENCES owner_track.gis_types (gstp_ID)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
;



/* Create Indexes */

CREATE INDEX I_NM_Modules_IsActive ON NM_Module (IsActive);
CREATE INDEX I_NM_Modules_AD_User ON NM_Module (AD_User_ID);
CREATE INDEX I_NM_Modules_AD_Client ON NM_Module (AD_Client_ID);
CREATE INDEX I_NM_Modules_AD_Org ON NM_Module ();
CREATE INDEX I_NM_Modules_C_Bpartner ON NM_Module (C_Bpartner_ID);
CREATE INDEX I_NM_Modules_M_Product ON NM_Module (M_Product_ID);
CREATE INDEX I_NM_Modules_M_AttributeSetInstance ON NM_Module (M_AttributeSetInstance_ID);
CREATE INDEX I_NM_Modules_Name ON NM_Module (Name);



/* Comments */

COMMENT ON COLUMN NM_Calibration.IsActive IS 'Активна
';
COMMENT ON COLUMN NM_Calibration.Created IS 'Дата создания записи';
COMMENT ON COLUMN NM_Calibration.CreatedBy IS 'Дата модификации';
COMMENT ON TABLE NM_Calibration_Type IS 'Тип калибровки';
COMMENT ON COLUMN NM_Calibration_Value.VSort IS 'Поле сортировки';
COMMENT ON COLUMN NM_Calibration_Value.NKey IS 'Ключ типа номер';
COMMENT ON COLUMN NM_Calibration_Value.NValue IS 'Значение ключа';
COMMENT ON COLUMN NM_Calibration_Value.SKey IS 'Ключ типа строка';
COMMENT ON COLUMN NM_Calibration_Value.SValue IS 'Значение ключа типа строка';
COMMENT ON TABLE NM_Module IS 'Модули мониторинга';
COMMENT ON COLUMN NM_Module.IsActive IS 'Запись активна?';
COMMENT ON COLUMN NM_Module.Created IS 'Дата создания';
COMMENT ON COLUMN NM_Module.CreatedBy IS 'Создана ';
COMMENT ON COLUMN NM_Module.Name IS 'Наименование объекта';
COMMENT ON COLUMN NM_Module.NM_Module_Passwd IS 'Пароль для управления терминалом';
COMMENT ON COLUMN NM_Module.DataKey IS 'Идентификатор терминала при передаче данных';
COMMENT ON COLUMN NM_Nav_Data.Nav_Type IS 'Тип данных';
COMMENT ON COLUMN NM_Nav_Data.Nav_Datetime IS 'Дата время с таймзоной';
COMMENT ON COLUMN NM_Nav_Data.Nav_Latitude IS 'Географическая долгота';
COMMENT ON COLUMN NM_Nav_Data.Nav_Longitude IS 'Географическая широта';
COMMENT ON COLUMN NM_Nav_Data.Nav_Hgeo IS 'Значение HGEO';
COMMENT ON COLUMN NM_Nav_Data.Nav_Status IS 'Флаг состояний';
COMMENT ON COLUMN NM_Nav_Data.Nav_Satelites IS 'Количество спутников';
COMMENT ON COLUMN NM_Nav_Data.Nav_Sog IS 'Скорость в м;с';
COMMENT ON COLUMN NM_Nav_Data.Nav_Course IS 'Курс в градусах';
COMMENT ON COLUMN NM_Nav_Data.Nav_Sens_Data IS 'Данные сенсоров';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Type IS 'Тип данных';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Datetime IS 'Дата время с таймзоной';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Latitude IS 'Географическая долгота';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Longitude IS 'Географическая широта';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Hgeo IS 'Значение HGEO';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Status IS 'Флаг состояний';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Satelites IS 'Количество спутников';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Sog IS 'Скорость в м;с';
COMMENT ON COLUMN NM_Nav_Data_Last.Navl_Course IS 'Курс в градусах';
COMMENT ON COLUMN NM_Nav_Data_Last.Updated IS 'Дата модификации';
COMMENT ON TABLE NM_Profile IS 'Профили объектов мониторинга';
COMMENT ON COLUMN NM_Sensor.Name IS 'Наименование датчика';
COMMENT ON COLUMN NM_Sensor.Description IS 'Описание датчика';
COMMENT ON COLUMN NM_Sensor_Type.Name IS 'Нименование типа';
COMMENT ON COLUMN NM_Sensor_Type.Description IS 'Описание типа';
COMMENT ON COLUMN owner_track.gis_attr_types.gstt_name IS 'Имя типа';
COMMENT ON COLUMN owner_track.gis_attr_types.gstt_desc IS 'Описание';
COMMENT ON COLUMN owner_track.gis_data.gsdt_gspt_ID IS 'признак "замечательной" точки (начало дороги, ИССО, перекрестки, примыкания и т.д.) 0 - обычная точка, другие значения - "замечательная" точка';
COMMENT ON COLUMN owner_track.gis_data.gsdt_date IS 'Дата создания';
COMMENT ON COLUMN owner_track.gis_data.gsdt_info IS 'Дополнительная информация';
COMMENT ON COLUMN owner_track.gis_objects.Gsob_name IS 'Код объекта';
COMMENT ON COLUMN owner_track.gis_objects.Gsob_desc IS 'Описания объекта';
COMMENT ON COLUMN owner_track.gis_objects.Gsob_date IS 'Дата создания объекта';
COMMENT ON COLUMN owner_track.gis_objects.Gsob_date_close IS 'Дата закрытия объекта';
COMMENT ON COLUMN owner_track.gis_objects.Gsob_code IS 'Ид объекта в системе откуда пришла информация';
COMMENT ON COLUMN owner_track.gis_objects_attr.gsat_attr IS 'Атрибут типа INTEGER';
COMMENT ON COLUMN owner_track.gis_objects_attr.gsat_attr1 IS 'Начало интервального атрибута';
COMMENT ON COLUMN owner_track.gis_objects_attr.gsat_attr2 IS 'Конец интервального атрибута';
COMMENT ON COLUMN owner_track.gis_point_types.gspt_name IS 'Наименование точки';
COMMENT ON COLUMN owner_track.gis_point_types.gspt_desc IS 'Описание точки';
COMMENT ON COLUMN owner_track.gis_point_types.gspt_date IS 'Дата создания';
COMMENT ON COLUMN owner_track.gis_types.gstp_code IS 'Кодировка';
COMMENT ON COLUMN owner_track.gis_types.gstp_name IS 'Краткое наименование';
COMMENT ON COLUMN owner_track.gis_types.gstp_desc IS 'Описание';
COMMENT ON COLUMN owner_track.gis_types.gstp_date IS 'Дата создания';
COMMENT ON COLUMN owner_track.sprv_cis_info.spcI_code IS 'Код типа';
COMMENT ON COLUMN owner_track.sprv_cis_info.spcI_desc IS 'Описание';



