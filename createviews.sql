--VIEWS

--1. View with latest parameter values

drop view if exists ucesatb.latest_parameters cascade;
create view ucesatb.latest_parameters as

with
latest_parameters as
(select parameter_type, parameter_name, parameter_subname, max(date_created) as date_created
from ucesatb.parameters
group by parameter_type, parameter_name, parameter_subname)

select a.parameter_id, a.parameter_value, b.* from ucesatb.parameters a inner join 
latest_parameters b
on a.parameter_type = b.parameter_type
and a.parameter_name = b.parameter_name
and a.parameter_subname = b.parameter_subname 
and a.date_created = b.date_created;

select * from ucesatb.latest_parameters;


--2. View with all the seats details

drop view if exists ucesatb.seats_criticality_cost cascade;
create view ucesatb.seats_criticality_cost as

--to get latest condition reports for each seat

with latest_report as
(select distinct on (seat_id) seat_id, user_id, report_date, sitting_area_condition, leg_condition,
armrest_condition, recliner_condition, cupholder_condition 
from ucesatb.seat_condition
order by seat_id,report_date desc),

-- find average condition for seats overall, apply weights to condition

condition_weights as
(select seat_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='seats' and parameter_subname ='sitting_area_condition') as weighting, sitting_area_condition as asset_health_indicator_id from latest_report 
union all
select seat_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='seats' and parameter_subname ='leg_condition') as weighting, leg_condition as asset_health_indicator_id from latest_report 
union all
select seat_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='seats' and parameter_subname ='armrest_condition') as weighting, armrest_condition as asset_health_indicator_id from latest_report 
union all
select seat_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='seats' and parameter_subname ='recliner_condition') as weighting, recliner_condition as asset_health_indicator_id from latest_report 
union all
select seat_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='seats' and parameter_subname ='cupholder_condition') as weighting, cupholder_condition as asset_health_indicator_id from latest_report),

--remove asset_health_indicator_id 5 and 6

condition_weights_no_missing as
(select * from condition_weights 
where asset_health_indicator_id not in (select asset_health_indicator_id 
from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%' or asset_health_indicator_description like '%Item does not%')),

-- find average after removing invalid readings

aggregated as
(select a.seat_id, sum(asset_health_indicator_id*weighting)/sum(weighting) as average_health_indicator_id
 from condition_weights_no_missing a
group by seat_id),

-- Round off the avg condition and see its descripton

seat_health as
(select a.*, b.asset_health_indicator_description, b.asset_health_indicator_id
from aggregated a left join ucesatb.asset_health_indicator b
on ceil(a.average_health_indicator_id) = b.asset_health_indicator_id),

--join condition status to latest condition report
--using inner joins

report_condition as 
(select a.seat_id, a.user_id, a.report_date, 
b.asset_health_indicator_description as sitting_area_condition,
c.asset_health_indicator_description as leg_condition,
d.asset_health_indicator_description as armrest_condition,
e.asset_health_indicator_description as recliner_condition,
f.asset_health_indicator_description as cupholder_condition
from latest_report a 
inner join ucesatb.asset_health_indicator b on a.sitting_area_condition = b.asset_health_indicator_id
inner join ucesatb.asset_health_indicator c on a.leg_condition = c.asset_health_indicator_id
inner join ucesatb.asset_health_indicator d on a.armrest_condition = d.asset_health_indicator_id
inner join ucesatb.asset_health_indicator e on a.recliner_condition = e.asset_health_indicator_id
inner join ucesatb.asset_health_indicator f on a.cupholder_condition = f.asset_health_indicator_id),

--link user information to report

report_user as
(select h.*, j.user_name
from report_condition h inner join ucesatb.users j
on h.user_id = j.user_id),

--join report information and seat information

seat_condition as
(select d.location, d.seat_number, d.seat_type, d.stand_id, d.criticality as criticality_id, f.* 
from ucesatb.seats d left join report_user f
on d.seat_id = f.seat_id),

--add the averages

seat_condition_and_all_health as
(select a.*, b.asset_health_indicator_id, b.asset_health_indicator_description
from seat_condition a left join seat_health b
on a.seat_id = b.seat_id),

--add cost information

seat_with_cost as
(select a.*,  b.parameter_subname, b.parameter_value as update_cost_seat
from seat_condition_and_all_health a left join ucesatb.latest_parameters b
on concat('annual update - ',a.seat_type) = b.parameter_subname
and b.parameter_type = 'cost'
and b.parameter_name = 'seats'),

--add criticality

criticality as
(select a.*, b.criticality
from seat_with_cost a inner join ucesatb.criticality b
on a.criticality_id = b.criticality_id)

select k.*, l.stand_name 
from criticality k inner join ucesatb.stands l
on k.stand_id = l.stand_id;

select * from ucesatb.seats_criticality_cost;


-- 3. View that links all stand information - criticality and invidiual and average scores

drop view if exists ucesatb.stand_condition_criticality;
create view ucesatb.stand_condition_criticality as
with latest_report as
(select distinct on (stand_id) stand_id, user_id, report_date, 
arch_condition, door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition 
from ucesatb.stand_condition
order by stand_id,report_date desc),

height_weights as
(select stand_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='stands' and parameter_subname ='arch_condition') as weighting, arch_condition as asset_health_indicator_id, 'arch_condition' as asset_component from latest_report 
union all
select stand_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='stands' and parameter_subname ='door_gate_condition') as weighting, door_gate_condition   as asset_health_indicator_id,'door_gate_condition' as asset_component from latest_report 
union all
select stand_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='stands' and parameter_subname ='banner_condition') as weighting, banner_condition   as asset_health_indicator_id,'banner_condition' as asset_component from latest_report 
union all
select stand_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='stands' and parameter_subname ='stairs_condition') as weighting, stairs_condition   as asset_health_indicator_id,'stairs_condition' as asset_component from latest_report 
union all
select stand_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='stands' and parameter_subname ='handrail_condition') as weighting, handrail_condition   as asset_health_indicator_id,'handrail_condition' as asset_component from latest_report 
union all
select stand_id, (select parameter_value from ucesatb.latest_parameters where parameter_type = 'weighting' and parameter_name ='stands' and parameter_subname ='disabled_access_condition') as weighting, disabled_access_condition   as asset_health_indicator_id,'disabled_access_condition' as asset_component from latest_report),
 
height_weights_no_missing as
(select * from height_weights 
where asset_health_indicator_id not in (select asset_health_indicator_id 
from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%' or asset_health_indicator_description like '%Item does not%')),

aggregated as
(select stand_id, sum(asset_health_indicator_id*weighting)/sum(weighting) as asset_health_indicator
 from height_weights_no_missing
group by stand_id),

stand_health as
(select a.*, b.asset_health_indicator_description
from aggregated a left join ucesatb.asset_health_indicator b
on ceil(a.asset_health_indicator) = b.asset_health_indicator_id),

report_condition as 
(select a.stand_id, a.user_id, a.report_date, 
b.asset_health_indicator_description as arch_condition,
c.asset_health_indicator_description as door_gate_condition,
d.asset_health_indicator_description as banner_condition,
e.asset_health_indicator_description as stairs_condition,
f.asset_health_indicator_description as handrail_condition,
g.asset_health_indicator_description as disabled_access_condition
from latest_report a 
inner join ucesatb.asset_health_indicator b on a.arch_condition = b.asset_health_indicator_id
inner join ucesatb.asset_health_indicator c on a.door_gate_condition = c.asset_health_indicator_id
inner join ucesatb.asset_health_indicator d on a.banner_condition = d.asset_health_indicator_id
inner join ucesatb.asset_health_indicator e on a.stairs_condition = e.asset_health_indicator_id
inner join ucesatb.asset_health_indicator f on a.handrail_condition = f.asset_health_indicator_id
inner join ucesatb.asset_health_indicator g on a.disabled_access_condition = g.asset_health_indicator_id),

report_user as
(select h.*, j.user_name
from report_condition h inner join ucesatb.users j
on h.user_id = j.user_id),

stand_condition as
(select d.location, d.stand_name, d.stadium_id, d.criticality as criticality_id, f.* 
from ucesatb.stands d inner join report_user f
on d.stand_id = f.stand_id),

stand_condition_and_all_health as
(select a.*, b.asset_health_indicator, b.asset_health_indicator_description
from stand_condition a left join stand_health b
on a.stand_id = b.stand_id),

criticality as
(select a.*, b.criticality
from stand_condition_and_all_health a inner join ucesatb.criticality b
on a.criticality_id = b.criticality_id)

select k.*, l.stadium_name 
from criticality k inner join ucesatb.stadium l
on k.stadium_id = l.stadium_id;

select * from ucesatb.stand_condition_criticality;


---4. floodlight table view

drop view if exists ucesatb.floodlights_condition_criticality_cost cascade;
create view ucesatb.floodlights_condition_criticality_cost as

with latest_report as
(select distinct on (floodlight_id) floodlight_id, user_id, report_date, condition
from ucesatb.floodlight_condition
order by floodlight_id,report_date desc),

report_condition as 
(select a.*, b.asset_health_indicator_description 
from latest_report a inner join ucesatb.asset_health_indicator b
on a.condition = b.asset_health_indicator_id),

report_user as
(select h.*, j.user_name
from report_condition h inner join ucesatb.users j
on h.user_id = j.user_id),

floodlight_condition as
(select d.floodlight_id, d.location, d.stand_id, d.floodlight_installation_date, d.floodlight_make,d.floodlight_type,d.floodlight_number, d.criticality as criticality_id, f.user_id, f.report_date, f.condition, f.asset_health_indicator_description, f.user_name
from ucesatb.floodlights d left join report_user f
on d.floodlight_id = f.floodlight_id),

floodlight_criticality as
(select a.criticality, b.* 
from floodlight_condition b left join ucesatb.criticality a
on a.criticality_id = b.criticality_id),

floodlight_stands as
(select a.stand_name,b.*
	 from ucesatb.stands a inner join floodlight_criticality b
	 on a.stand_id=b.stand_id),

floodlight_cost as
	(select a.*, b.parameter_value as cost_per_floodlight
	 from ucesatb.floodlights a inner join ucesatb.latest_parameters b
	 on a.floodlight_type = b.parameter_subname
	 and b.parameter_name ='floodlights'
	 and b.parameter_type='cost')

select a.*, b.cost_per_floodlight

from floodlight_stands a inner join floodlight_cost b
on a.floodlight_id = b.floodlight_id;

select * from ucesatb.floodlights_condition_criticality_cost;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
                                            -- Views for pyramid nesting

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Budget            
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Decision 1: How much budget per seat is required to cover the cost of critical works on the seats? 

drop view if exists ucesatb.critical_works_seat_cost cascade;
create view ucesatb.critical_works_seat_cost as

select update_cost_seat,  seat_number, seat_type, seat_id from ucesatb.seats_criticality_cost 
where criticality = 'Critical – the stadium cannot operate if this fails' and asset_health_indicator_description = 'In poor condition, overdue for replacement';
 
select * from ucesatb.critical_works_seat_cost;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

--Decision 2: How much budget per stand is required to cover the cost of critical works per stands? 

drop view if exists ucesatb.stand_costs cascade;
create view ucesatb.stand_costs as
(with seat_stand as (
select a.stand_id, b.update_cost_seat as seats_cost 
from ucesatb.seats a left join ucesatb.critical_works_seat_cost b
on a.seat_id = b.seat_id),

seat_stand_cost as (select sum(seats_cost) as seat_stand_cost, stand_id from seat_stand
				   group by stand_id)
select a.*, (case when b.seat_stand_cost is null then 0 else b.seat_stand_cost end) as stand_cost
from ucesatb.stands a left join seat_stand_cost b
on a.stand_id = b.stand_id);

select * from ucesatb.stand_costs;

------------------------------------------------------------------------------------------------------------------------------------------------------------

--Decision 3:. How much is the annual cost for interventions of stadium in critical condition?

drop view if exists ucesatb.critical_works_stadium cascade;
create view ucesatb.critical_works_stadium as
select sum(stand_cost) as annual_intervention_cost
from ucesatb.stand_costs;

select * from ucesatb.critical_works_stadium;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


























































