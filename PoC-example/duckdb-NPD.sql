CREATE TABLE strings(a INTEGER);
CREATE TABLE c0(test2 tinyint, s1 smallint, s2 integer, test1 bigint, i double, id real, c1 varchar);
SELECT * FROM c0 s1 INNER JOIN c0 s2 ON (SELECT s1.s2=s2 FROM c0 WHERE s2.s2=s2) ORDER BY s1.s2;
