create table domains (
 id    INT auto_increment,
 name    VARCHAR(255) NOT NULL,
 master    VARCHAR(128) DEFAULT NULL,
 last_check  INT DEFAULT NULL,
 type    VARCHAR(6) NOT NULL,
 notified_serial INT DEFAULT NULL,
 account         VARCHAR(40) DEFAULT NULL,
 primary key (id)
);
CREATE UNIQUE INDEX name_index ON domains(name);
CREATE TABLE records (
  id              INT auto_increment,
  domain_id       INT DEFAULT NULL,
  name            VARCHAR(255) DEFAULT NULL,
  type            VARCHAR(6) DEFAULT NULL,
  content         VARCHAR(255) DEFAULT NULL,
  ttl             INT DEFAULT NULL,
  prio            INT DEFAULT NULL,
  change_date     INT DEFAULT NULL,
  primary key(id),
  CONSTRAINT `records_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domains` (`id`) ON DELETE CASCADE
);
CREATE INDEX rec_name_index ON records(name);
CREATE INDEX nametype_index ON records(name,type);
CREATE INDEX domain_id ON records(domain_id);
