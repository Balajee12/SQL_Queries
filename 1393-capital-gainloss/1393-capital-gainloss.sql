with profit as(
    select
        stock_name,
        sum(case when operation = 'Buy' then price
        else 0
        end) as buyed,
        sum(case when operation = 'Sell' then price
        else 0
        end) as sold
from Stocks
group by stock_name
)
select
    stock_name,
    sold - buyed as capital_gain_loss
from profit;