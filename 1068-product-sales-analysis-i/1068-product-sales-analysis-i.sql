select product_name, year, price
from Product P 
join Sales S on S.product_id = P.product_id;