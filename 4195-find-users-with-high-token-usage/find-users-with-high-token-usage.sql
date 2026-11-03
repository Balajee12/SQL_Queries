select
    user_id,
    prompt_count,
    avg_tokens
from (select
    user_id,
    tokens,
    count(prompt) as prompt_count,
    round(avg(tokens),2) as avg_tokens
from prompts
group by user_id
having prompt_count >= 3 and max(tokens) > avg(tokens) 
)a
order by avg_tokens desc, user_id asc; 