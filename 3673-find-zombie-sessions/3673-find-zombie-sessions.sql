with selected as(
select
    session_id,
    user_id,
    min(event_timestamp)as min_tim,
    max(event_timestamp) as max_tim,
    sum(case when event_type = 'purchase' then 1 else 0 end) as purchase_count,
    sum(case when event_type = 'scroll' then 1 else 0 end) as scroll_count,
    sum(case when event_type = 'click' then 1 else 0 end) as click_count
from app_events
group by session_id
),
repeated as(
    select
        session_id,
        user_id,
        purchase_count,
        scroll_count,
        click_count,
        TIMESTAMPDIFF(MINUTE, min_tim, max_tim) as session_duration_minutes,
        click_count / scroll_count as click_ratio
    from selected
    where purchase_count = 0 and click_count / scroll_count  < 0.20 
)
select
    session_id,
    user_id,
    session_duration_minutes,
    scroll_count
from repeated
where session_duration_minutes > 30 and scroll_count >= 5
order by scroll_count desc, session_id asc;