---------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                       -- DECISIONS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --PYRAMID DECISIONS - CRITICAL WORKS COSTS
------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Budget: Bottom-Level Asset (seats) 


-- Decision 1: How much budget per seat is required to cover the cost of critical works on the seats?

select * from ucesatb.critical_works_seat_cost;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Middle-level Asset (stands)

--Decision 2. How much budget per stand is required to cover the cost of critical works per stands? 

select * from ucesatb.stand_costs;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Top-level Asset (stadium)

--Decision 3. How much is the annual cost for interventions of stadium in critical condition?

select * from ucesatb.critical_works_stadium;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Budget:
--Decision 4: Due to budget constraints this year, we can either refurbish all the foodcourts or all the bars. 
              --Therefore, we need to find out if it is cheaper to refurbish foodcourt or the bar?

with
foodcourt_cost as
(select sum(st_area(a.location) * b.parameter_value) as foodcourt_cost_in_£
from ucesatb.facilities a , ucesatb.parameters b
where a.facility_type = 'foodcourt'
and b.parameter_type = 'cost'
and b.parameter_name = 'facilities'
and b.parameter_subname = 'total refurbishment'),

bar_cost as
(select sum(st_area(a.location) * b.parameter_value) as bar_cost_in_£
from ucesatb.facilities a , ucesatb.parameters b
where a.facility_type = 'bar'
and b.parameter_type = 'cost'
and b.parameter_name = 'facilities'
and b.parameter_subname = 'total refurbishment')

select e.foodcourt_cost_in_£, f.bar_cost_in_£, e.foodcourt_cost_in_£ < f.bar_cost_in_£ as foodcourt_cheaper_than_bar
from foodcourt_cost e, bar_cost f;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Stadium Capacity:
-- Decision 5:       Due to the ongoing pandemic, the Government has asked to reduce the strength of spectators in the stadium to follow social distancing norms.
                     --However, this impacts the functioning of stadium as lesser tickets will be sold. The price deciding committee wants to know the strength
                     --of the each stand at full occupancy and quarter occupancy, so that ticket prices can be increased accordingly. 


with stand_strength as
(select  st_area(location) as total_area, floor(st_area(location)/

(select parameter_value from 
ucesatb.latest_parameters where parameter_type ='comfort' 
and parameter_name = 'stadium' and 
parameter_subname = 'stands space requirements per person')) as full_strength, 
floor((st_area(location)/(select parameter_value from
ucesatb.latest_parameters where parameter_type ='comfort' 
and parameter_name = 'stadium' and 
parameter_subname = 'stands space requirements per person'))* 0.25) as quarter_strength
from ucesatb.stands)

select * from stand_strength;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Human Comfort and Safety: 
--Decision 6: Floodlights is an important asset for conducting day/night matches.
                             --Do we need to replace any floodlight this year? We need to replace them if they are overdue for replacement. 

select * from ucesatb.floodlights_condition_criticality_cost
where asset_health_indicator_description like '%overdue%';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Human Comfort and Safety :
--Decision 7: The Government has given a fund of 50,000 to install 50 sofas for the VIP box. Is the allocated fund sufficient to complete the task?

with latest_value as(
select parameter_value from
ucesatb.latest_parameters where parameter_type ='cost' 
and parameter_name = 'seats' and 
parameter_subname = 'sofa'),
	
count_sofa as (select floor(50000/parameter_value) as number_sofas from latest_value)

	select a.number_sofas = 100 as is_budget_sufficient from count_sofa a;














