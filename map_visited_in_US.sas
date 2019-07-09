/* YOUR NAME HERE - Activity 1 */

/* This is a comment */
* This is also a comment;

/*
- This program reads in the data from Z:\stat318\US_DATA.csv 
	and loads it into a SAS data set named MY_DATA.
- It writes a map to an RTF (rich text format) document 
	at the location N:\stat318\States_visited.rtf
*/
%LET path = z:\STA318;

ODS RTF FILE="&path\States Visted.rtf" BODYTITLE;

TITLE "YOUR NAME HERE: Activity 1";

/* Below is an example of a data step*/
DATA my_data;
	INFILE "&path\US_DATA.csv" DSD FIRSTOBS=2;
	INPUT
		STATENAME        :$20.
		POPULATION_2010  :comma15.
		STATE            :2.
		STATECODE        :$2.
		DIVISION         :$18.
		REGION           :$9.
		YouBeenThere;
	FORMAT population_2010 comma15.;

	/* some code in our data step*/
	/*make a character variable for our map*/
	IF youbeenthere=1 
		THEN Visited="Yes";
	ELSE IF youbeenthere=0 
		THEN Visited="No";
	LABEL statecode="State " 
		region="Region" 
		statename="State Name";
RUN;

/* Below is an example of a PROC STEP */
/* PROC FREQ generates a frequency table */
TITLE3 JUSTIFY=center "How Many US States Have I Visited?";
PROC FREQ DATA=my_data;
	TABLE visited;
RUN;


/* The PROC step below makes a map showing the states you have visited*/
TITLE  "Which States Have I Visited?";
LEGEND1 LABEL=none SHAPE=bar(.1in, .1in);
PROC GMAP DATA=my_data MAP=maps.us;
	ID statecode;
	CHORO visited / COUTLINE=gray44
		MIDPOINTS =  ' No ' ' Yes' LEGEND=legend1;
RUN;

/*below is a PROC SORT and a PROC PRINT step*/
PROC SORT DATA=my_data;
	BY region;
RUN;

PROC PRINT DATA=my_data NOOBS LABEL;
	TITLE "States I Have Yet to Visit";
	WHERE youbeenthere=0;
	VAR region statename;
RUN;

ODS RTF CLOSE;