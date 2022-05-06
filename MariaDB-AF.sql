CREATE TABLE a (
  keyc SERIAL, b CHAR(255) NOT NULL DEFAULT '', c BOOLEAN DEFAULT false,
  sqlsim0 LINESTRING NOT NULL DEFAULT ST_linefromtext('linestring(448 -689)'),
  INDEX(b,c), SPATIAL INDEX `a`(sqlsim0)
) ENGINE=InnoDB;
SET unique_checks=0;
SET foreign_key_checks=0;
INSERT INTO a (keyc) VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
