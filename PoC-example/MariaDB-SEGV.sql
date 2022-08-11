CREATE TABLE v(t1 INT, pk INT, KEY(t1), KEY pk using btree (pk), KEY v using btree(t1, pk)) engine=memory;
HANDLER v OPEN;
HANDLER v READ t1=(2) limit 3;
HANDLER v READ pk PREV;
HANDLER v READ pk PREV;
