-- III. INSERT DATA

--1. Parameter tables
--1.1 seats parameters
insert into ucesatb.parameters(parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
values
('cost', 'seats', 'plastic chair',800, '£ per seat'),
('cost', 'seats', 'cushioned chair',1200, '£ per seat'),
('cost', 'seats', 'hammock',1300, '£ per seat'),
('cost', 'seats', 'sofa',1600, '£ per seat'),
('cost', 'seats', 'annual update - plastic chair', 300,'£ per seat'),
('cost', 'seats', 'annual update - cushioned chair', 400,'£ per seat'),
('cost', 'seats', 'annual update - hammock', 500,'£ per seat'),
('cost', 'seats', 'annual update - sofa', 800,'£ per seat');


--1.2 facilities parameters
insert into ucesatb.parameters(parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
values
('cost', 'facilities', 'total refurbishment', 25000, '£ per facility');


--1.3 floodlights parameters
insert into ucesatb.parameters(parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
values
('enegrgy consumption cost', 'floodlights', 'LED', 1740, '£ per month'),
('energy consumption cost', 'floodlights', 'halogen', 17400, '£ per month'),
('cost', 'floodlights', 'LED', 25000, '£ per floodlight'),
('cost', 'floodlights', 'halogen', 16000, '£per  floodlight'),
('energyy saving', 'floodlights','LED', 9000, 'kwh per month');

--1.4 comfort parameters
insert into ucesatb.parameters(parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
values
('comfort', 'stadium', 'stands space requirements per person',5, 'sq m');


--1.5 relative weightings for the different components of the seat assessment
insert into ucesatb.parameters
(parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
values
('weighting', 'seats','sitting_area_condition',4,''),
('weighting', 'seats','leg_condition',4,''),
('weighting', 'seats','armrest_condition',2,''),
('weighting', 'seats','recliner_condition',3,''),
('weighting', 'seats','cupholder_condition',1,'');

--1.6 relative weightings for the different components of the stands assessment 
insert into ucesatb.parameters
(parameter_type, parameter_name, parameter_subname, parameter_value, parameter_units)
values
('weighting', 'stands','arch_condition',2,''),
('weighting', 'stands','door_gate_condition',2,''),
('weighting', 'stands','banner_condition',1,''),
('weighting', 'stands','stairs_condition',4,''),
('weighting', 'stands','handrail_condition',4,''),
('weighting', 'stands','disabled_access_condition',3,'');


--2. Lookup tables

--2.1 asset_health_indicator

insert into ucesatb.asset_health_indicator(asset_health_indicator_id, asset_health_indicator_description)
values
(1, 'As new or in good serviceable condition'),
(2, 'Deteriorating, evidence of high usage, age, additional maintenance costs and inefficiency'),
(3, 'Requires replacement within 5 years'),
(4, 'In poor condition, overdue for replacement'),
(5, 'Unable to determine condition (e.g. as item is hidden)'),
(6, 'Item does not exist');


--2.2 criticality 
 
insert into ucesatb.criticality (criticality_id, criticality)
values
(1, 'Insignificant consequences if it fails'),
(2, 'Minor consequences (e.g. to a few people or a small part of the business) if it fails'),
(3, 'Serious consequences if it fails – i.e. to a large number of people or a key component of the business'),
(4, 'Critical – the stadium cannot operate if this fails');


--2.3 users 

insert into ucesatb.users (user_name) 
select concat('user',g.id) 
from generate_series(1, 4) as g (id) ;


--3. Asset tables

--3.1 stadium:1
insert into ucesatb.stadium(stadium_name,year_founded,founder_name,  location, criticality)
values ('Lords: Home of Cricket','1851','Pratibha Patel',  st_geomfromtext('POLYGON ((0 0, 1000 0, 1000 1000, 0 1000, 0 0 ))',27700),(select criticality_id from ucesatb.criticality where criticality like  '%Critical%'));


--3.2 stands:4
--3.2.1 stand 1

insert into ucesatb.stands(stand_name, stadium_id, criticality, location)
values ('Stand 1', (select stadium_id from ucesatb.stadium b where st_intersects(b.location,
st_geomfromtext('POLYGON((100 100 0, 300 100 0, 300 900 0, 100 900 0, 100 100 0))',27700))),(select criticality_id from ucesatb.criticality where criticality like  '%Serious%'),
st_extrude(st_geomfromtext('POLYGON  ((100 100 0, 300 100 0, 300 900 0, 100 900 0, 100 100 0  ))',27700),0,0,400 ));


--3.2.2 stand 2
insert into ucesatb.stands(stand_name, stadium_id, criticality, location)
values ('Stand 2', (select stadium_id from ucesatb.stadium b where st_intersects(b.location,
st_geomfromtext('POLYGON((300 100 0, 900 100 0, 900 300 0, 300 300 0, 300 100 0))',27700))),(select criticality_id from ucesatb.criticality where criticality like  '%Serious%'),
st_extrude(st_geomfromtext('POLYGON  ((300 100 0, 900 100 0, 900 300 0, 300 300 0, 300 100 0  ))',27700),  0,0,400   ));


--3.2.3 stand 3
insert into ucesatb.stands(stand_name, stadium_id, criticality, location)
values ('Stand 3', (select stadium_id from ucesatb.stadium b where st_intersects(b.location,
st_geomfromtext('POLYGON((700 300 0, 900 300 0, 900 900 0, 700 900 0, 700 300 0  ))',27700))),(select criticality_id from ucesatb.criticality where criticality like  '%Serious%'),
st_extrude(st_geomfromtext('POLYGON  ((700 300 0, 900 300 0, 900 900 0, 700 900 0, 700 300 0    ))',27700),  0,0,400    ));

--3.2.4 stand 4
insert into ucesatb.stands(stand_name, stadium_id, criticality, location)
values ('Stand 4', (select stadium_id from ucesatb.stadium b where st_intersects(b.location,
st_geomfromtext('POLYGON((300 700 0, 700 700 0, 700 900 0, 300 900 0, 300 700 0))',27700))),(select criticality_id from ucesatb.criticality where criticality like  '%Serious%'),
st_extrude(st_geomfromtext('POLYGON  ((300 700 0, 700 700 0, 700 900 0, 300 900 0, 300 700 0  ))',27700), 0,0,400     ));



--3.3 seats 
--plasctic chairs is critical because majority of the seating area has plastic chairs, cushioned chair- serious, sofa- serious (supreme chairs, fetch higher ticket price), hammock- minor  

--3.3.1 seats for stand 1

insert into ucesatb.seats(floor, seat_number, location, criticality, seat_type, seat_installation_date)
values
(0, 'G.07', st_geomfromtext('POINT( 200 250 0)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'),
'plastic chair', '02-10-2018'),
(1, '1.05', st_geomfromtext('POINT(150 370 200)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'),
'plastic chair', '07-12-2019'),
(0, 'G.101', st_geomfromtext('POINT(250 500 0)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'),
'plastic chair', '10-10-2016');


--3.3.2 seats for stand 2
insert into ucesatb.seats(floor, seat_number, location, criticality, seat_type, seat_installation_date)
values
(1, '1.201', st_geomfromtext('POINT( 400 150 200)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Serious%'),
'cushioned chair', '1-10-2018'),
(1, '1.09', st_geomfromtext('POINT(600 250 200)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Serious%'),
'sofa',  '05-15-2019'),
(0, 'G.117', st_geomfromtext('POINT(350 200 0)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Minor%'),
'hammock', '12-08-2021');

--3.3.3 seats for stand 3
insert into ucesatb.seats(floor, seat_number, location, criticality, seat_type, seat_installation_date)
values
(1, '1.214', st_geomfromtext('POINT( 850 600 200)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'),
'plastic chair', '07-07-2017'),
(0, 'G.77', st_geomfromtext('POINT(800 750 0)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Serious%'),
'cushioned chair',  '07-29-2020'),
(0, 'G.199', st_geomfromtext('POINT(875 350 0)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Serious%'),
'cushioned chair', '11-09-2021');

--3.3.4 seats for stand 4
insert into ucesatb.seats(floor, seat_number, location, criticality, seat_type, seat_installation_date)
values
(1, '1.301', st_geomfromtext('POINT( 550 750 200)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'),
'plastic chair', '09-08-2011'),
(0, 'G.56', st_geomfromtext('POINT(675 800 0)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Serious%'),
'sofa',  '01-31-2021'),
(1, '1.369', st_geomfromtext('POINT(690 875 200)',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'),
'plastic chair', '5-01-2022');


--3.4 floodlights 1, stand1 
--all floodlights have criticality of serious as the stadium can't host day/night matches without floodlights
insert into ucesatb.floodlights (floodlight_number, floodlight_type,floodlight_make, floodlight_installation_date, location, criticality)
values
('F.01','LED','Siteco', '12-20-2012', st_geomfromtext('POINT(125 500 400)', 27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'));

--3.4.2 floodlights, stand 2
insert into ucesatb.floodlights (floodlight_number, floodlight_type, floodlight_make, floodlight_installation_date, location, criticality)
values
('F.02','halogen', 'Siteco', '08-20-2008', st_geomfromtext('POINT(500 200 400)', 27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'));


--3.4.3 floodlights, stand 3
insert into ucesatb.floodlights (floodlight_number, floodlight_type, floodlight_make,floodlight_installation_date, location, criticality)
values
('F.03','halogen','Siteco', '02-17-2015', st_geomfromtext('POINT(875 475 400)', 27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'));


--3.4.4
insert into ucesatb.floodlights (floodlight_number,floodlight_type, floodlight_make, floodlight_installation_date, location, criticality)
values
('F.04','halogen','Siteco', '05-09-2016', st_geomfromtext('POINT(450 825 400)', 27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%'));



--3.5 facilities
--3.5.1 
insert into ucesatb.facilities (facility_type, floor,  facility_number, location, criticality, stand_id)
values
('washroom', 1, '1.02', st_geomfromtext('POLYGON((700 100 200, 850 100 200, 850 250 200, 700 250 200, 700 100 200))',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%')
,( select stand_id from ucesatb.stands a where st_3dintersects(a.location, st_geomfromtext('POLYGON((700 100 200, 850 100 200, 850 250 200, 700 250 200, 700 100 200))',27700))));

--3.5.2
insert into ucesatb.facilities (facility_type, floor,  facility_number, location, criticality, stand_id)
values
('foodcourt', 1, '1.01', st_geomfromtext('POLYGON((150 550 200,270 550 200, 270 800 200, 150 800 200, 150 550 200))',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%')
,( select stand_id from ucesatb.stands a where st_3dintersects(a.location, st_geomfromtext('POLYGON((150 550 200,270 550 200, 270 800 200, 150 800 200, 150 550 200))',27700))));

--3.5.3
insert into ucesatb.facilities (facility_type, floor,  facility_number, location, criticality, stand_id)
values
('pavilion', 0, 'G.01', st_geomfromtext('POLYGON((710 760 0, 790 760 0, 790 890 0, 710 890 0, 710 760 0))',27700),(select criticality_id from ucesatb.criticality where criticality like '%Critical%')
,( select stand_id from ucesatb.stands a where st_3dintersects(a.location, st_geomfromtext('POLYGON((710 760 0, 790 760 0, 790 890 0, 710 890 0, 710 760 0))',27700))));


--3.5.4
insert into ucesatb.facilities (facility_type, floor,  facility_number, location, criticality, stand_id)
values
('bar', 1, '1.03', st_geomfromtext('POLYGON((110 850 200, 140 850 200, 140 890 200, 110 890 200, 110 850 200))',27700),(select criticality_id from ucesatb.criticality where criticality like '%Minor%')
,( select stand_id from ucesatb.stands a where st_3dintersects(a.location, st_geomfromtext('POLYGON((110 850 200, 140 850 200, 140 890 200, 110 890 200, 110 850 200))',27700))));



--Update statements

--1. update seats to include stand_id
update ucesatb.seats a set stand_id = (select b.stand_id from ucesatb.stands b where st_3dintersects(a.location, b.location));

--2. update floodlights to include stand_id
update ucesatb.floodlights a set stand_id = (select b.stand_id from ucesatb.stands b where st_3dintersects(a.location, b.location));



--Insert Condition information
--1. stands condition information
--1.1 stand 1
insert into ucesatb.stand_condition
(stand_id, arch_condition,  door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition, user_id, report_date)
values
((select stand_id from ucesatb.stands where stand_name like '%Stand 1%'),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),  -- roof
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- door_gate
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- banner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%'), -- stairs
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- handrail
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- disabled
(select user_id from ucesatb.users where user_name = 'user1'),
'10-10-2021');

--1.2 stand 2
insert into ucesatb.stand_condition
(stand_id, arch_condition,  door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition, user_id, report_date)
values
((select stand_id from ucesatb.stands where stand_name like '%Stand 2%'),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- roof
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- door_gate
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- banner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- stairs
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- handrail
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- disabled
(select user_id from ucesatb.users where user_name = 'user1'),
'08-17-2021');

--1.3 stand 3
insert into ucesatb.stand_condition
(stand_id, arch_condition,  door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition, user_id, report_date)
values
((select stand_id from ucesatb.stands where stand_name like '%Stand 3%'),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'),  -- roof
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- door_gate
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- banner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- stairs
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- handrail
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- disabled
(select user_id from ucesatb.users where user_name = 'user1'),
'09-09-2021');

--1.4 stand 4
insert into ucesatb.stand_condition
(stand_id, arch_condition,  door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition, user_id, report_date)
values
((select stand_id from ucesatb.stands where stand_name like '%Stand 4%'),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'),  -- roof
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- door_gate
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- banner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- stairs
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- handrail
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- disabled
(select user_id from ucesatb.users where user_name = 'user1'),
'12-12-2021');

--1.5 
insert into ucesatb.stand_condition
(stand_id, arch_condition,  door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition, user_id, report_date)
values
((select stand_id from ucesatb.stands where stand_name like '%Stand 1%'),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),  -- roof
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- door_gate
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- banner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- stairs
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- handrail
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%'), -- disabled
(select user_id from ucesatb.users where user_name = 'user1'),
'11-02-2022');

--1.5 stand 1
insert into ucesatb.stand_condition
(stand_id, arch_condition,  door_gate_condition, banner_condition, stairs_condition, handrail_condition, disabled_access_condition, user_id, report_date)
values
((select stand_id from ucesatb.stands where stand_name like '%Stand 1%'),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- roof
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- door_gate
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- banner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%'), -- stairs
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- handrail
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- disabled
(select user_id from ucesatb.users where user_name = 'user2'),
'04-10-2021');

--2. seat condition information


--1. seat G.07, floor 0, Stand 1, user 1
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = 'G.07' and floor = '0' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 1')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting_area
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- leg 
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user1'),
'04-11-2021');


--2. seat condition information
--seat 1.05, floor 1, Stand 1, user 1
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = '1.05' and floor = '1' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 1')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),  -- sitting_area
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- leg 
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user1'),
'08-12-2021');

--3 seat condition information
--seat G.101, floor 0, Stand 1, user 2
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = 'G.101' and floor = '0' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 1')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user2'),
'12-19-2021');

--4 seat condition information
--seat 1.201, floor 1, Stand 2, user 3
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = '1.201' and floor = '1' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 2')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user3'),
'11-25-2021');

--5 seat condition information
--seat 1.09, floor 1, Stand 2, user 3
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = '1.09' and floor = '1' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 2')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user3'),
'11-29-2021');

--6 seat condition information
--seat G.117, floor 0, Stand 2, user 4
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = 'G.117' and floor = '0' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 2')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user4'),
'11-20-2021');

--7 seat condition information
--seat 1.214, floor 1, Stand 3, user 4
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = '1.214' and floor = '1' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 3')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%5 years%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user4'),
'08-29-2021');

--8 seat condition information
--seat G.77, floor 0, Stand 3, user 4
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = 'G.77' and floor = '0' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 3')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user4'),
'01-07-2022');

--9 seat condition information
--seat G.199, floor 0, Stand 3, user 4
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = 'G.199' and floor = '0' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 3')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user4'),
'12-06-2021');

--10 seat condition information
--seat 1.301, floor 1, Stand 4, user 2
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = '1.301' and floor = '1' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 4')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%Unable%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user2'),
'07-09-2021');

--11 seat condition information
--seat G.56, floor 0, Stand 4, user 2
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = 'G.56' and floor = '0' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 4')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%does not%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user2'),
'01-05-2022');

--12 seat condition information
--seat 1.369, floor 1, Stand 4, user 1
insert into ucesatb.seat_condition
(seat_id, sitting_area_condition, leg_condition, armrest_condition, recliner_condition, cupholder_condition, user_id, report_date)
values
((select seat_id from ucesatb.seats where seat_number = '1.301' and floor = '1' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 4')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),  -- sitting
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- leg
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- armrest
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- recliner
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'), -- cupholder
(select user_id from ucesatb.users where user_name = 'user1'),
'12-07-2021');




--3. floodlights condition information

--3.1

insert into ucesatb.floodlight_condition 
(floodlight_id, condition, user_id, report_date)
values
((select floodlight_id from ucesatb.floodlights where floodlight_number = 'F.01' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 1')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%new%'),
(select user_id from ucesatb.users where user_name = 'user3'),
'12-25-2021');

--3.2 

insert into ucesatb.floodlight_condition 
(floodlight_id, condition, user_id, report_date)
values
((select floodlight_id from ucesatb.floodlights where floodlight_number = 'F.02' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 2')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),
(select user_id from ucesatb.users where user_name = 'user3'),
'11-22-2021');

--3.3 

insert into ucesatb.floodlight_condition 
(floodlight_id, condition, user_id, report_date)
values
((select floodlight_id from ucesatb.floodlights where floodlight_number = 'F.03' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 3')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'),
(select user_id from ucesatb.users where user_name = 'user2'),
'08-22-2021');

--3.4

insert into ucesatb.floodlight_condition 
(floodlight_id, condition, user_id, report_date)
values
((select floodlight_id from ucesatb.floodlights where floodlight_number = 'F.04' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 4')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%overdue%'),
(select user_id from ucesatb.users where user_name = 'user2'),
'12-31-2021');


--3.5 facility condition information
--3.5.1 

insert into ucesatb.facility_condition 
(facility_id, condition, user_id, report_date)
values
((select facility_id from ucesatb.facilities where facility_number = '1.01' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 1')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'),
(select user_id from ucesatb.users where user_name = 'user3'),
'09-17-2021');

--3.5.2

insert into ucesatb.facility_condition 
(facility_id, condition, user_id, report_date)
values
((select facility_id from ucesatb.facilities where facility_number = '1.02' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 2')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'),
(select user_id from ucesatb.users where user_name = 'user4'),
'09-10-2021');

--3.5.3

insert into ucesatb.facility_condition 
(facility_id, condition, user_id, report_date)
values
((select facility_id from ucesatb.facilities where facility_number = 'G.01' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 3')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'),
(select user_id from ucesatb.users where user_name = 'user2'),
'01-05-2022');

--3.5.4

insert into ucesatb.facility_condition 
(facility_id, condition, user_id, report_date)
values
((select facility_id from ucesatb.facilities where facility_number = '1.03' and stand_id = (select stand_id from ucesatb.stands where stand_name like '%Stand 1')),
(select asset_health_indicator_id from ucesatb.asset_health_indicator where asset_health_indicator_description like '%high usage%'),
(select user_id from ucesatb.users where user_name = 'user3'),
'12-21-2021');




