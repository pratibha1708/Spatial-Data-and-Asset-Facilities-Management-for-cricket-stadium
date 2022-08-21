# Spatial-Data-and-Asset-Facilities-Management-for-cricket-stadium

## 7 Decsisons for Lord Cricket Stadium

In this repository, there are 6 files for the creation of a spatial database from scratch for the Cricket Stadium. The file types are sql and jpg.

## 1. tables.sql
There are 13 tables created, with 5 of them having location components and 8 of them without geospatial components. 
<img src = https://github.com/pratibha1708/Spatial-Data-and-Asset-Facilities-Management-for-cricket-stadium/blob/main/sql.JPG>

## 2. constraints.sql
--> There are 4 constraints here which are: <br> 
    2.1 Primary keys: Primary keys ensure that each row of data has an identifier. There are 13 primary constraints <br>
    2.2 Foreign keys: Foreign keys join one table to another.There are 30 foreign constraints. <br>
    2.3 Unique constraints: Unique constraints validates entries only if they are unique. There are 12 primary constraints <br>
    2.4 Check constraints: Check constraints ensure that the user doesn't enter values into the database which are not expected. Eg: Entering abbreviations when        the database expects actual words. There is 3 check constraints. <br>
     
## 3. insertdata.sql
This holds the commands to inset data into the tables.
Data is first inserted into the tables which are not connected to other tables.

## 4. views.sql
Views are temporary sql tables that are created from the result of an sql command.The views created make it easier to query data from the database. <br>
There are four views created, namely, <br>
--> latest_parameters <br>
--> seats_criticality_cost <br>
--> stand_condition_criticality <br>
--> floodlights_condition_criticality_cost <br>

## 5. decisions.sql
This file holds the SEVEN decisions that will help in better decision making for the tennis sports complex.

<img src = https://github.com/pratibha1708/Spatial-Data-and-Asset-Facilities-Management-for-cricket-stadium/blob/main/decisions_pyramid.jpg>

## 6. QGIS and FME screenshot showing the 5 layers.png
A screenshot of the database created in a QGIS window and FME Data Inspector. 

<img src = https://github.com/pratibha1708/Spatial-Data-and-Asset-Facilities-Management-for-cricket-stadium/blob/main/QGIS.JPG>
<img src = https://github.com/pratibha1708/Spatial-Data-and-Asset-Facilities-Management-for-cricket-stadium/blob/main/stand_stadium.JPG>


