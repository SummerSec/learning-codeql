from int x
where x in [-5 .. 5] and x != 0
select unique(int y | y = x or y = x.abs() | y)