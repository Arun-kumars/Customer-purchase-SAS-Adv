

*SAS terminolgy ;
*data set=SAS Table;
*Variable (var) =columns;
*observation(obs)=rows;
* data values (val)=intersectional between Rows and Column;

proc contents data=Arun_kum.Project1;
run;


proc print data=Arun_kum.Project1;
proc print;run;

PROC MEANS DATA= Arun_kum.Project1;
RUN;

*Missing Values;
PROC MEANS DATA= Arun_kum.Project1 N NMISS MIN MEAN MEDIAN STD MAX MAXDEC=2;
RUN;




ods output sgplot=work.sgplotdata;
proc sgplot data=Arun_kum.Project1;
    vbox Amount;
run;


proc format library=Arun_kum;
value $Sexfmt
'male'=1
'female'= 0
;

proc sgplot data=Arun_kum.Project1;
    vbox Sex format $Sexfmt;
run;


proc sgplot data = Arun_kum.Project1;
histogram INCOME;
density HOMEVAL;
run;
quit;


data Arun_kum_target;
  set Arun_kum.Project1;
  Sex=Gender;*creating new variable;
  format Sex $Sexfmt;
run;



/* Proc univariate */
*for continues(numeric) data columns;
*Note: proc means  gives u very simple summary statistics but proc univariate gives u
complete statitstivcs;

Proc univariate data=Arun_kum.Project1;
 var AMOUNT;
run;

TITLE "UNIVARIATE DESCRIPTIVE ANALYSIS:SEX";
PROC FREQ DATA=Arun_kum.Project1;
TABLE SEX;
RUN;

*Outliers;

proc means data=Arun_kum.Project1 stackods min max skewness q1 q3 qrange maxdec=3;
ods output summary=Arun_kum.temp;
run;

data Arun_kum.temp2;
set Arun_kum.temp;
lowerlimit=Q1-1.5*Qrange;
upperlimit=Q3+1.5*Qrange;
if lowerlimit<min or upperlimit>max and skew<1 then Outlier="Yes";
if lowerlimit<2*min or upperlimit>2*max and skew>=1 then Outlier="Yes";
if lowerlimit>=min and upperlimit<=max then Outlier="No";
run;
proc print data=Arun_kum.temp2;run;



proc sgplot data = Arun_kum.Project1;
vbox Income;
title 'Distibution by Income';
run;

proc sgplot data = Arun_kum.Project1;
vbox RETURN;
title 'Distibution by RETURN';
run;


proc univariate data = Arun_kum.Project1;
var RETURN;
output out=boxStats median=median qrange = iqr;
run; 

data null;
	set boxStats;
	call symput ('median',median);
	call symput ('iqr', iqr);
run; 

%put &median;
%put &iqr;

data Arun_kum.Project1;
set Arun_kum.return;
    if (RETURN le &median + 1.5 * &iqr) and (RETURN ge &median - 1.5 * &iqr); 
run; 

proc print data = Arun_kum.return;
run;



proc sgplot data = Master;
hbox Sales;
title 'Distibution of Sales ';
Where sales <1000;
run;

data Arun_kum.Project1;
   set Arun_kum.NUMCARS;
   drop NUMCARS;
run;

data have;
   set have;
   drop name age address;
run;
