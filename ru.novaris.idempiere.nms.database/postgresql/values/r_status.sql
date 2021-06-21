INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES 
(100010
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Новая'
,'Стадия Новая - запрос создан'
,NULL
,'Y'
,'Y'
,'N'
,'Новая'
,NULL
,NULL
,0
,'N'
,'N'
,10
,100000
,'0ffb7acf-1b7d-4f71-a2ba-a17e7ecb77fc');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100150
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Выбор услуги выполнен'
,'Выполнена обработка запроса на услугу'
,NULL
,'N'
,'N'
,'N'
,'Выбор услуги выполнен'
,NULL
,NULL
,0
,'N'
,'N'
,150
,100000
,'c155d078-22b1-4acf-a84a-23a04958dff7');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100100
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Выбор услуги'
,'Отправка запроса на выбор услуги'
,NULL
,'N'
,'N'
,'N'
,'Выбор услуги'
,100150
,NULL
,0
,'N'
,'N'
,100
,100000
,'81be25b0-6a76-4325-9cbf-6828892d97e6');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100200
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Определение поставщика'
,'Поиск и определение поставщика'
,NULL
,'N'
,'N'
,'N'
,'Определение поставщика'
,NULL
,NULL
,0
,'N'
,'N'
,200
,100000
,'99eb141d-8102-48d7-8879-eb20e1f2b584');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100250
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Определение поставщика выполнено'
,'Поиск и определение поставщика выполнено успешно'
,NULL
,'N'
,'N'
,'N'
,'Определение поставщика выполнено'
,NULL
,NULL
,0
,'N'
,'N'
,250
,100000
,'1bb522e6-a63e-408e-93f0-f2114fcbc8db');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100300
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Подтверждение услуги клиентом'
,'Запрос подтверждения клиентом'
,NULL
,'N'
,'N'
,'N'
,'Подтверждение услуги клиентом'
,NULL
,NULL
,0
,'N'
,'N'
,300
,100000
,'9128395c-8a68-437b-8a62-cea86822dc68');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100350
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Подтверждение услуги клиентом выполнено'
,'Подтверждения клиентом запроса на услугу выполнено'
,NULL
,'N'
,'N'
,'N'
,'Подтверждение услуги клиентом выполнено'
,NULL
,NULL
,0
,'N'
,'N'
,350
,100000
,'6d192eef-e88d-4164-aee0-e3ec7508253c');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100375
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Выбор исполнителя'
,'Выбор исполнителя (машины) вручную'
,NULL
,'N'
,'N'
,'N'
,'Выбор исполнителя (машины) вручную'
,NULL
,NULL
,0
,'N'
,'N'
,375
,100000
,'38b6d70e-8fe4-4f81-8717-14a94cd0f823');


INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100400
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Согласование с исполнителем'
,'Запрос на согласование с испольнителем'
,NULL
,'N'
,'N'
,'N'
,'Согласование с исполнителем'
,NULL
,NULL
,0
,'N'
,'N'
,400
,100000
,'30f3d362-76a3-431b-b110-8536fb2ee681');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100450
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Согласование с исполнителем выполнено'
,'Выполнено согласование с испольнителем'
,NULL
,'N'
,'N'
,'N'
,'Согласование с исполнителем выполнено'
,NULL
,NULL
,0
,'N'
,'N'
,450
,100000
,'d3fbc894-6647-415c-beab-8ddc77cf8dc9');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100500
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'В работе'
,'Взято в работу'
,NULL
,'N'
,'N'
,'N'
,'В работе'
,NULL
,NULL
,0
,'N'
,'N'
,500
,100000
,'ef447653-bcd7-492a-bb76-9afad057b053');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100550
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Исполнение работ'
,'Исполнение работ у заказчика'
,NULL
,'N'
,'N'
,'N'
,'Исполнение работ'
,NULL
,NULL
,0
,'N'
,'N'
,550
,100000
,'b9f60564-9280-49f7-835d-e0e49f53bdab');

INSERT INTO r_status 
(r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES
(100600
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Завершение работ'
,'Завершение работ у заказчика'
,NULL
,'N'
,'N'
,'N'
,'Завершение работ'
,NULL
,NULL
,0
,'N'
,'N'
,600
,100000
,'d9e1de27-bf0a-4084-a253-6a4d7f6d0305');

INSERT INTO r_status (r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES 
(100900
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Отменён исполнителем'
,'Отменён исполнителем работ'
,NULL
,'N'
,'N'
,'N'
,'Отменён исполнителем'
,NULL
,NULL
,0
,'N'
,'N'
,900
,100000
,'baab3234-9de7-4414-a22e-3d5d03fd4067');

INSERT INTO r_status (r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES 
(101000
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Исполнен'
,'Запрос исполнен'
,NULL
,'N'
,'N'
,'Y'
,'Исполнен'
,NULL
,NULL
,0
,'N'
,'Y'
,1000
,100000
,'8741a5f9-1836-4621-857c-e66ee9dec84c');

INSERT INTO r_status (r_status_id
,ad_client_id
,ad_org_id
,isactive
,created
,createdby
,updated
,updatedby
,name
,description
,help
,isdefault
,isopen
,isclosed
,value
,next_status_id
,update_status_id
,timeoutdays
,iswebcanupdate
,isfinalclose
,seqno
,r_statuscategory_id
,r_status_uu
) VALUES 
(102000
,0
,0
,'Y'
,to_date('2016-01-01','YYYY-MM-DD')
,0
,to_date('2016-01-01','YYYY-MM-DD')
,0
,'Отменён'
,'Запрос Отменён'
,NULL
,'N'
,'N'
,'Y'
,'Отменён'
,NULL
,NULL
,0
,'N'
,'Y'
,1000
,100000
,'e3a1c9f5-1d50-44f1-bd7a-38a420eda68a');
