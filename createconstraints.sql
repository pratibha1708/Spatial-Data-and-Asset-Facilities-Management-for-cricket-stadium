--II. CONSTRAINTS

--1. PRIMARY KEYS

--1.1 
alter table ucesatb.stadium add constraint
	stadium_pk primary key (stadium_id);

--1.2
alter table ucesatb.stands add constraint
	stands_pk primary key (stand_id);

--1.3
alter table ucesatb.seats add constraint
	seats_pk primary key (seat_id);

--1.4
alter table ucesatb.seat_condition add constraint
	seat_condition_pk primary key (seat_condition_id);

--1.5 
alter table ucesatb.stand_condition add constraint
	stand_condition_pk primary key (stand_condition_id);

--1.6
alter table ucesatb.floodlights add constraint
	floodlights_pk primary key (floodlight_id);

--1.7
alter table ucesatb.floodlight_condition add constraint
	floodlight_condition_pk primary key (floodlight_condition_id);

--1.8 
alter table ucesatb.facilities add constraint
	facilities_pk primary key (facility_id);

--1.9
alter table ucesatb.facility_condition add constraint
	facility_condition_pk primary key (facility_condition_id);

--1.10
alter table ucesatb.asset_health_indicator add constraint 
        health_pk primary  key(asset_health_indicator_id);

--1.11
alter table ucesatb.criticality add constraint 
        criticality_pk primary key (criticality_id);

--1.12
alter table ucesatb.users add constraint 
        user_pk primary key(user_id);

--1.13
alter table ucesatb.parameters add constraint 
        parameters_pk primary key (parameter_id);



--2. FOREIGN KEYS

--2.1 stands table

alter table ucesatb.stands
add constraint stands_seats_fk
foreign key (stadium_id)
references ucesatb.stadium(stadium_id);


--2.2 
alter table ucesatb.stands
add constraint stands_criticality_fk
foreign key (criticality)
references ucesatb.criticality(criticality_id);


--2.3 stadium table

alter table ucesatb.stadium
add constraint stadium_criticality_fk
foreign key (criticality)
references ucesatb.criticality(criticality_id);


--2.4 seats table

alter table ucesatb.seats
add constraint seats_stands_fk
foreign key (stand_id)
references ucesatb.stands(stand_id);

--2.5 

alter table ucesatb.seats
add constraint seats_criticality_fk
foreign key (criticality)
references ucesatb.criticality(criticality_id);

--2.6 seat conditition table

alter table ucesatb.seat_condition
add constraint seat_condition_seats_fk
foreign key (seat_id)
references ucesatb.seats(seat_id);

--2.7 

alter table ucesatb.seat_condition
add constraint seat_condition_legcondition_fk
foreign key (leg_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.8

alter table ucesatb.seat_condition
add constraint seat_condition_sitting_area_condition_fk
foreign key (sitting_area_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.9

alter table ucesatb.seat_condition
add constraint seat_condition_armrest_condition_fk
foreign key (armrest_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.10

alter table ucesatb.seat_condition
add constraint seat_condition_overall_recliner_condition_fk
foreign key (recliner_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.11

alter table ucesatb.seat_condition
add constraint seat_condition_cupholder_condition_fk
foreign key (cupholder_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.12

alter table ucesatb.seat_condition
add constraint seat_condition_user_fk
foreign key (user_id)
references ucesatb.users(user_id);

--2.13 stand condition table

alter table ucesatb.stand_condition
add constraint stand_condition_stand_id_fk
foreign key (stand_id)
references ucesatb.stands(stand_id);

--2.14

alter table ucesatb.stand_condition
add constraint stand_condition_arch_condition_fk
foreign key (arch_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.15

alter table ucesatb.stand_condition
add constraint stand_condition_door_gate_condition_fk
foreign key (door_gate_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.16

alter table ucesatb.stand_condition
add constraint stand_condition_banner_condition_fk
foreign key (banner_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.17

alter table ucesatb.stand_condition
add constraint stand_condition_stairs_condition_fk
foreign key (stairs_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.18

alter table ucesatb.stand_condition
add constraint stand_condition_handrail_condition_fk
foreign key (handrail_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.19

alter table ucesatb.stand_condition
add constraint stand_condition_disabled_access_condition_fk
foreign key (disabled_access_condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.20

alter table ucesatb.stand_condition
add constraint stand_condition_user_fk
foreign key (user_id)
references ucesatb.users(user_id);

--2.21 floodlights table

alter table ucesatb.floodlights
add constraint floodlights_stand_id_fk
foreign key (stand_id)
references ucesatb.stands(stand_id);

--2.22

alter table ucesatb.floodlights
add constraint floodlights_criticality_fk
foreign key (criticality)
references ucesatb.criticality(criticality_id);
 
--2.23 floodlight condition table

alter table ucesatb.floodlight_condition
add constraint floodlight_condition_floodlight_id_fk
foreign key (floodlight_id)
references ucesatb.floodlights(floodlight_id);

--2.24

alter table ucesatb.floodlight_condition
add constraint floodlight_condition_condition_fk
foreign key (condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

--2.25

alter table ucesatb.floodlight_condition
add constraint floodlight_condition_user_fk
foreign key (user_id)
references ucesatb.users(user_id);

--2.26 facilities table

alter table ucesatb.facilities
add constraint facilities_stand_id_fk
foreign key (stand_id)
references ucesatb.stands(stand_id);

--2.27
alter table ucesatb.facilities
add constraint facilities_criticality_fk
foreign key (criticality)
references ucesatb.criticality(criticality_id);

--2.28 facility_condition table
alter table ucesatb.facility_condition
add constraint facility_condition_facility_id_fk
foreign key (facility_id)
references ucesatb.facilities(facility_id);

--2.29
alter table ucesatb.facility_condition
add constraint facility_condition_user_fk
foreign key (user_id)
references ucesatb.users(user_id);

--2.30
alter table ucesatb.facility_condition
add constraint facility_condition_condition_fk
foreign key (condition)
references ucesatb.asset_health_indicator(asset_health_indicator_id);

 
-- 3. UNIQUE CONSTRAINTS

--3.1 stadium table
alter table ucesatb.stadium
	add constraint stadium_unique
	unique(stadium_name);

--3.2 stands table
alter table ucesatb.stands
	add constraint stands_unique
	unique(stand_name);

--3.3 seats table
alter table ucesatb.seats
	add constraint seats_unique
	unique(location, floor);

--3.4 seat_condition table
alter table ucesatb.seat_condition
	add constraint seat_condition_unique
	unique(report_date, user_id, seat_id);

--3.5 stand_condition table
alter table ucesatb.stand_condition
	add constraint stand_condition_unique
	unique(report_date, stand_id, user_id);

--3.6 floodlights table
alter table ucesatb.floodlights
	add constraint floodlights_unique
	unique(location);

--3.7 floodlight_condition table
alter table ucesatb.floodlight_condition
	add constraint floodlight_condition_unique
	unique(report_date, user_id, floodlight_id);

--3.8 facilities table 
alter table ucesatb.facilities
	add constraint facilities_unique
	unique(location, floor);

--3.9 facility_condition table
alter table ucesatb.facility_condition
	add constraint facility_condition_unique
	unique(report_date, user_id, facility_id);

--3.10 asset_health_indicator table - the indicator text must be different from each other 
alter table ucesatb.asset_health_indicator
	add constraint health_description_unique
	unique(asset_health_indicator_description);

--3.11 users table - each user name needs to be unique 
alter table ucesatb.users
	add constraint user_name_unique
	unique(user_name);

--3.12 parameters table - combination of parameter name, subname and date must be unique 

	alter table ucesatb.parameters
	add constraint parameters_unique 
	unique(parameter_type, parameter_name, parameter_subname, date_created);


--4. CHECK CONSTRAINTS

--4.1 seats table
alter table ucesatb.seats
	add constraint seat_type_check
	check (seat_type in ('plastic chair', 'cushioned chair','hammock','sofa'));
 
--4.2 floodlights table
alter table ucesatb.floodlights
	add constraint floodlight_type_check
	check (floodlight_type in ('LED', 'halogen'));

--4.3
alter table ucesatb.facilities
	add constraint facility_type_check
	check (facility_type in ('foodcourt', 'washroom', 'bar', 'pavilion' ));

