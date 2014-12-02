INSERT INTO domains VALUES(1, 'test.loc','ns1.test.loc',NULL,'NATIVE',NULL,'noauth-project');
INSERT INTO records VALUES(1,1,'test.loc','NS','ns1.test.loc',3600,NULL,NULL,0,NULL,1);
INSERT INTO records VALUES(2,1,'test.loc','SOA','ns1.test.loc. admin.test.loc. 1416510558 3600 600 86400 3600',3600,NULL,NULL,0,NULL,1);
INSERT INTO records VALUES(3,1,'mars.test.loc','A','10.10.10.2',3600,NULL,NULL,0,NULL,1);
INSERT INTO records VALUES(4,1,'venus.test.loc','A','10.10.10.3',3600,NULL,NULL,0,NULL,1);
