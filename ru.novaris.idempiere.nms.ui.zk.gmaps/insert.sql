INSERT INTO pa_dashboardcontent (pa_dashboardcontent_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, description, zulfilepath, pa_dashboardcontent_uu) VALUES(nextidfunc(50015,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'Google Map', 'GOOGLE_MAPS_API_KEY has to be set in System Configurator', '/zul/gmap.zul', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, entitytype, configurationlevel, ad_sysconfig_uu) VALUES(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GOOGLE_MAPS_API_KEY','AIzaSyAdDw4734xy4P6VJeqdi-vVMTMb-oQAT0I', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'ZK_BROWSER_TITLE','Новарис ERP','Browser title information', 'U', 'S', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_ASSET_MARKER','Equipment16px.png','Иконка активов', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_BPARTNER_MARKER','BPartner24.png','Иконка Бизнес партнёра', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_SHOW_BPARTNER_ASSET','true','Отображать на карте активы', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_MODULE_STOP','stopBlue.png','Иконка объекта для неподвижного объекта', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_MODULE_STOP_ALERT','stopRed.png','Иконка объекта при возникновении события для неподвижного объекта', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_MODULE_MARKER','navGreen','Часть имени файла иконки для врашающихся объектов (от -0 до -360.png)', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'GMAP_MODULE_ALERT_MARKER','navRed','Часть имени файла иконки для врашающихся объектов (от -0 до -360.png) при возникновении события', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'NOMINATIM_BASE_URL','http://nominatim.openstreetmap.org/','URL сервера NOMINATIM определение местоположения по адресу	', 'U', 'C', uuid_generate_v4());

INSERT INTO ad_sysconfig (ad_sysconfig_id, ad_client_id, ad_org_id, created, createdby, updated, updatedby, isactive, name, value, description, entitytype, configurationlevel, ad_sysconfig_uu) VALUES 
(nextidfunc(50009,'N'), 0, 0, now(), 100, now(), 100, 'Y', 'NOMINATIM_EMAIL','support@novaris.ru','EMAIL сервера NOMINATIM', 'U', 'C', uuid_generate_v4());