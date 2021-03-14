from int x, int y
where x = 3 and y in [0 .. 2]
select x, y, x * y as product, "product: " + product
as res order by  res desc