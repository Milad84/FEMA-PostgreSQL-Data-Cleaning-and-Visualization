
```
DROP TABLE IF EXISTS FEMA;
CREATE TABLE FEMA (
	--id SERIAL PRIMARY KEY , I will add it later
	DisasterNumber varchar,
	IHProgramDeclared varchar,
	IAProgramDeclared varchar,
	PAProgramDeclared varchar,
	HMProgramDeclared varchar,
	State varchar,
	DeclarationDate varchar,  
	DisasterType varchar,
	IncidentType TEXT,
	Title VARCHAR,
	IncidentBeginDate VARCHAR,
	IncidentEndDate VARCHAR,
	DisasterCloseOutDate TEXT,
	PlaceCode varchar,
	DeclaredCountyArea VARCHAR,
	DeclarationRequestNumber VARCHAR
);


Copy FEMA (DisasterNumber, IHProgramDeclared , IAProgramDeclared,
		   PAProgramDeclared, HMProgramDeclared, State, DeclarationDate,
		   DisasterType, IncidentType, Title, IncidentBeginDate, IncidentEndDate,
		   DisasterCloseOutDate, PlaceCode, DeclaredCountyArea, DeclarationRequestNumber
		  )
FROM 'E:\FEMA.csv'  CSV DELIMITER ','
;


--Add id as a primary key. It is going to be added as last column
ALTER TABLE FEMA ADD COLUMN id SERIAL PRIMARY KEY;

--But the first row is repeated so I am going to remove it
DELETE FROM FEMA
WHERE FEMA.id = 1;

--Check the begin date of each disaster as a date
select date(IncidentBeginDate) from FEMA;

--Add column year to copy from IncidentBeginDate
ALTER TABLE FEMA
ADD COLUMN YEAR DATE;
-----------------------------------------------
--Cast the new date in the column year
UPDATE FEMA SET YEAR = IncidentBeginDate::DATE;
-----------------------------------------------

--Descriptive statistics
select count(*) 
from FEMA
where year between '2017-12-31' and '2018-12-31';
--Is the result accurate? No. 
--We need to get the unique values in the DisasterNumber
--column because 1 disaster can be assigned to multiple counties

--Get the unique count of all disasters since 1965 (unique numbers)
SELECT 
 DISTINCT DisasterNumber
FROM
 FEMA As UniqueDisasterNumber;
-----------------------------------------------
--Solve the problem of same name of county in different states by concatenating the state and county

ALTER TABLE FEMA
ADD COLUMN CountyState varchar;
UPDATE FEMA SET CountyState = CONCAT (DeclaredCountyArea,' ', State);
--Check for the result
Select *
from FEMA;
-----------------------------------------------
--Now let's get all the records for Hays TX
Select CountyState
FROM FEMA
WHERE CountyState LIKE '%Hays%';
-----------------------------------------------
--Let's see all the records for Hays
Select *
FROM FEMA
WHERE CountyState LIKE '%Hays%' and incidenttype = 'Fire';
-----------------------------------------------
-----------------------------------------------
--Before importing the county shapefile add a column to the
--shapefile joining the name of the county and state with a space between them
--Import the counties shapefile in the schema
--Check the imported county shapefile
select * from county;
select * from fema;
-----------------------------------------------
--Remove '(County)', '(Municipality)', '(Borough)', '(Parish)', and '(Municipio)' from countystate in the FEMA table
UPDATE FEMA SET CountyState = replace(countystate, '(County)', '');
UPDATE FEMA SET CountyState = replace(countystate, '(Municipio)', '');
UPDATE FEMA SET CountyState = replace(countystate, '(Borough)', '');
UPDATE FEMA SET CountyState = replace(countystate, '(Parish)', '');
UPDATE FEMA SET CountyState = replace(countystate, '(Municipality)', '');
-----------------------------------------------
--Create the same countystate column in the shapefile so that we can use it as a primary key in the join
--But first take care of the inconsistencies in the state_name column in the shapefile:

UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Alabama'), 'AL');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Alaska'), 'AK');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Arizona'), 'AZ');													   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Arkansas'), 'AR');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('California'), 'CA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Colorado'), 'CO');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Connecticut'), 'CT');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Delaware'), 'DE');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('District of Columbia'), 'DC');													   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Florida'), 'FL');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Georgia'), 'GA');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Hawaii'), 'HI');	
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Idaho'), 'ID');	
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Illinois'), 'IL');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Indiana'), 'IN');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Iowa'), 'IA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Kansas'), 'KS');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Kentucky'), 'KY');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Louisiana'), 'LA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Maine'), 'ME');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Maryland'), 'MD');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Massachusetts'), 'MA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Michigan'), 'MI');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Minnesota'), 'MN');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Mississipi'), 'MS');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('MISSISSIPPI'), 'MS');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Missouri'), 'MO');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Montana'), 'MT');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Nebraska'), 'NE');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('NEBRASKA'), 'NE');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Nevada'), 'NV');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('New Hampshire'), 'NH');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('New Jersey'), 'NJ');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('New Mexico'), 'NM');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('New York'), 'NY');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('NEW YORK'), 'NY');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('North Carolina'), 'NC');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('North Dakota'), 'ND');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Ohio'), 'OH');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Oklahoma'), 'OK');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Oregon'), 'OR');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Pennsylvania'), 'PA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Rhode Island'), 'RI');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('South Carolina'), 'SC');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('South Dakota'), 'SD');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Tennessee'), 'TN');													   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Texas'), 'TX');												 
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Utah'), 'UT');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Vermont'), 'VT');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Virginia'), 'VA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Washington'), 'WA');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('West Virginia'), 'WV');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('West VA'), 'WV');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Wisconsin'), 'WI');												   
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Wyoming'), 'WY');
UPDATE county SET state_name = REPLACE(LTRIM(RTRIM(UPPER(state_name))), UPPER('Puerto Rico'), 'PR');


--Let's check the result
select * from county;
--Now create the countystate column in the shapefile
ALTER TABLE county
ADD COLUMN CountyState varchar;
UPDATE county SET CountyState = CONCAT (name,' ', state_name);
										
--Now we have a primary key to base the join (if needed)
-- on in other platforms (ArcMap), which is the countystate in both tables
---------------------------------------------------------------------------												   										
--Let's convert incident types to numbers
ALTER TABLE FEMA
DROP COLUMN IF EXISTS disastercode;
ALTER TABLE FEMA												   
ADD COLUMN disastercode VARCHAR;
												   
--Run THE NEXT SECTION one by one. For example,
--if you are interested to calculate the Pivot table on Fire then run only the line for Fire
												   
UPDATE FEMA SET disastercode = REPLACE(LTRIM(RTRIM(UPPER(incidenttype))), UPPER('Fire'), '1');
UPDATE FEMA SET disastercode = REPLACE(LTRIM(RTRIM(UPPER(incidenttype))), UPPER('Tornado'), '2');
UPDATE FEMA SET disastercode = REPLACE(LTRIM(RTRIM(UPPER(incidenttype))), UPPER('Flood'), '3');	
UPDATE FEMA SET disastercode = REPLACE(LTRIM(RTRIM(UPPER(incidenttype))), UPPER('FLOOD'), '3');												   
UPDATE FEMA SET disastercode = REPLACE(LTRIM(RTRIM(UPPER(incidenttype))), UPPER('Hurricane'), '4');	
UPDATE FEMA SET disastercode = REPLACE(LTRIM(RTRIM(UPPER(incidenttype))), UPPER('Snow'), '5');	
--BE AWARE OF THE FACT THAT ALL THE DISASTERCODE COLUMN WILL BE RE-WRITTEN IN CAPITALS
UPDATE FEMA SET disastercode = REPLACE(incidenttype, 'Fire', '1');												   
UPDATE FEMA SET disastercode = REPLACE(incidenttype, 'Tornado', '2');												   
UPDATE FEMA SET disastercode = REPLACE(incidenttype, 'Flood', '3');												   
UPDATE FEMA SET disastercode = REPLACE(incidenttype, 'Hurricane', '4');
UPDATE FEMA SET disastercode = REPLACE(incidenttype, 'Snow', '5');
-----------------------------------------------------------------------------
--Test to see if you got all the text converted to digits so the result SHOULD BE AN EMPTY CELL
select disastercode 
from fema
where disastercode = 'Fire';
----------------------------
--Number of all the fires
select count (*)
from fema
where disastercode = '1';
--------------------------												   
--If the Pivot table is not working then:
ALTER TABLE fema 												   
ALTER COLUMN countystate TYPE TEXT;
--PUT THE STRING IN CAPITALIZED WORD
Select count (*)
from fema
where disastercode = 'HURRICANE'; 
----------------------------------------------------------------	
--THE CASE OF SEVERE STORM IS DIFFERENT BECAUSE
--IT IS WRITTEN LIKE 'SEVERE STORM(S)'AND I DID NOT CHANGE IT SO:
Select count (*)
from fema
where disastercode LIKE '%SEVERE STORM%'; 
------------------------------------------
--Now let's aggregate the number of different incidents in a Pivot Table										
--Enabling the Crosstab Function												   
CREATE extension tablefunc;		
--Let's try to find the counties that had at least one case of fire (distict counties). 
--If you want to get the total number of fire you just need to remove the word distinct
DROP TABLE IF EXISTS Pivot;
SELECT * INTO Pivot
FROM crosstab ('select distinct countystate,incidenttype, disastercode from fema') 
     AS final_result(countystate TEXT, incidenttype VARCHAR, disastercode VARCHAR)
	 where incidenttype= '1' ORDER BY countystate ASC;	
												   
Select count (*)
from Pivot;												   
												   
Select *
From Pivot;												   
												   
select * from fema;

```

