The coverage branch count of these fuzzers on different DBMS (12 hours, 5 times)

|                          | DBMS         | SQLite                                                                                                  | DuckDB                                                                                                  | MariaDB                                                                                                                | PostgreSQL                                                                                                             |
| ------------------------ | ------------ | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Exp Version**          |              | v1.0                                                                                                    | v0.0                                                                                                    | v1.1                                                                                                                   | TODO                                                                                                                   |
| **Brancg Count**         | Griffin      | 21756, 21694, 21699, 21730, 21735, 21672, 21575, 21717, 21729, 19631, 21695, 21750, 21738, 21714, 21502 | 30752, 30520, 30562, 30661, 30543, 29486, 29400, 29544, 29526, 29472, 29349, 29473, 29451, 29376, 29609 | 119868, 117286, 120926, 120510, 121231, 120043, 121010, 120602, 119908, 119939, 120368, 119245, 118825, 120957, 119999 | 114654, 116971, 115330, 113471, 114631, 115347, 116949, 115047, 111931, 115245, 119176, 118283, 116735, 116291, 112632 |
|                          | Squirrel     | 16120, 16264, 16761, 16119, 16215, 14724, 15025, 14666, 14926, 16253, 15258, 14401, 14511, 14898, 15100 | N/A                                                                                                     | 54495, 54966, 52587, 52113, 55163, 49147, 52579, 51162, 50975, 50895, 50397, 54711, 52077, 53829, 53866                | 38728, 38558, 40670, 39145, 38930, 35955, 37321, 38421, 36740, 38161, 38857, 37886, 39159, 38337, 39214                |
|                          | SQLsmith     | 5262, 5262, 5254, 5263, 5259, 5256, 5261, 5260, 5262, 5255, 5259, 5254, 5256, 5256, 5254                | 11891, 11988, 11967, 12030, 11896, 12093, 12076, 12065, 12111, 12017, 12012, 12071, 12032, 12134, 12024 | N/A                                                                                                                    | 63094, 64166, 63601, 63771, 63338, 65234, 64649, 64455, 64658, 64023, 63904, 62871, 62346, 63993, 62973                |
|                          | SQLancer     | 11808, 11687, 11774, 11719, 11598, 12483, 12506, 12545, 12361, 12559, 12499, 12445, 12328, 12389, 12516 | 7915, 7955, 7892, 7933, 7954, 7880, 7856, 7916, 7859, 7775, 7907, 7856, 7846, 7834, 7835                | 46374, 46197, 46193, 46275, 46055, 45916, 45998, 46266, 46184, 46164, 45835, 46026, 45931, 45942, 46115                | 66588, 66932, 66900, 66955, 66889, 66335, 66716, 66496, 66262, 66377, 66499, 66253, 66771, 66488, 66422                |
| **p-value: Griffin**     | vs. Squirrel | 0.00000001289                                                                                           | N/A                                                                                                     | 0.00000001289                                                                                                          | 0.00000001289                                                                                                          |
|                          | vs. SQLsmith | 0.000003283                                                                                             | 0.00000001289                                                                                           | N/A                                                                                                                    | 0.00000001289                                                                                                          |
|                          | vs. SQLancer | 0.00000001289                                                                                           | 0.000003383                                                                                             | 0.00000001289                                                                                                          | 0.00000001289                                                                                                          |
| **effect size: Griffin** | vs. Squirrel | 1                                                                                                       | N/A                                                                                                     | 1                                                                                                                      | 1                                                                                                                      |
|                          | vs. SQLsmith | 1                                                                                                       | 1                                                                                                       | N/A                                                                                                                    | 1                                                                                                                      |
|                          | vs. SQLancer | 1                                                                                                       | 1                                                                                                       | 1                                                                                                                      | 1                                                                                                                      |

### Statistical test

```R
sqlite_griffin = c(21756, 21694, 21699, 21730, 21735, 21672, 21575, 21717, 21729, 19631, 21695, 21750, 21738, 21714, 21502)
sqlite_squirrel = c(16120, 16264, 16761, 16119, 16215, 14724, 15025, 14666, 14926, 16253, 15258, 14401, 14511, 14898, 15100)
sqlite_sqlsmith = c(5262, 5262, 5254, 5263, 5259, 5256, 5261, 5260, 5262, 5255, 5259, 5254, 5256, 5256, 5254)
sqlite_sqlancer = c(11808, 11687, 11774, 11719, 11598, 12483, 12506, 12545, 12361, 12559, 12499, 12445, 12328, 12389, 12516)

duckdb_griffin = c(30752, 30520, 30562, 30661, 30543, 29486, 29400, 29544, 29526, 29472, 29349, 29473, 29451, 29376, 29609)
duckdb_sqlsmith = c(11891, 11988, 11967, 12030, 11896, 12093, 12076, 12065, 12111, 12017, 12012, 12071, 12032, 12134, 12024)
duckdb_sqlancer = c(7915, 7955, 7892, 7933, 7954, 7880, 7856, 7916, 7859, 7775, 7907, 7856, 7846, 7834, 7835)

mariadb_griffin = c(119868, 117286, 120926, 120510, 121231, 120043, 121010, 120602, 119908, 119939, 120368, 119245, 118825, 120957, 119999)
mariadb_squirrel = c(54495, 54966, 52587, 52113, 55163, 49147, 52579, 51162, 50975, 50895, 50397, 54711, 52077, 53829, 53866)
mariadb_sqlancer = c(46374, 46197, 46193, 46275, 46055, 45916, 45998, 46266, 46184, 46164, 45835, 46026, 45931, 45942, 46115)

postgres_griffin = c(114654, 116971, 115330, 113471, 114631, 115347, 116949, 115047, 111931, 115245, 119176, 118283, 116735, 116291, 112632)
postgres_squirrel = c(38728, 38558, 40670, 39145, 38930, 35955, 37321, 38421, 36740, 38161, 38857, 37886, 39159, 38337, 39214)
postgres_sqlsmith = c(63094, 64166, 63601, 63771, 63338, 65234, 64649, 64455, 64658, 64023, 63904, 62871, 62346, 63993, 62973)
postgres_sqlancer = c(66588, 66932, 66900, 66955, 66889, 66335, 66716, 66496, 66262, 66377, 66499, 66253, 66771, 66488, 66422)

wilcox.test(sqlite_griffin, sqlite_squirrel)
wilcox.test(sqlite_griffin, sqlite_sqlsmith)
wilcox.test(sqlite_griffin, sqlite_sqlancer)

wilcox.test(duckdb_griffin, duckdb_sqlsmith)
wilcox.test(duckdb_griffin, duckdb_sqlancer)

wilcox.test(mariadb_griffin, mariadb_squirrel)
wilcox.test(mariadb_griffin, mariadb_sqlancer)

wilcox.test(postgres_griffin, postgres_squirrel)
wilcox.test(postgres_griffin, postgres_sqlsmith)
wilcox.test(postgres_griffin, postgres_sqlancer)


library('effsize')
library(crayon)

"sqlite: [squirrel, sqlsmith, sqlancer]"
VD.A(sqlite_griffin, sqlite_squirrel)
VD.A(sqlite_griffin, sqlite_sqlsmith)
VD.A(sqlite_griffin, sqlite_sqlancer)

"duckdb: [sqlsmith, sqlancer]"
VD.A(duckdb_griffin, duckdb_sqlsmith)
VD.A(duckdb_griffin, duckdb_sqlancer)

"mariadb: [squirrel, sqlancer]"
VD.A(mariadb_griffin, mariadb_squirrel)
VD.A(mariadb_griffin, mariadb_sqlancer)

"postgres: [squirrel, sqlsmith, sqlancer]"
VD.A(postgres_griffin, postgres_squirrel)
VD.A(postgres_griffin, postgres_sqlsmith)
VD.A(postgres_griffin, postgres_sqlancer)

md_sqlite_griffin = median(sqlite_griffin)
md_sqlite_squirrel = median(sqlite_squirrel)
md_sqlite_sqlsmith = median(sqlite_sqlsmith)
md_sqlite_sqlancer = median(sqlite_sqlancer)

md_duckdb_griffin = median(duckdb_griffin)
md_duckdb_sqlsmith = median(duckdb_sqlsmith)
md_duckdb_sqlancer = median(duckdb_sqlancer)

md_mariadb_griffin = median(mariadb_griffin)
md_mariadb_squirrel = median(mariadb_squirrel)
md_mariadb_sqlancer = median(mariadb_sqlancer)

md_postgres_griffin = median(postgres_griffin)
md_postgres_squirrel = median(postgres_squirrel)
md_postgres_sqlsmith = median(postgres_sqlsmith)
md_postgres_sqlancer = median(postgres_sqlancer)

ir = function(x, y) {
    return ((y - x) / x)
}

# md = median_branch_coverage
# ir = improve_ratio
ir_sqlite_sqlsmith = ir(md_sqlite_sqlsmith, md_sqlite_griffin)
ir_sqlite_sqlancer = ir(md_sqlite_sqlancer, md_sqlite_griffin)
ir_sqlite_squirrel = ir(md_sqlite_squirrel, md_sqlite_griffin)

ir_duckdb_sqlsmith = ir(md_duckdb_sqlsmith, md_duckdb_griffin)
ir_duckdb_sqlancer = ir(md_duckdb_sqlancer, md_duckdb_griffin)

ir_mariadb_sqlancer = ir(md_mariadb_sqlancer, md_mariadb_griffin)
ir_mariadb_squirrel = ir(md_mariadb_squirrel, md_mariadb_griffin)

ir_postgres_sqlsmith = ir(md_postgres_sqlsmith, md_postgres_griffin)
ir_postgres_sqlancer = ir(md_postgres_sqlancer, md_postgres_griffin)
ir_postgres_squirrel = ir(md_postgres_squirrel, md_postgres_griffin)

cat("sqlite   griffin (median): ", md_sqlite_griffin,   ", improvement vs (sqlsmith, sqlancer, squirrel) = ", 
ir_sqlite_sqlsmith,
ir_sqlite_sqlancer,
ir_sqlite_squirrel, "\n")

cat("duckdb   griffin (median): ", md_duckdb_griffin,   ", improvement vs (sqlsmith, sqlancer) = ", 
ir_duckdb_sqlsmith,
ir_duckdb_sqlancer, "\n")

cat("mariadb  griffin (median): ", md_mariadb_griffin,  ", improvement vs (sqlancer, squirrel) = ", 
ir_mariadb_sqlancer,
ir_mariadb_squirrel, "\n")

cat("postgres griffin (median): ", md_postgres_griffin, ", improvement vs (sqlsmith, sqlancer, squirrel) = ", 
ir_postgres_sqlsmith,
ir_postgres_sqlancer,
ir_postgres_squirrel, "\n")


cat("\n")

cat("sqlite griffin improve range = ", min(ir_sqlite_sqlsmith,
ir_sqlite_sqlancer,
ir_sqlite_squirrel), max(ir_sqlite_sqlsmith,
ir_sqlite_sqlancer,
ir_sqlite_squirrel), "\n")

cat("duckdb griffin improve range = ", min(ir_duckdb_sqlsmith,
ir_duckdb_sqlancer), max(ir_duckdb_sqlsmith,
ir_duckdb_sqlancer), "\n")

cat("mariadb griffin improve range = ", min(
ir_mariadb_sqlancer,
ir_mariadb_squirrel), max(
ir_mariadb_sqlancer,
ir_mariadb_squirrel), "\n")

cat("postgres griffin improve range = ", min(ir_postgres_sqlsmith,
ir_postgres_sqlancer,
ir_postgres_squirrel), max(ir_postgres_sqlsmith,
ir_postgres_sqlancer,
ir_postgres_squirrel), "\n")


cat("\n")

cat("sqlsmith griffin improve range = ", 
min(ir_sqlite_sqlsmith, ir_duckdb_sqlsmith, ir_postgres_sqlsmith), 
max(ir_sqlite_sqlsmith, ir_duckdb_sqlsmith, ir_postgres_sqlsmith), "\n")

cat("sqlancer griffin improve range = ", 
min(ir_sqlite_sqlancer, ir_duckdb_sqlancer, ir_mariadb_sqlancer, ir_postgres_sqlancer),
max(ir_sqlite_sqlancer, ir_duckdb_sqlancer, ir_mariadb_sqlancer, ir_postgres_sqlancer), "\n")

cat("squirrel griffin improve range = ", 
min(ir_sqlite_squirrel, ir_mariadb_squirrel, ir_postgres_squirrel),
max(ir_sqlite_squirrel, ir_mariadb_squirrel, ir_postgres_squirrel), "\n")
```

### result
```
Wilcoxon rank sum exact test

data:  sqlite_griffin and sqlite_squirrel
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum test with continuity correction

data:  sqlite_griffin and sqlite_sqlsmith
W = 225, p-value = 3.283e-06
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(sqlite_griffin, sqlite_sqlsmith) :
  cannot compute exact p-value with ties

	Wilcoxon rank sum exact test

data:  sqlite_griffin and sqlite_sqlancer
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum exact test

data:  duckdb_griffin and duckdb_sqlsmith
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum test with continuity correction

data:  duckdb_griffin and duckdb_sqlancer
W = 225, p-value = 3.383e-06
alternative hypothesis: true location shift is not equal to 0

Warning message:
In wilcox.test.default(duckdb_griffin, duckdb_sqlancer) :
  cannot compute exact p-value with ties

	Wilcoxon rank sum exact test

data:  mariadb_griffin and mariadb_squirrel
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum exact test

data:  mariadb_griffin and mariadb_sqlancer
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum exact test

data:  postgres_griffin and postgres_squirrel
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum exact test

data:  postgres_griffin and postgres_sqlsmith
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0


	Wilcoxon rank sum exact test

data:  postgres_griffin and postgres_sqlancer
W = 225, p-value = 1.289e-08
alternative hypothesis: true location shift is not equal to 0

[1] "sqlite: [squirrel, sqlsmith, sqlancer]"

Vargha and Delaney A

A estimate: 1 (large)


Vargha and Delaney A

A estimate: 1 (large)


Vargha and Delaney A

A estimate: 1 (large)

[1] "duckdb: [sqlsmith, sqlancer]"

Vargha and Delaney A

A estimate: 1 (large)


Vargha and Delaney A

A estimate: 1 (large)

[1] "mariadb: [squirrel, sqlancer]"

Vargha and Delaney A

A estimate: 1 (large)


Vargha and Delaney A

A estimate: 1 (large)

[1] "postgres: [squirrel, sqlsmith, sqlancer]"

Vargha and Delaney A

A estimate: 1 (large)


Vargha and Delaney A

A estimate: 1 (large)


Vargha and Delaney A

A estimate: 1 (large)

sqlite   griffin (median):  21714 , improvement vs (sqlsmith, sqlancer, squirrel) =  3.128922 0.7526838 0.4380132 
duckdb   griffin (median):  29526 , improvement vs (sqlsmith, sqlancer) =  1.454364 2.746954 
mariadb  griffin (median):  120043 , improvement vs (sqlancer, squirrel) =  1.603123 1.283098 
postgres griffin (median):  115330 , improvement vs (sqlsmith, sqlancer, squirrel) =  0.8047384 0.7343118 1.991078 

sqlite griffin improve range =  0.4380132 3.128922 
duckdb griffin improve range =  1.454364 2.746954 
mariadb griffin improve range =  1.283098 1.603123 
postgres griffin improve range =  0.7343118 1.991078 

sqlsmith griffin improve range =  0.8047384 3.128922 
sqlancer griffin improve range =  0.7343118 2.746954 
squirrel griffin improve range =  0.4380132 1.991078 
```