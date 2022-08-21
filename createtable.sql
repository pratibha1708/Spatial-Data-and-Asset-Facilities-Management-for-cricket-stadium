--I. CREATE TABLES

--. Dropping schema and then recreating it
drop schema if exists ucesatb cascade;
create schema ucesatb; 


--1. Create table stadium
drop table if exists ucesatb.stadium;
create table ucesatb.stadium(
      stadium_id serial,
      stadium_name character varying(200) not null,
      year_founded integer,
      founder_name character varying (150),
      criticality integer not null);

--1.1 Add geometry 2D
select AddGeometryColumn('ucesatb','stadium','location',27700,'geometry',2);



--2. Create table stands
drop table if exists ucesatb.stands;
create table ucesatb.stands(
       stand_id serial,
       stand_name character varying(200) not null,
       stadium_id integer not null,
       criticality integer not null);

--2.1 Add geometry 3D
select AddGeometryColumn('ucesatb', 'stands' , 'location', 27700, 'geometry', 3);



--3. Create table seats
drop table if exists ucesatb.seats ;
create table ucesatb.seats(
      seat_id serial,
      stand_id integer,
      seat_type character varying(100) not null,
      seat_number character varying (70) not null,
      criticality integer not null,
      seat_installation_date date not null,
      floor integer not null);

--3.1 Add geometry column
select AddGeometryColumn('ucesatb', 'seats', 'location', 0, 'point', 3);



--4. create stand_condition table
drop table if exists ucesatb.stand_condition;
create table ucesatb.stand_condition(
       stand_condition_id serial not null,
       stand_id integer not null,
       arch_condition integer not null,
       door_gate_condition integer not null,
       banner_condition integer not null,
       stairs_condition integer not null,
       handrail_condition integer not null,
       disabled_access_condition integer not null,
       user_id integer not null,
       report_date date not null default CURRENT_DATE);
       



--5. create seat_condition table
drop table if exists ucesatb.seat_condition;
create table ucesatb.seat_condition(
       seat_condition_id serial not null,
       seat_id integer not null,
       sitting_area_condition integer not null,   --paint for plastic chair, cushion cover for sofa, cushioned chair etc.
       leg_condition integer not null,   
       armrest_condition integer not null,
       recliner_condition integer not null,
       cupholder_condition integer not null,
       report_date date not null default CURRENT_DATE,
       user_id integer not null);



--6. create floodlights table
drop table if exists ucesatb.floodlights;
create table ucesatb.floodlights(
       floodlight_id serial,
       stand_id integer,
       floodlight_type character varying(50) not null,
       floodlight_make character varying(50) not null,   
       floodlight_number character varying(50) not null,
       floodlight_installation_date date,
       criticality integer not null);

--6.1 Add geometry column- Point, 3D
select AddGeometryColumn('ucesatb', 'floodlights', 'location', 0, 'point', 3);



--7. create floodlight_condition table
drop table if exists ucesatb.floodlight_condition;
create table ucesatb.floodlight_condition(
       floodlight_condition_id serial not null,
       floodlight_id integer not null,
       condition integer not null,
       report_date date not null default CURRENT_DATE,
       user_id integer not null);


--8. create facilities tables
drop table if exists ucesatb.facilities;
create table ucesatb.facilities(
       facility_id serial,
       stand_id integer,
       facility_type character varying(100) not null,
       facility_number character varying(100) not null,
       floor integer not null,
       criticality integer not null);

--8.1 Addgeometry column- 3D, polygon
select AddGeometryColumn('ucesatb', 'facilities', 'location', 0, 'polygon', 3);


--9. create facility_condition table
drop table if exists ucesatb.facility_condition;
create table ucesatb.facility_condition(
       facility_condition_id serial not null,
       facility_id integer not null,
       condition integer not null,
       report_date date not null, 
       user_id integer not null);
 

--10. create assets_health_indicator table
drop table if exists ucesatb.asset_health_indicator;
create table ucesatb.asset_health_indicator(
       asset_health_indicator_id serial not null,
       asset_health_indicator_description character varying(600));


--11. create criticality table
drop table if exists ucesatb.criticality;
create table ucesatb.criticality(
       criticality_id serial not null,
       criticality character varying(600) not null);


--12. create users table
drop table if exists ucesatb.users;
create table ucesatb.users(
       user_id serial not null,
       user_name character varying(150) not null);


--13. create parameters table
drop table if exists ucesatb.parameters;
create table ucesatb.parameters (
       parameter_id serial,
       parameter_type character varying (100),
       parameter_name character varying (150),
       parameter_subname character varying (150),
       parameter_value double precision,
       parameter_units character varying (100),
       date_created date default CURRENT_DATE);



