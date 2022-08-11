CREATE TABLE strings(b REAL, a INTEGER);
INSERT INTO strings VALUES
  (5, 10), (10, 20), (13, 26), (13, 26),
  (15, 30), (20, 40), (22,80), (30, 90);
CREATE TABLE id(c TEXT, strings_with_null INTEGER);
INSERT INTO id VALUES('c', NULL);
SELECT sum(a) OVER (
    PARTITION BY (
SELECT c FROM id WHERE strings_with_null=a
    ) ORDER BY a
  ) FROM strings;
