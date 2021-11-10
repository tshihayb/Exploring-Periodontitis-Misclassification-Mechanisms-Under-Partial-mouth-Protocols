/***********************************************************************************/
* Programmer: Talal Alshihayb
* Date: November 9, 2021
* Purpose: Commented code to replicate "Exploring Periodontitis Misclassification Mechanisms Under Partial-mouth Protocols";
************************************************************************************/

/********************************************************************************************************************/
* Table of contents*/
*		Code section 1 - Creating variables													lines	35-315
* 
*  		Code section 2 - Checking if variables were correctly coded							lines	317-703
*
*   	Code Section 3 - Descriptives of the sample											lines	705-715
*
*   	Code section 4 - Reprodcuing Table 1. Tooth level absolute comparisons of
*	                	 clinical measurement sites (mm) by tooth type and disease status	lines	717-3185
*
*   	Code Section 5 - Reprodcuing Table 2. Comparisons of average severity of 
*                        clinical measures (mm) and teeth by oral quadrant					lines	3187-3632
*
*		Code Section 6 - Reproducing Figure S1. Sensitivity estimates for identification
*						 of severe periodontitis cases according to clinical sites
*						 measured and teeth evaluated										lines	3634-6702
*
*		Code Section 7 - Reproducing Table 3. Population mean number of teeth with
						 specified clinical severity according to concordance of disease
						 determinations from partial-mouth protocols and full-mouth 
						 protocols with 1000 iterations of random assignment to 
						 half-mouth															lines	6704-7456
*
*		Code Section 8 - Reproducing Table 4. Comparisons of clinical severity across
*						 partial-mouth protocols and Figure S2								lines	7458-8515
/*******************************************************************************************************************/

/******************************************************/
/* Code Section 1 - Creating variables*/ 
/******************************************************/
/*Setting some options for display*/;
options nocenter nofmterr;
options linesize=200; 

/*Loading the library that we saved the permanent dataset in we created from data cleaning (perio0914) code*/
libname part 'C:\Users\Tshih\OneDrive\Periodontal side differences in NHANES\Analytic data';

/*Creating formats for the variables we wil create*/
proc format;
	value	yesnoc		1='Yes'
						0='No';

	Value   Perioc		3='Severe periodontitis'
						2='Moderate periodontitis'
						1='Mild periodontitis'
						0='No periodontitis';
	run;

/*Loading the dataset that we saved as a permanennt one in the data cleaning code*/
data perio0914; set part.perio0914; 
/* Creating a variable for number of permanent teeth (primary teeth, permanent root fragments, implants
do not contribute to tooth count)*/
	array tooth	(28)	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
						OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
						OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC
						OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;
	toothcount=0;
	do i=1 to 28;
	if tooth(i)=2 then toothcount=toothcount+1;
	end;
	drop i;

	/*Inclusion criteria (those who had complete periodontal examination, who had at least 1 permanent tooth present,
	and 30 years old or older*/
	if OHDPDSTS=1;
	if toothcount gt 0;
	if RIDAGEYR ge 30;
run;

data one;
	set perio0914;

	/* Array for calculating maximum interproximal attachment loss per tooth*/

	array lad (28)  	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
						ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;

	array las (28) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
						ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;

	array lap (28) 		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
						ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;

	array laa (28)		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
						ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;

	array lax (28) 		ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla
						ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla 
						ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla 
						ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla;

	do count=1 to 28; lax(count)=max(of lad(count),las(count),lap(count),laa(count));
	end;
	drop count;

/* Array for calculating maximum interproximal probing depth per tooth*/

	array pcd (28)  	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
						ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;

	array pcs (28) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs
						ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;

	array pcp (28) 		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp
						ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;

	array pca (28) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca
						ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;

	array pcx (28) 		ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc
						ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc
						ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc
						ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc;

	do count=1 to 28; pcx(count)=max(of pcd(count),pcs(count),pcp(count),pca(count));
	end;
	drop count;

	/* Define periodontal disease using Eke 2012 definition*/
	
	/* set Periostatus to 0*/

	periostatus=0;

	/* Severe periodontitis: >=2 interproximal sites with LOA >=6 mm (not on same tooth) and >=1 interproximal
	site with PD >=5 mm*/
	/* Set tooth counts=0*/

	nteethipxla6mm=0;
	nteethipxpc5mm=0;
	do count=1 to 28; 
	if lax(count) ge 6 then nteethipxla6mm=nteethipxla6mm+1;
	if pcx(count) ge 5 then nteethipxpc5mm=nteethipxpc5mm+1;
	end; 
	if nteethipxla6mm>=2 AND nteethipxpc5mm>=1 then periostatus=3; /*Severe perio*/

	/* Moderate periodontitis: >=2 interproximal sites with LOA >=4 mm (not on same tooth), or >=2 interproximal
	sites with PD>=5 mm (not on same tooth)*/

	IF PERIOSTATUS=0 THEN  DO;
	nteethipxla4mm=0;
	do count=1 to 28; if lax(count) ge 4 then nteethipxla4mm=nteethipxla4mm+1; end;
	if nteethipxla4mm>=2 OR nteethipxpc5mm>=2 then periostatus=2; /*Moderate perio*/

	END;

	/* Mild periodontitis: >=2 interproximal sites with LOA >=3 mm, and >=2 interproximal sites with PD >=4 mm
	(not on same tooth) or one site with PD >=5 mm*/

	IF PERIOSTATUS=0 THEN  DO;
	nsitesipxloa3mm=0;
	nteethipxpc4mm=0;
	do count=1 to 28; if lad(count) ge 3 then nsitesipxloa3mm=nsitesipxloa3mm+1; 
	if las(count) ge 3 then nsitesipxloa3mm=nsitesipxloa3mm+1; 
		 if lap(count) ge 3 then nsitesipxloa3mm=nsitesipxloa3mm+1; 
		if laa(count) ge 3 then nsitesipxloa3mm=nsitesipxloa3mm+1; end;
	do count=1 to 28; if pcx(count) ge 4 then nteethipxpc4mm=nteethipxpc4mm+1; end;
	if nsitesipxloa3mm>=2 AND (nteethipxpc4mm>=2 OR nteethipxpc5mm=1) then periostatus=1; /*Mild perio*/
	END;

	/* Calculating number of missing teeth for perio measuremet and setting periostatus for those who have all teeth
	missing perio measurement as missing*/
	misspddb=0;
	misspdmsb=0;
	misspddl=0;
	misspdmsl=0;
	missCaldb=0;
	misscalmsb=0;
	misscaldl=0;
	misscalmsl=0;
	do i=1 to 28;
	if pcd(i)=. then misspddb=misspddb+1;
	if pcs(i)=. then misspdmsb=misspdmsb+1;
	if pcp(i)=. then misspddl=misspddl+1;
	if pca(i)=. then misspdmsl=misspdmsl+1;
	if lad(i)=. then missCaldb=missCaldb+1;
	if las(i)=. then misscalmsb=misscalmsb+1;
	if lap(i)=. then misscaldl=misscaldl+1;
	if laa(i)=. then misscalmsl=misscalmsl+1;
	end;
	drop i;
	if 	misspddb=28 and
		misspdmsb=28 and 
		misspddl=28 and 
		misspdmsl=28 and
		missCaldb=28 and
		misscalmsb=28 and 
		misscaldl=28 and 
		misscalmsl=28 then PERIOSTATUS=.;

	/*Define periodontal disease usign Page & Eke 2007 definition (no vs. mild/moderate/severe)*/
	if PERIOSTATUS=. then periomildsevmod=.;
	if periostatus=0 then periomildsevmod=0;
	if periostatus=1 or periostatus=2 or periostatus=3 then periomildsevmod=1;

	/* Define periodontal disease using Page & Eke 2007 definition (no/mild vs. moderate/severe)*/
	if PERIOSTATUS=. then periosevmod=.;
	if periostatus=0 or periostatus=1 then periosevmod=0;
	if periostatus=2 or periostatus=3 then periosevmod=1;

	/* Define periodontal disease using Page & Eke 2007 definition (no/mild/moderate vs. severe)*/
	if PERIOSTATUS=. then periosev=.;
	if periostatus=0 or periostatus=1 or periostatus=2 then periosev=0;
	if periostatus=3 then periosev=1;
	
	/* Define mean CAL/PD per tooth and mean interproximal CAL/PD per tooth*/

	array meanintcal (28)	meanintcal02	meanintcal03	meanintcal04	meanintcal05	meanintcal06	meanintcal07	meanintcal08
							meanintcal09	meanintcal10	meanintcal11	meanintcal12	meanintcal13	meanintcal14	meanintcal15
							meanintcal18	meanintcal19	meanintcal20	meanintcal21	meanintcal22	meanintcal23	meanintcal24
							meanintcal25	meanintcal26	meanintcal27	meanintcal28	meanintcal29	meanintcal30	meanintcal31;

	array meanintpd (28)	meanintpd02	meanintpd03	meanintpd04	meanintpd05	meanintpd06	meanintpd07	meanintpd08
							meanintpd09	meanintpd10	meanintpd11	meanintpd12	meanintpd13	meanintpd14	meanintpd15
							meanintpd18	meanintpd19	meanintpd20	meanintpd21	meanintpd22	meanintpd23	meanintpd24
							meanintpd25	meanintpd26	meanintpd27	meanintpd28	meanintpd29	meanintpd30	meanintpd31;
		
	do i=1 to 28;
	meanintcal(i)=mean(of lad(i), las(i), lap(i), laa(i));
	meanintpd(i)=mean(of pcd(i), pcs(i), pcp(i), pca(i));
	end;
	drop i;

	/* Creatimg exam weights for the three cycle*/
	WTMEC6YR=(1/3)*WTMEC2YR;
	label periostatus='Periodontitis according to Eke 2012 definition';
	label periomildsevmod='Mild, moderate or severe periodontitis according to Eke et al';
	label periosevmod='Severe or moderate periodntitis according to Eke at al';
	label periosev='Severe periodntitis according to Eke at al';
 	label meanintcal02='Mean clinical attachment loss of 4 interproximal sites of tooth 2';
 	label meanintcal03='Mean clinical attachment loss of 4 interproximal sites of tooth 3';
 	label meanintcal04='Mean clinical attachment loss of 4 interproximal sites of tooth 4';
 	label meanintcal05='Mean clinical attachment loss of 4 interproximal sites of tooth 5';
 	label meanintcal06='Mean clinical attachment loss of 4 interproximal sites of tooth 6';
 	label meanintcal07='Mean clinical attachment loss of 4 interproximal sites of tooth 7';
 	label meanintcal08='Mean clinical attachment loss of 4 interproximal sites of tooth 8';
 	label meanintcal09='Mean clinical attachment loss of 4 interproximal sites of tooth 9';
 	label meanintcal10='Mean clinical attachment loss of 4 interproximal sites of tooth 10';
 	label meanintcal11='Mean clinical attachment loss of 4 interproximal sites of tooth 11';
 	label meanintcal12='Mean clinical attachment loss of 4 interproximal sites of tooth 12';
 	label meanintcal13='Mean clinical attachment loss of 4 interproximal sites of tooth 13';
 	label meanintcal14='Mean clinical attachment loss of 4 interproximal sites of tooth 14';
 	label meanintcal15='Mean clinical attachment loss of 4 interproximal sites of tooth 15';
 	label meanintcal18='Mean clinical attachment loss of 4 interproximal sites of tooth 18';
 	label meanintcal19='Mean clinical attachment loss of 4 interproximal sites of tooth 19';
 	label meanintcal20='Mean clinical attachment loss of 4 interproximal sites of tooth 20';
 	label meanintcal21='Mean clinical attachment loss of 4 interproximal sites of tooth 21';
 	label meanintcal22='Mean clinical attachment loss of 4 interproximal sites of tooth 22';
 	label meanintcal23='Mean clinical attachment loss of 4 interproximal sites of tooth 23';
 	label meanintcal24='Mean clinical attachment loss of 4 interproximal sites of tooth 24';
 	label meanintcal25='Mean clinical attachment loss of 4 interproximal sites of tooth 25';
 	label meanintcal26='Mean clinical attachment loss of 4 interproximal sites of tooth 26';
 	label meanintcal27='Mean clinical attachment loss of 4 interproximal sites of tooth 27';
 	label meanintcal28='Mean clinical attachment loss of 4 interproximal sites of tooth 28';
 	label meanintcal29='Mean clinical attachment loss of 4 interproximal sites of tooth 29';
 	label meanintcal30='Mean clinical attachment loss of 4 interproximal sites of tooth 30';
 	label meanintcal31='Mean clinical attachment loss of 4 interproximal sites of tooth 31';
	label meanintpd02='Mean probing depth of 4 interproximal sites of tooth 2';
 	label meanintpd03='Mean probing depth of 4 interproximal sites of tooth 3';
 	label meanintpd04='Mean probing depth of 4 interproximal sites of tooth 4';
 	label meanintpd05='Mean probing depth of 4 interproximal sites of tooth 5';
 	label meanintpd06='Mean probing depth of 4 interproximal sites of tooth 6';
 	label meanintpd07='Mean probing depth of 4 interproximal sites of tooth 7';
 	label meanintpd08='Mean probing depth of 4 interproximal sites of tooth 8';
 	label meanintpd09='Mean probing depth of 4 interproximal sites of tooth 9';
 	label meanintpd10='Mean probing depth of 4 interproximal sites of tooth 10';
 	label meanintpd11='Mean probing depth of 4 interproximal sites of tooth 11';
 	label meanintpd12='Mean probing depth of 4 interproximal sites of tooth 12';
 	label meanintpd13='Mean probing depth of 4 interproximal sites of tooth 13';
 	label meanintpd14='Mean probing depth of 4 interproximal sites of tooth 14';
 	label meanintpd15='Mean probing depth of 4 interproximal sites of tooth 15';
 	label meanintpd18='Mean probing depth of 4 interproximal sites of tooth 18';
 	label meanintpd19='Mean probing depth of 4 interproximal sites of tooth 19';
 	label meanintpd20='Mean probing depth of 4 interproximal sites of tooth 20';
 	label meanintpd21='Mean probing depth of 4 interproximal sites of tooth 21';
 	label meanintpd22='Mean probing depth of 4 interproximal sites of tooth 22';
 	label meanintpd23='Mean probing depth of 4 interproximal sites of tooth 23';
 	label meanintpd24='Mean probing depth of 4 interproximal sites of tooth 24';
 	label meanintpd25='Mean probing depth of 4 interproximal sites of tooth 25';
 	label meanintpd26='Mean probing depth of 4 interproximal sites of tooth 26';
 	label meanintpd27='Mean probing depth of 4 interproximal sites of tooth 27';
 	label meanintpd28='Mean probing depth of 4 interproximal sites of tooth 28';
 	label meanintpd29='Mean probing depth of 4 interproximal sites of tooth 29';
 	label meanintpd30='Mean probing depth of 4 interproximal sites of tooth 30';
 	label meanintpd31='Mean probing depth of 4 interproximal sites of tooth 31';
	label WTMEC6YR='6-year exam weights';
	format	periostatus Perioc.
			periomildsevmod	periosevmod	periosev yesnoc.;	

	/*Exclude those that have missing CAL values for all their present teeth*/
	if periostatus ne .;	
	run;

/******************************************************************************/
/* Code Section 2 - Checking if variables were correctly coded (unit testing)*/ 
/******************************************************************************/

/*Checking if tooth count (toothcount) was correctly coded*/
proc print data=one (obs=100);
var SEQN	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
			OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
			OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC
			OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC
			toothcount;
			run;

/*Checking max interproximal CAL in each tooth and their mean were coded correctly*/
proc print data=one (obs=100);
var SEQN ohx02lad ohx02lap ohx02las ohx02laa ohx02maxla meanintcal02;
run;

proc print data=one (obs=100);
var SEQN ohx03lad ohx03lap ohx03las ohx03laa ohx03maxla meanintcal03;
run;

proc print data=one (obs=100);
var SEQN ohx04lad ohx04lap ohx04las ohx04laa ohx04maxla meanintcal04;
run;

proc print data=one (obs=100);
var SEQN ohx05lad ohx05lap ohx05las ohx05laa ohx05maxla meanintcal05;
run;

proc print data=one (obs=100);
var SEQN ohx06lad ohx06lap ohx06las ohx06laa ohx06maxla meanintcal06;
run;

proc print data=one (obs=100);
var SEQN ohx07lad ohx07lap ohx07las ohx07laa ohx07maxla meanintcal07;
run;

proc print data=one (obs=100);
var SEQN ohx08lad ohx08lap ohx08las ohx08laa ohx08maxla meanintcal08;
run;

proc print data=one (obs=100);
var SEQN ohx09lad ohx09lap ohx09las ohx09laa ohx09maxla meanintcal09;
run;

proc print data=one (obs=100);
var SEQN ohx10lad ohx10lap ohx10las ohx10laa ohx10maxla meanintcal10;
run;

proc print data=one (obs=100);
var SEQN ohx11lad ohx11lap ohx11las ohx11laa ohx11maxla meanintcal11;
run;

proc print data=one (obs=100);
var SEQN ohx12lad ohx12lap ohx12las ohx12laa ohx12maxla meanintcal12;
run;

proc print data=one (obs=100);
var SEQN ohx13lad ohx13lap ohx13las ohx13laa ohx13maxla meanintcal13;
run;

proc print data=one (obs=100);
var SEQN ohx14lad ohx14lap ohx14las ohx14laa ohx14maxla meanintcal14;
run;

proc print data=one (obs=100);
var SEQN ohx15lad ohx15lap ohx15las ohx15laa ohx15maxla meanintcal15;
run;

proc print data=one (obs=100);
var SEQN ohx18lad ohx18lap ohx18las ohx18laa ohx18maxla meanintcal18;
run;

proc print data=one (obs=100);
var SEQN ohx19lad ohx19lap ohx19las ohx19laa ohx19maxla meanintcal09;
run;

proc print data=one (obs=100);
var SEQN ohx20lad ohx20lap ohx20las ohx20laa ohx20maxla meanintcal20;
run;

proc print data=one (obs=100);
var SEQN ohx21lad ohx21lap ohx21las ohx21laa ohx21maxla meanintcal21;
run;

proc print data=one (obs=100);
var SEQN ohx22lad ohx22lap ohx22las ohx22laa ohx22maxla meanintcal22;
run;

proc print data=one (obs=100);
var SEQN ohx23lad ohx23lap ohx23las ohx23laa ohx23maxla meanintcal23;
run;

proc print data=one (obs=100);
var SEQN ohx24lad ohx24lap ohx24las ohx24laa ohx24maxla meanintcal24;
run;

proc print data=one (obs=100);
var SEQN ohx25lad ohx25lap ohx25las ohx25laa ohx25maxla meanintcal25;
run;

proc print data=one (obs=100);
var SEQN ohx26lad ohx26lap ohx26las ohx26laa ohx26maxla meanintcal26;
run;

proc print data=one (obs=100);
var SEQN ohx27lad ohx27lap ohx27las ohx27laa ohx27maxla meanintcal27;
run;

proc print data=one (obs=100);
var SEQN ohx28lad ohx28lap ohx28las ohx28laa ohx28maxla meanintcal28;
run;

proc print data=one (obs=100);
var SEQN ohx29lad ohx29lap ohx29las ohx29laa ohx29maxla meanintcal29;
run;

proc print data=one (obs=100);
var SEQN ohx30lad ohx30lap ohx30las ohx30laa ohx30maxla meanintcal30;
run;

proc print data=one (obs=100);
var SEQN ohx31lad ohx31lap ohx31las ohx31laa ohx31maxla meanintcal31;
run;

/*Checking max interproximal PD in each tooth and their mean were coded correctly*/
proc print data=one (obs=100);
var SEQN ohx02pcd ohx02pcp ohx02pcs ohx02pca ohx02maxpc meanintpd02;
run;

proc print data=one (obs=100);
var SEQN ohx03pcd ohx03pcp ohx03pcs ohx03pca ohx03maxpc meanintpd03;
run;

proc print data=one (obs=100);
var SEQN ohx04pcd ohx04pcp ohx04pcs ohx04pca ohx04maxpc meanintpd04;
run;

proc print data=one (obs=100);
var SEQN ohx05pcd ohx05pcp ohx05pcs ohx05pca ohx05maxpc meanintpd05;
run;

proc print data=one (obs=100);
var SEQN ohx06pcd ohx06pcp ohx06pcs ohx06pca ohx06maxpc meanintpd06;
run;

proc print data=one (obs=100);
var SEQN ohx07pcd ohx07pcp ohx07pcs ohx07pca ohx07maxpc meanintpd07;
run;

proc print data=one (obs=100);
var SEQN ohx08pcd ohx08pcp ohx08pcs ohx08pca ohx08maxpc meanintpd08;
run;

proc print data=one (obs=100);
var SEQN ohx09pcd ohx09pcp ohx09pcs ohx09pca ohx09maxpc meanintpd09;
run;

proc print data=one (obs=100);
var SEQN ohx10pcd ohx10pcp ohx10pcs ohx10pca ohx10maxpc meanintpd10;
run;

proc print data=one (obs=100);
var SEQN ohx11pcd ohx11pcp ohx11pcs ohx11pca ohx11maxpc meanintpd11;
run;

proc print data=one (obs=100);
var SEQN ohx12pcd ohx12pcp ohx12pcs ohx12pca ohx12maxpc meanintpd12;
run;

proc print data=one (obs=100);
var SEQN ohx13pcd ohx13pcp ohx13pcs ohx13pca ohx13maxpc meanintpd13;
run;

proc print data=one (obs=100);
var SEQN ohx14pcd ohx14pcp ohx14pcs ohx14pca ohx14maxpc meanintpd14;
run;

proc print data=one (obs=100);
var SEQN ohx15pcd ohx15pcp ohx15pcs ohx15pca ohx15maxpc meanintpd15;
run;

proc print data=one (obs=100);
var SEQN ohx18pcd ohx18pcp ohx18pcs ohx18pca ohx18maxpc meanintpd18;
run;

proc print data=one (obs=100);
var SEQN ohx19pcd ohx19pcp ohx19pcs ohx19pca ohx19maxpc meanintpd09;
run;

proc print data=one (obs=100);
var SEQN ohx20pcd ohx20pcp ohx20pcs ohx20pca ohx20maxpc meanintpd20;
run;

proc print data=one (obs=100);
var SEQN ohx21pcd ohx21pcp ohx21pcs ohx21pca ohx21maxpc meanintpd21;
run;

proc print data=one (obs=100);
var SEQN ohx22pcd ohx22pcp ohx22pcs ohx22pca ohx22maxpc meanintpd22;
run;

proc print data=one (obs=100);
var SEQN ohx23pcd ohx23pcp ohx23pcs ohx23pca ohx23maxpc meanintpd23;
run;

proc print data=one (obs=100);
var SEQN ohx24pcd ohx24pcp ohx24pcs ohx24pca ohx24maxpc meanintpd24;
run;

proc print data=one (obs=100);
var SEQN ohx25pcd ohx25pcp ohx25pcs ohx25pca ohx25maxpc meanintpd25;
run;

proc print data=one (obs=100);
var SEQN ohx26pcd ohx26pcp ohx26pcs ohx26pca ohx26maxpc meanintpd26;
run;

proc print data=one (obs=100);
var SEQN ohx27pcd ohx27pcp ohx27pcs ohx27pca ohx27maxpc meanintpd27;
run;

proc print data=one (obs=100);
var SEQN ohx28pcd ohx28pcp ohx28pcs ohx28pca ohx28maxpc meanintpd28;
run;

proc print data=one (obs=100);
var SEQN ohx29pcd ohx29pcp ohx29pcs ohx29pca ohx29maxpc meanintpd29;
run;

proc print data=one (obs=100);
var SEQN ohx30pcd ohx30pcp ohx30pcs ohx30pca ohx30maxpc meanintpd30;
run;

proc print data=one (obs=100);
var SEQN ohx31pcd ohx31pcp ohx31pcs ohx31pca ohx31maxpc meanintpd31;
run;

/*Checking if number of teeth with max CAL>=4 mm (nteethipxla4mm) and 6 mm (nteethipxla6mm) were coded correctly*/
/*Note: nteethipxla4mm should be missing in participants who had severe periodontitis because it was only calculated
if the person did not meet severe periodontitis (check lines 140-145)*/
proc print data=one (obs=100);
var SEQN 	ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla
			ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla 
			ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla 
			ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla
			nteethipxla4mm	nteethipxla6mm;
			run;

/*Checking if number of sites with CAL>=3 mm (nsitesipxloa3mm) was coded correctly*/
/*Note: nsitesipxloa3mm should be missing in participants who had severe or moderate periodontitis because it was
only calculated if the person did not meet severe periodontitis (check lines 150-159)*/
proc print data=one (obs=100);
var SEQN 	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
			ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
			ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
			ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
	 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
			ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
			ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
			ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
	 		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
			ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
			ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
			ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
			ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
			ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
			ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
			ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa
			nsitesipxloa3mm;
			run;

/*Checking if number of teeth with max PD>=4 mm (nteethipxpc4mm) and 5 mm (nteethipxpc5mm) were coded correctly*/
/*Note: nteethipxpc4mm should be missing in participants who had severe or moderate periodontitis because it was
only calculated if the person did not meet severe or moderate periodontitis (check lines 150-159)*/
proc print data=one (obs=100);
var SEQN 	ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc
			ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc
			ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc
			ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc
			nteethipxpc4mm	nteethipxpc5mm;
			run;

/*Checking if periodontitis status according to Eke et al 2012 (periostatus) was coded correctly*/
proc print data=one (obs=100);
var SEQN	nteethipxla6mm nteethipxpc5mm periostatus
			nteethipxla4mm nteethipxpc5mm periostatus
			nsitesipxloa3mm nteethipxpc4mm  nteethipxpc5mm periostatus;
			run;

/*Checking if number of sites with missing CAL in each site (distobuccal, mesiobuccal, distolingual, or mesiolingual) 
was coded correctly*/
/*distobuccal*/
proc print data=one (obs=100);
var SEQN 	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
			ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
			ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
			ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
			missCaldb;
			run;

/*mesiobuccal*/
proc print data=one (obs=100);
var SEQN 	ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
			ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
			ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
			ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
			missCalmsb;
			run;

/*distolingual*/
proc print data=one (obs=100);
var SEQN 	ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap
			ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
			ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
			ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
			misscaldl;
			run;

/*mesiolingual*/
proc print data=one (obs=100);
var SEQN 	ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa
			ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
			ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
			ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa
			missCalmsl;
			run;

/*Checking if those who had missing CAL in all sites had their periostatus set to missing*/
proc print data=one (obs=100);
where periostatus=.;
var SEQN missCaldb missCalmsb misscaldl missCalmsl;
	run;

/*Checking if number of sites with missing PD in each site (distobuccal, mesiobuccal, distolingual, or mesiolingual) 
was coded correctly*/
/*distobuccal*/
proc print data=one (obs=100);
var SEQN 	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
			ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
			ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 
			ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd
			misspddb;
			run;

/*mesiobuccal*/
proc print data=one (obs=100);
var SEQN 	ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
			ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
			ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 
			ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs
			misspdmsb;
			run;

/*distolingual*/
proc print data=one (obs=100);
var SEQN 	ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
			ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
			ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
			ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp
			misspddl;
			run;

/*mesiolingual*/
proc print data=one (obs=100);
var SEQN 	ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
			ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca 
			ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca 
			ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca
			misspdmsl;
			run;

/*Checking if having
at least mild/moderate/severe periodontitis (periomildsevmod)
at least moderate/severe periodontitis (periosevmod)
at least severe periodontitis (periosev)
were correctly coded*/
proc print data=one (obs=100);
var SEQN periostatus periomildsevmod periosevmod periosev;
	run;

proc print data=one;
*where periostatus=.;
where (periomildsevmod=. or periosevmod=. or periosev=.) and periostatus ne .;
var SEQN periostatus periomildsevmod periosevmod periosev;
	run;

/******************************************************/
/* Code Section 3 - Descriptives of the sample*/ 
/******************************************************/

proc means data=one n nmiss mean std stderr;
var RIDAGEYR toothcount;
run;

proc freq data=one;
tables RIAGENDR periostatus/missing;
run;

/*****************************************************************************************************************/
/* Code Section 4 - Reprodcuing Table 1. Tooth level absolute comparisons of clinical measurement sites (mm) by
tooth type and disease status*/ 
/*****************************************************************************************************************/

data two;
	set one;
	array lad (28)  	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad
						ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;

	array lam (28)		ohx02lam ohx03lam ohx04lam ohx05lam ohx06lam ohx07lam ohx08lam
						ohx09lam ohx10lam ohx11lam ohx12lam ohx13lam ohx14lam ohx15lam
						ohx18lam ohx19lam ohx20lam ohx21lam ohx22lam ohx23lam ohx24lam 
						ohx25lam ohx26lam ohx27lam ohx28lam ohx29lam ohx30lam ohx31lam;

	array las (28) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las
						ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;

	array lap (28) 		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap
						ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;

	array lal (28) 		ohx02lal ohx03lal ohx04lal ohx05lal ohx06lal ohx07lal ohx08lal 
						ohx09lal ohx10lal ohx11lal ohx12lal ohx13lal ohx14lal ohx15lal
						ohx18lal ohx19lal ohx20lal ohx21lal ohx22lal ohx23lal ohx24lal 
						ohx25lal ohx26lal ohx27lal ohx28lal ohx29lal ohx30lal ohx31lal;

	array laa (28)		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa
						ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;

	array pcd (28)  	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd
						ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;

	array pcm (28)  	ohx02pcm ohx03pcm ohx04pcm ohx05pcm ohx06pcm ohx07pcm ohx08pcm
						ohx09pcm ohx10pcm ohx11pcm ohx12pcm ohx13pcm ohx14pcm ohx15pcm
						ohx18pcm ohx19pcm ohx20pcm ohx21pcm ohx22pcm ohx23pcm ohx24pcm
						ohx25pcm ohx26pcm ohx27pcm ohx28pcm ohx29pcm ohx30pcm ohx31pcm; 

	array pcs (28) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs
						ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;

	array pcp (28) 		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp
						ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;

	array pcl (28)  	ohx02pcl ohx03pcl ohx04pcl ohx05pcl ohx06pcl ohx07pcl ohx08pcl
						ohx09pcl ohx10pcl ohx11pcl ohx12pcl ohx13pcl ohx14pcl ohx15pcl
						ohx18pcl ohx19pcl ohx20pcl ohx21pcl ohx22pcl ohx23pcl ohx24pcl
						ohx25pcl ohx26pcl ohx27pcl ohx28pcl ohx29pcl ohx30pcl ohx31pcl;

	array pca (28) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca
						ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;

	array tooth	(28)	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
						OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
						OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC
						OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;

	/* Buccal and lingual sites*/
	do i=1 to 28;
	ladsite=lad(i);
	lamsite=lam(i);
	lassite=las(i);
	lapsite=lap(i);
	lalsite=lal(i);
	laasite=laa(i);

	pcdsite=pcd(i);
	pcmsite=pcm(i);
	pcssite=pcs(i);
	pcpsite=pcp(i);
	pclsite=pcl(i);
	pcasite=pca(i);

	if lad(i) ne . and lap(i) ne . then diffcal_db_dl=lad(i)-lap(i); else diffcal_db_dl=.;
	if lam(i) ne . and lal(i) ne . then diffcal_midb_midl=lam(i)-lal(i); else diffcal_midb_midl=.;
	if las(i) ne . and laa(i) ne . then diffcal_mb_ml=las(i)-laa(i); else diffcal_mb_ml=.;
	if pcd(i) ne . and pcp(i) ne . then diffpd_db_dl=pcd(i)-pcp(i); else diffpd_db_dl=.;
	if pcm(i) ne . and pcl(i) ne . then diffpd_midb_midl=pcm(i)-pcl(i); else diffpd_midb_midl=.;
	if pcs(i) ne . and pca(i) ne . then diffpd_mb_ml=pcs(i)-pca(i); else diffpd_mb_ml=.;

	/* Mesial and distal sites*/
	if lad(i) ne . and las(i) ne . then diffcal_db_mb=lad(i)-las(i); else diffcal_db_mb=.;
	if lap(i) ne . and laa(i) ne . then diffcal_dl_ml=lap(i)-laa(i); else diffcal_dl_ml=.;
	if pcd(i) ne . and pcs(i) ne . then diffpd_db_mb=pcd(i)-pcs(i); else diffpd_db_mb=.;
	if pcp(i) ne . and pca(i) ne . then diffpd_dl_ml=pcp(i)-pca(i); else diffpd_dl_ml=.;

	if tooth(i)=2 then perm=1; else perm=0;
	if tooth(i)=2 or tooth(i)=5 then perm_root=1; else perm_root=0;
	toothstat=tooth(i);
	output;
	end;
	label perm='Permenent tooth status';
	label perm_root='Permenent tooth or permanent tooth fragment status';
	label toothstat='Tooth status';
	format perm perm_root yesnoc.;
	run;

data two;
	set two;
	if i=1 then tooth=2;
	if i=2 then tooth=3;
	if i=3 then tooth=4;
	if i=4 then tooth=5;
	if i=5 then tooth=6;
	if i=6 then tooth=7;
	if i=7 then tooth=8;
	if i=8 then tooth=9;
	if i=9 then tooth=10;
	if i=10 then tooth=11;
	if i=11 then tooth=12;
	if i=12 then tooth=13;
	if i=13 then tooth=14;
	if i=14 then tooth=15;
	if i=15 then tooth=18;
	if i=16 then tooth=19;
	if i=17 then tooth=20;
	if i=18 then tooth=21;
	if i=19 then tooth=22;
	if i=20 then tooth=23;
	if i=21 then tooth=24;
	if i=22 then tooth=25;
	if i=23 then tooth=26;
	if i=24 then tooth=27;
	if i=25 then tooth=28;
	if i=26 then tooth=29;
	if i=27 then tooth=30;
	if i=28 then tooth=31;
	drop i;
	run;

/*Checking how many teeth were missing CAL at each site*/
proc means data=two n nmiss;
where perm=1;
var ladsite lamsite lassite lapsite lalsite laasite pcdsite pcmsite pcssite pcpsite pclsite pcasite;
	run;

proc freq data=two;
where perm=1;
table ladsite lamsite lassite lapsite lalsite laasite pcdsite pcmsite pcssite pcpsite pclsite pcasite/missing;
run;

/*Checking that 
distobuccal-distolingual CAL difference (diffcal_db_dl)
midbucal-midlingual CAL difference (diffcal_midb_midl)
mesiobuccal-mesiolingual CAL difference (diffcal_mb_ml)

distobuccal-distolingual PD difference (diffpd_db_dl)
midbucal-midlingual PD difference (diffpd_midb_midl)
mesiobuccal-mesiolingual PD difference (diffpd_mb_ml)

distobuccal-mesiobuccal CAL diiference (diffcal_db_mb)
distolingual-mesiolingual CAL difference (diffcal_dl_ml)

distobuccal-mesiobuccal PD diiference (diffpd_db_mb)
distolingual-mesiolingual PD difference (diffpd_dl_ml)
were correctly coded*/ 

/*Tooth 2*/
proc print data=two (obs=10);
where tooth=2;
var SEQN tooth toothstat	ohx02lad ohx02lap diffcal_db_dl
							ohx02lam ohx02lal diffcal_midb_midl
							ohx02las ohx02laa diffcal_mb_ml
							ohx02pcd ohx02pcp diffpd_db_dl
							ohx02pcm ohx02pcl diffpd_midb_midl
							ohx02pcs ohx02pca diffpd_mb_ml
							ohx02lad ohx02las diffcal_db_mb
							ohx02lap ohx02laa diffcal_dl_ml
							ohx02pcd ohx02pcs diffpd_db_mb
							ohx02pcp ohx02pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx02lad=. or ohx02lap=.) and tooth=2 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx02lad ohx02lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx02lam=. or ohx02lal=.) and tooth=2 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx02lam ohx02lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx02las=. or ohx02laa=.) and tooth=2 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx02las ohx02laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx02pcd=. or ohx02pcp=.) and tooth=2 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx02pcd ohx02pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx02pcm=. or ohx02pcl=.) and tooth=2 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx02pcm ohx02pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx02pcs=. or ohx02pca=.) and tooth=2 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx02pcs ohx02pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx02lad=. or ohx02las=.) and tooth=2 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx02lad ohx02las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx02lap=. or ohx02laa=.) and tooth=2 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx02lap ohx02laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx02pcd=. or ohx02pcs=.) and tooth=2 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx02pcd ohx02pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx02pcp=. or ohx02pca=.) and tooth=2 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx02pcp ohx02pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx02lad ne . and ohx02lap ne .) and tooth=2 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx02lad ohx02lap diffcal_db_dl;
run;

/*Tooth 3*/
proc print data=two (obs=10);
where tooth=3;
var SEQN tooth toothstat	ohx03lad ohx03lap diffcal_db_dl
							ohx03lam ohx03lal diffcal_midb_midl
							ohx03las ohx03laa diffcal_mb_ml
							ohx03pcd ohx03pcp diffpd_db_dl
							ohx03pcm ohx03pcl diffpd_midb_midl
							ohx03pcs ohx03pca diffpd_mb_ml
							ohx03lad ohx03las diffcal_db_mb
							ohx03lap ohx03laa diffcal_dl_ml
							ohx03pcd ohx03pcs diffpd_db_mb
							ohx03pcp ohx03pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx03lad=. or ohx03lap=.) and tooth=3 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx03lad ohx03lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx03lam=. or ohx03lal=.) and tooth=3 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx03lam ohx03lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx03las=. or ohx03laa=.) and tooth=3 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx03las ohx03laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx03pcd=. or ohx03pcp=.) and tooth=3 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx03pcd ohx03pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx03pcm=. or ohx03pcl=.) and tooth=3 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx03pcm ohx03pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx03pcs=. or ohx03pca=.) and tooth=3 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx03pcs ohx03pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx03lad=. or ohx03las=.) and tooth=3 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx03lad ohx03las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx03lap=. or ohx03laa=.) and tooth=3 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx03lap ohx03laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx03pcd=. or ohx03pcs=.) and tooth=3 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx03pcd ohx03pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx03pcp=. or ohx03pca=.) and tooth=3 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx03pcp ohx03pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx03lad ne . and ohx03lap ne .) and tooth=3 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx03lad ohx03lap diffcal_db_dl;
run;

/*Tooth 4*/
proc print data=two (obs=10);
where tooth=4;
var SEQN tooth toothstat	ohx04lad ohx04lap diffcal_db_dl
							ohx04lam ohx04lal diffcal_midb_midl
							ohx04las ohx04laa diffcal_mb_ml
							ohx04pcd ohx04pcp diffpd_db_dl
							ohx04pcm ohx04pcl diffpd_midb_midl
							ohx04pcs ohx04pca diffpd_mb_ml
							ohx04lad ohx04las diffcal_db_mb
							ohx04lap ohx04laa diffcal_dl_ml
							ohx04pcd ohx04pcs diffpd_db_mb
							ohx04pcp ohx04pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx04lad=. or ohx04lap=.) and tooth=4 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx04lad ohx04lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx04lam=. or ohx04lal=.) and tooth=4 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx04lam ohx04lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx04las=. or ohx04laa=.) and tooth=4 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx04las ohx04laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx04pcd=. or ohx04pcp=.) and tooth=4 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx04pcd ohx04pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx04pcm=. or ohx04pcl=.) and tooth=4 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx04pcm ohx04pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx04pcs=. or ohx04pca=.) and tooth=4 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx04pcs ohx04pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx04lad=. or ohx04las=.) and tooth=4 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx04lad ohx04las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx04lap=. or ohx04laa=.) and tooth=4 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx04lap ohx04laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx04pcd=. or ohx04pcs=.) and tooth=4 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx04pcd ohx04pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx04pcp=. or ohx04pca=.) and tooth=4 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx04pcp ohx04pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx04lad ne . and ohx04lap ne .) and tooth=4 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx04lad ohx04lap diffcal_db_dl;
run;

/*Tooth 5*/
proc print data=two (obs=10);
where tooth=5;
var SEQN tooth toothstat	ohx05lad ohx05lap diffcal_db_dl
							ohx05lam ohx05lal diffcal_midb_midl
							ohx05las ohx05laa diffcal_mb_ml
							ohx05pcd ohx05pcp diffpd_db_dl
							ohx05pcm ohx05pcl diffpd_midb_midl
							ohx05pcs ohx05pca diffpd_mb_ml
							ohx05lad ohx05las diffcal_db_mb
							ohx05lap ohx05laa diffcal_dl_ml
							ohx05pcd ohx05pcs diffpd_db_mb
							ohx05pcp ohx05pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx05lad=. or ohx05lap=.) and tooth=5 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx05lad ohx05lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx05lam=. or ohx05lal=.) and tooth=5 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx05lam ohx05lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx05las=. or ohx05laa=.) and tooth=5 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx05las ohx05laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx05pcd=. or ohx05pcp=.) and tooth=5 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx05pcd ohx05pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx05pcm=. or ohx05pcl=.) and tooth=5 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx05pcm ohx05pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx05pcs=. or ohx05pca=.) and tooth=5 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx05pcs ohx05pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx05lad=. or ohx05las=.) and tooth=5 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx05lad ohx05las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx05lap=. or ohx05laa=.) and tooth=5 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx05lap ohx05laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx05pcd=. or ohx05pcs=.) and tooth=5 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx05pcd ohx05pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx05pcp=. or ohx05pca=.) and tooth=5 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx05pcp ohx05pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx05lad ne . and ohx05lap ne .) and tooth=5 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx05lad ohx05lap diffcal_db_dl;
run;

/*Tooth 6*/
proc print data=two (obs=10);
where tooth=6;
var SEQN tooth toothstat	ohx06lad ohx06lap diffcal_db_dl
							ohx06lam ohx06lal diffcal_midb_midl
							ohx06las ohx06laa diffcal_mb_ml
							ohx06pcd ohx06pcp diffpd_db_dl
							ohx06pcm ohx06pcl diffpd_midb_midl
							ohx06pcs ohx06pca diffpd_mb_ml
							ohx06lad ohx06las diffcal_db_mb
							ohx06lap ohx06laa diffcal_dl_ml
							ohx06pcd ohx06pcs diffpd_db_mb
							ohx06pcp ohx06pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx06lad=. or ohx06lap=.) and tooth=6 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx06lad ohx06lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx06lam=. or ohx06lal=.) and tooth=6 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx06lam ohx06lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx06las=. or ohx06laa=.) and tooth=6 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx06las ohx06laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx06pcd=. or ohx06pcp=.) and tooth=6 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx06pcd ohx06pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx06pcm=. or ohx06pcl=.) and tooth=6 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx06pcm ohx06pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx06pcs=. or ohx06pca=.) and tooth=6 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx06pcs ohx06pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx06lad=. or ohx06las=.) and tooth=6 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx06lad ohx06las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx06lap=. or ohx06laa=.) and tooth=6 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx06lap ohx06laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx06pcd=. or ohx06pcs=.) and tooth=6 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx06pcd ohx06pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx06pcp=. or ohx06pca=.) and tooth=6 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx06pcp ohx06pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx06lad ne . and ohx06lap ne .) and tooth=6 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx06lad ohx06lap diffcal_db_dl;
run;

/*Tooth 7*/
proc print data=two (obs=10);
where tooth=7;
var SEQN tooth toothstat	ohx07lad ohx07lap diffcal_db_dl
							ohx07lam ohx07lal diffcal_midb_midl
							ohx07las ohx07laa diffcal_mb_ml
							ohx07pcd ohx07pcp diffpd_db_dl
							ohx07pcm ohx07pcl diffpd_midb_midl
							ohx07pcs ohx07pca diffpd_mb_ml
							ohx07lad ohx07las diffcal_db_mb
							ohx07lap ohx07laa diffcal_dl_ml
							ohx07pcd ohx07pcs diffpd_db_mb
							ohx07pcp ohx07pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx07lad=. or ohx07lap=.) and tooth=7 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx07lad ohx07lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx07lam=. or ohx07lal=.) and tooth=7 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx07lam ohx07lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx07las=. or ohx07laa=.) and tooth=7 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx07las ohx07laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx07pcd=. or ohx07pcp=.) and tooth=7 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx07pcd ohx07pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx07pcm=. or ohx07pcl=.) and tooth=7 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx07pcm ohx07pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx07pcs=. or ohx07pca=.) and tooth=7 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx07pcs ohx07pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx07lad=. or ohx07las=.) and tooth=7 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx07lad ohx07las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx07lap=. or ohx07laa=.) and tooth=7 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx07lap ohx07laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx07pcd=. or ohx07pcs=.) and tooth=7 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx07pcd ohx07pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx07pcp=. or ohx07pca=.) and tooth=7 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx07pcp ohx07pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx07lad ne . and ohx07lap ne .) and tooth=7 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx07lad ohx07lap diffcal_db_dl;
run;

/*Tooth 8*/
proc print data=two (obs=10);
where tooth=8;
var SEQN tooth toothstat	ohx08lad ohx08lap diffcal_db_dl
							ohx08lam ohx08lal diffcal_midb_midl
							ohx08las ohx08laa diffcal_mb_ml
							ohx08pcd ohx08pcp diffpd_db_dl
							ohx08pcm ohx08pcl diffpd_midb_midl
							ohx08pcs ohx08pca diffpd_mb_ml
							ohx08lad ohx08las diffcal_db_mb
							ohx08lap ohx08laa diffcal_dl_ml
							ohx08pcd ohx08pcs diffpd_db_mb
							ohx08pcp ohx08pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx08lad=. or ohx08lap=.) and tooth=8 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx08lad ohx08lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx08lam=. or ohx08lal=.) and tooth=8 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx08lam ohx08lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx08las=. or ohx08laa=.) and tooth=8 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx08las ohx08laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx08pcd=. or ohx08pcp=.) and tooth=8 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx08pcd ohx08pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx08pcm=. or ohx08pcl=.) and tooth=8 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx08pcm ohx08pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx08pcs=. or ohx08pca=.) and tooth=8 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx08pcs ohx08pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx08lad=. or ohx08las=.) and tooth=8 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx08lad ohx08las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx08lap=. or ohx08laa=.) and tooth=8 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx08lap ohx08laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx08pcd=. or ohx08pcs=.) and tooth=8 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx08pcd ohx08pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx08pcp=. or ohx08pca=.) and tooth=8 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx08pcp ohx08pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx08lad ne . and ohx08lap ne .) and tooth=8 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx08lad ohx08lap diffcal_db_dl;
run;

/*Tooth 9*/
proc print data=two (obs=10);
where tooth=9;
var SEQN tooth toothstat	ohx09lad ohx09lap diffcal_db_dl
							ohx09lam ohx09lal diffcal_midb_midl
							ohx09las ohx09laa diffcal_mb_ml
							ohx09pcd ohx09pcp diffpd_db_dl
							ohx09pcm ohx09pcl diffpd_midb_midl
							ohx09pcs ohx09pca diffpd_mb_ml
							ohx09lad ohx09las diffcal_db_mb
							ohx09lap ohx09laa diffcal_dl_ml
							ohx09pcd ohx09pcs diffpd_db_mb
							ohx09pcp ohx09pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx09lad=. or ohx09lap=.) and tooth=9 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx09lad ohx09lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx09lam=. or ohx09lal=.) and tooth=9 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx09lam ohx09lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx09las=. or ohx09laa=.) and tooth=9 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx09las ohx09laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx09pcd=. or ohx09pcp=.) and tooth=9 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx09pcd ohx09pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx09pcm=. or ohx09pcl=.) and tooth=9 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx09pcm ohx09pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx09pcs=. or ohx09pca=.) and tooth=9 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx09pcs ohx09pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx09lad=. or ohx09las=.) and tooth=9 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx09lad ohx09las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx09lap=. or ohx09laa=.) and tooth=9 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx09lap ohx09laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx09pcd=. or ohx09pcs=.) and tooth=9 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx09pcd ohx09pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx09pcp=. or ohx09pca=.) and tooth=9 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx09pcp ohx09pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx09lad ne . and ohx09lap ne .) and tooth=9 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx09lad ohx09lap diffcal_db_dl;
run;

/*Tooth 10*/
proc print data=two (obs=10);
where tooth=10;
var SEQN tooth toothstat	ohx10lad ohx10lap diffcal_db_dl
							ohx10lam ohx10lal diffcal_midb_midl
							ohx10las ohx10laa diffcal_mb_ml
							ohx10pcd ohx10pcp diffpd_db_dl
							ohx10pcm ohx10pcl diffpd_midb_midl
							ohx10pcs ohx10pca diffpd_mb_ml
							ohx10lad ohx10las diffcal_db_mb
							ohx10lap ohx10laa diffcal_dl_ml
							ohx10pcd ohx10pcs diffpd_db_mb
							ohx10pcp ohx10pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx10lad=. or ohx10lap=.) and tooth=10 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx10lad ohx10lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx10lam=. or ohx10lal=.) and tooth=10 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx10lam ohx10lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx10las=. or ohx10laa=.) and tooth=10 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx10las ohx10laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx10pcd=. or ohx10pcp=.) and tooth=10 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx10pcd ohx10pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx10pcm=. or ohx10pcl=.) and tooth=10 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx10pcm ohx10pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx10pcs=. or ohx10pca=.) and tooth=10 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx10pcs ohx10pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx10lad=. or ohx10las=.) and tooth=10 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx10lad ohx10las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx10lap=. or ohx10laa=.) and tooth=10 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx10lap ohx10laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx10pcd=. or ohx10pcs=.) and tooth=10 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx10pcd ohx10pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx10pcp=. or ohx10pca=.) and tooth=10 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx10pcp ohx10pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx10lad ne . and ohx10lap ne .) and tooth=10 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx10lad ohx10lap diffcal_db_dl;
run;

/*Tooth 11*/
proc print data=two (obs=10);
where tooth=11;
var SEQN tooth toothstat	ohx11lad ohx11lap diffcal_db_dl
							ohx11lam ohx11lal diffcal_midb_midl
							ohx11las ohx11laa diffcal_mb_ml
							ohx11pcd ohx11pcp diffpd_db_dl
							ohx11pcm ohx11pcl diffpd_midb_midl
							ohx11pcs ohx11pca diffpd_mb_ml
							ohx11lad ohx11las diffcal_db_mb
							ohx11lap ohx11laa diffcal_dl_ml
							ohx11pcd ohx11pcs diffpd_db_mb
							ohx11pcp ohx11pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx11lad=. or ohx11lap=.) and tooth=11 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx11lad ohx11lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx11lam=. or ohx11lal=.) and tooth=11 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx11lam ohx11lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx11las=. or ohx11laa=.) and tooth=11 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx11las ohx11laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx11pcd=. or ohx11pcp=.) and tooth=11 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx11pcd ohx11pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx11pcm=. or ohx11pcl=.) and tooth=11 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx11pcm ohx11pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx11pcs=. or ohx11pca=.) and tooth=11 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx11pcs ohx11pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx11lad=. or ohx11las=.) and tooth=11 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx11lad ohx11las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx11lap=. or ohx11laa=.) and tooth=11 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx11lap ohx11laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx11pcd=. or ohx11pcs=.) and tooth=11 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx11pcd ohx11pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx11pcp=. or ohx11pca=.) and tooth=11 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx11pcp ohx11pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx11lad ne . and ohx11lap ne .) and tooth=11 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx11lad ohx11lap diffcal_db_dl;
run;

/*Tooth 12*/
proc print data=two (obs=10);
where tooth=12;
var SEQN tooth toothstat	ohx12lad ohx12lap diffcal_db_dl
							ohx12lam ohx12lal diffcal_midb_midl
							ohx12las ohx12laa diffcal_mb_ml
							ohx12pcd ohx12pcp diffpd_db_dl
							ohx12pcm ohx12pcl diffpd_midb_midl
							ohx12pcs ohx12pca diffpd_mb_ml
							ohx12lad ohx12las diffcal_db_mb
							ohx12lap ohx12laa diffcal_dl_ml
							ohx12pcd ohx12pcs diffpd_db_mb
							ohx12pcp ohx12pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx12lad=. or ohx12lap=.) and tooth=12 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx12lad ohx12lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx12lam=. or ohx12lal=.) and tooth=12 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx12lam ohx12lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx12las=. or ohx12laa=.) and tooth=12 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx12las ohx12laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx12pcd=. or ohx12pcp=.) and tooth=12 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx12pcd ohx12pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx12pcm=. or ohx12pcl=.) and tooth=12 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx12pcm ohx12pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx12pcs=. or ohx12pca=.) and tooth=12 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx12pcs ohx12pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx12lad=. or ohx12las=.) and tooth=12 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx12lad ohx12las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx12lap=. or ohx12laa=.) and tooth=12 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx12lap ohx12laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx12pcd=. or ohx12pcs=.) and tooth=12 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx12pcd ohx12pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx12pcp=. or ohx12pca=.) and tooth=12 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx12pcp ohx12pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx12lad ne . and ohx12lap ne .) and tooth=12 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx12lad ohx12lap diffcal_db_dl;
run;

/*Tooth 13*/
proc print data=two (obs=10);
where tooth=13;
var SEQN tooth toothstat	ohx13lad ohx13lap diffcal_db_dl
							ohx13lam ohx13lal diffcal_midb_midl
							ohx13las ohx13laa diffcal_mb_ml
							ohx13pcd ohx13pcp diffpd_db_dl
							ohx13pcm ohx13pcl diffpd_midb_midl
							ohx13pcs ohx13pca diffpd_mb_ml
							ohx13lad ohx13las diffcal_db_mb
							ohx13lap ohx13laa diffcal_dl_ml
							ohx13pcd ohx13pcs diffpd_db_mb
							ohx13pcp ohx13pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx13lad=. or ohx13lap=.) and tooth=13 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx13lad ohx13lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx13lam=. or ohx13lal=.) and tooth=13 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx13lam ohx13lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx13las=. or ohx13laa=.) and tooth=13 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx13las ohx13laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx13pcd=. or ohx13pcp=.) and tooth=13 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx13pcd ohx13pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx13pcm=. or ohx13pcl=.) and tooth=13 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx13pcm ohx13pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx13pcs=. or ohx13pca=.) and tooth=13 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx13pcs ohx13pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx13lad=. or ohx13las=.) and tooth=13 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx13lad ohx13las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx13lap=. or ohx13laa=.) and tooth=13 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx13lap ohx13laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx13pcd=. or ohx13pcs=.) and tooth=13 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx13pcd ohx13pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx13pcp=. or ohx13pca=.) and tooth=13 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx13pcp ohx13pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx13lad ne . and ohx13lap ne .) and tooth=13 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx13lad ohx13lap diffcal_db_dl;
run;

/*Tooth 14*/
proc print data=two (obs=10);
where tooth=14;
var SEQN tooth toothstat	ohx14lad ohx14lap diffcal_db_dl
							ohx14lam ohx14lal diffcal_midb_midl
							ohx14las ohx14laa diffcal_mb_ml
							ohx14pcd ohx14pcp diffpd_db_dl
							ohx14pcm ohx14pcl diffpd_midb_midl
							ohx14pcs ohx14pca diffpd_mb_ml
							ohx14lad ohx14las diffcal_db_mb
							ohx14lap ohx14laa diffcal_dl_ml
							ohx14pcd ohx14pcs diffpd_db_mb
							ohx14pcp ohx14pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx14lad=. or ohx14lap=.) and tooth=14 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx14lad ohx14lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx14lam=. or ohx14lal=.) and tooth=14 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx14lam ohx14lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx14las=. or ohx14laa=.) and tooth=14 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx14las ohx14laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx14pcd=. or ohx14pcp=.) and tooth=14 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx14pcd ohx14pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx14pcm=. or ohx14pcl=.) and tooth=14 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx14pcm ohx14pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx14pcs=. or ohx14pca=.) and tooth=14 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx14pcs ohx14pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx14lad=. or ohx14las=.) and tooth=14 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx14lad ohx14las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx14lap=. or ohx14laa=.) and tooth=14 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx14lap ohx14laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx14pcd=. or ohx14pcs=.) and tooth=14 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx14pcd ohx14pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx14pcp=. or ohx14pca=.) and tooth=14 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx14pcp ohx14pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx14lad ne . and ohx14lap ne .) and tooth=14 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx14lad ohx14lap diffcal_db_dl;
run;

/*Tooth 15*/
proc print data=two (obs=10);
where tooth=15;
var SEQN tooth toothstat	ohx15lad ohx15lap diffcal_db_dl
							ohx15lam ohx15lal diffcal_midb_midl
							ohx15las ohx15laa diffcal_mb_ml
							ohx15pcd ohx15pcp diffpd_db_dl
							ohx15pcm ohx15pcl diffpd_midb_midl
							ohx15pcs ohx15pca diffpd_mb_ml
							ohx15lad ohx15las diffcal_db_mb
							ohx15lap ohx15laa diffcal_dl_ml
							ohx15pcd ohx15pcs diffpd_db_mb
							ohx15pcp ohx15pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx15lad=. or ohx15lap=.) and tooth=15 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx15lad ohx15lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx15lam=. or ohx15lal=.) and tooth=15 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx15lam ohx15lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx15las=. or ohx15laa=.) and tooth=15 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx15las ohx15laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx15pcd=. or ohx15pcp=.) and tooth=15 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx15pcd ohx15pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx15pcm=. or ohx15pcl=.) and tooth=15 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx15pcm ohx15pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx15pcs=. or ohx15pca=.) and tooth=15 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx15pcs ohx15pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx15lad=. or ohx15las=.) and tooth=15 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx15lad ohx15las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx15lap=. or ohx15laa=.) and tooth=15 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx15lap ohx15laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx15pcd=. or ohx15pcs=.) and tooth=15 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx15pcd ohx15pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx15pcp=. or ohx15pca=.) and tooth=15 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx15pcp ohx15pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx15lad ne . and ohx15lap ne .) and tooth=15 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx15lad ohx15lap diffcal_db_dl;
run;

/*Tooth 18*/
proc print data=two (obs=10);
where tooth=18;
var SEQN tooth toothstat	ohx18lad ohx18lap diffcal_db_dl
							ohx18lam ohx18lal diffcal_midb_midl
							ohx18las ohx18laa diffcal_mb_ml
							ohx18pcd ohx18pcp diffpd_db_dl
							ohx18pcm ohx18pcl diffpd_midb_midl
							ohx18pcs ohx18pca diffpd_mb_ml
							ohx18lad ohx18las diffcal_db_mb
							ohx18lap ohx18laa diffcal_dl_ml
							ohx18pcd ohx18pcs diffpd_db_mb
							ohx18pcp ohx18pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx18lad=. or ohx18lap=.) and tooth=18 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx18lad ohx18lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx18lam=. or ohx18lal=.) and tooth=18 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx18lam ohx18lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx18las=. or ohx18laa=.) and tooth=18 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx18las ohx18laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx18pcd=. or ohx18pcp=.) and tooth=18 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx18pcd ohx18pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx18pcm=. or ohx18pcl=.) and tooth=18 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx18pcm ohx18pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx18pcs=. or ohx18pca=.) and tooth=18 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx18pcs ohx18pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx18lad=. or ohx18las=.) and tooth=18 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx18lad ohx18las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx18lap=. or ohx18laa=.) and tooth=18 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx18lap ohx18laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx18pcd=. or ohx18pcs=.) and tooth=18 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx18pcd ohx18pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx18pcp=. or ohx18pca=.) and tooth=18 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx18pcp ohx18pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx18lad ne . and ohx18lap ne .) and tooth=18 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx18lad ohx18lap diffcal_db_dl;
run;

/*Tooth 19*/
proc print data=two (obs=10);
where tooth=19;
var SEQN tooth toothstat	ohx19lad ohx19lap diffcal_db_dl
							ohx19lam ohx19lal diffcal_midb_midl
							ohx19las ohx19laa diffcal_mb_ml
							ohx19pcd ohx19pcp diffpd_db_dl
							ohx19pcm ohx19pcl diffpd_midb_midl
							ohx19pcs ohx19pca diffpd_mb_ml
							ohx19lad ohx19las diffcal_db_mb
							ohx19lap ohx19laa diffcal_dl_ml
							ohx19pcd ohx19pcs diffpd_db_mb
							ohx19pcp ohx19pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx19lad=. or ohx19lap=.) and tooth=19 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx19lad ohx19lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx19lam=. or ohx19lal=.) and tooth=19 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx19lam ohx19lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx19las=. or ohx19laa=.) and tooth=19 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx19las ohx19laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx19pcd=. or ohx19pcp=.) and tooth=19 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx19pcd ohx19pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx19pcm=. or ohx19pcl=.) and tooth=19 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx19pcm ohx19pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx19pcs=. or ohx19pca=.) and tooth=19 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx19pcs ohx19pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx19lad=. or ohx19las=.) and tooth=19 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx19lad ohx19las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx19lap=. or ohx19laa=.) and tooth=19 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx19lap ohx19laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx19pcd=. or ohx19pcs=.) and tooth=19 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx19pcd ohx19pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx19pcp=. or ohx19pca=.) and tooth=19 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx19pcp ohx19pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx19lad ne . and ohx19lap ne .) and tooth=19 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx19lad ohx19lap diffcal_db_dl;
run;

/*Tooth 20*/
proc print data=two (obs=10);
where tooth=20;
var SEQN tooth toothstat	ohx20lad ohx20lap diffcal_db_dl
							ohx20lam ohx20lal diffcal_midb_midl
							ohx20las ohx20laa diffcal_mb_ml
							ohx20pcd ohx20pcp diffpd_db_dl
							ohx20pcm ohx20pcl diffpd_midb_midl
							ohx20pcs ohx20pca diffpd_mb_ml
							ohx20lad ohx20las diffcal_db_mb
							ohx20lap ohx20laa diffcal_dl_ml
							ohx20pcd ohx20pcs diffpd_db_mb
							ohx20pcp ohx20pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx20lad=. or ohx20lap=.) and tooth=20 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx20lad ohx20lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx20lam=. or ohx20lal=.) and tooth=20 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx20lam ohx20lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx20las=. or ohx20laa=.) and tooth=20 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx20las ohx20laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx20pcd=. or ohx20pcp=.) and tooth=20 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx20pcd ohx20pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx20pcm=. or ohx20pcl=.) and tooth=20 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx20pcm ohx20pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx20pcs=. or ohx20pca=.) and tooth=20 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx20pcs ohx20pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx20lad=. or ohx20las=.) and tooth=20 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx20lad ohx20las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx20lap=. or ohx20laa=.) and tooth=20 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx20lap ohx20laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx20pcd=. or ohx20pcs=.) and tooth=20 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx20pcd ohx20pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx20pcp=. or ohx20pca=.) and tooth=20 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx20pcp ohx20pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx20lad ne . and ohx20lap ne .) and tooth=20 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx20lad ohx20lap diffcal_db_dl;
run;

/*Tooth 21*/
proc print data=two (obs=10);
where tooth=21;
var SEQN tooth toothstat	ohx21lad ohx21lap diffcal_db_dl
							ohx21lam ohx21lal diffcal_midb_midl
							ohx21las ohx21laa diffcal_mb_ml
							ohx21pcd ohx21pcp diffpd_db_dl
							ohx21pcm ohx21pcl diffpd_midb_midl
							ohx21pcs ohx21pca diffpd_mb_ml
							ohx21lad ohx21las diffcal_db_mb
							ohx21lap ohx21laa diffcal_dl_ml
							ohx21pcd ohx21pcs diffpd_db_mb
							ohx21pcp ohx21pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx21lad=. or ohx21lap=.) and tooth=21 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx21lad ohx21lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx21lam=. or ohx21lal=.) and tooth=21 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx21lam ohx21lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx21las=. or ohx21laa=.) and tooth=21 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx21las ohx21laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx21pcd=. or ohx21pcp=.) and tooth=21 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx21pcd ohx21pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx21pcm=. or ohx21pcl=.) and tooth=21 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx21pcm ohx21pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx21pcs=. or ohx21pca=.) and tooth=21 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx21pcs ohx21pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx21lad=. or ohx21las=.) and tooth=21 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx21lad ohx21las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx21lap=. or ohx21laa=.) and tooth=21 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx21lap ohx21laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx21pcd=. or ohx21pcs=.) and tooth=21 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx21pcd ohx21pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx21pcp=. or ohx21pca=.) and tooth=21 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx21pcp ohx21pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx21lad ne . and ohx21lap ne .) and tooth=21 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx21lad ohx21lap diffcal_db_dl;
run;

/*Tooth 22*/
proc print data=two (obs=10);
where tooth=22;
var SEQN tooth toothstat	ohx22lad ohx22lap diffcal_db_dl
							ohx22lam ohx22lal diffcal_midb_midl
							ohx22las ohx22laa diffcal_mb_ml
							ohx22pcd ohx22pcp diffpd_db_dl
							ohx22pcm ohx22pcl diffpd_midb_midl
							ohx22pcs ohx22pca diffpd_mb_ml
							ohx22lad ohx22las diffcal_db_mb
							ohx22lap ohx22laa diffcal_dl_ml
							ohx22pcd ohx22pcs diffpd_db_mb
							ohx22pcp ohx22pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx22lad=. or ohx22lap=.) and tooth=22 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx22lad ohx22lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx22lam=. or ohx22lal=.) and tooth=22 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx22lam ohx22lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx22las=. or ohx22laa=.) and tooth=22 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx22las ohx22laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx22pcd=. or ohx22pcp=.) and tooth=22 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx22pcd ohx22pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx22pcm=. or ohx22pcl=.) and tooth=22 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx22pcm ohx22pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx22pcs=. or ohx22pca=.) and tooth=22 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx22pcs ohx22pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx22lad=. or ohx22las=.) and tooth=22 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx22lad ohx22las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx22lap=. or ohx22laa=.) and tooth=22 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx22lap ohx22laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx22pcd=. or ohx22pcs=.) and tooth=22 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx22pcd ohx22pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx22pcp=. or ohx22pca=.) and tooth=22 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx22pcp ohx22pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx22lad ne . and ohx22lap ne .) and tooth=22 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx22lad ohx22lap diffcal_db_dl;
run;

/*Tooth 23*/
proc print data=two (obs=10);
where tooth=23;
var SEQN tooth toothstat	ohx23lad ohx23lap diffcal_db_dl
							ohx23lam ohx23lal diffcal_midb_midl
							ohx23las ohx23laa diffcal_mb_ml
							ohx23pcd ohx23pcp diffpd_db_dl
							ohx23pcm ohx23pcl diffpd_midb_midl
							ohx23pcs ohx23pca diffpd_mb_ml
							ohx23lad ohx23las diffcal_db_mb
							ohx23lap ohx23laa diffcal_dl_ml
							ohx23pcd ohx23pcs diffpd_db_mb
							ohx23pcp ohx23pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx23lad=. or ohx23lap=.) and tooth=23 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx23lad ohx23lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx23lam=. or ohx23lal=.) and tooth=23 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx23lam ohx23lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx23las=. or ohx23laa=.) and tooth=23 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx23las ohx23laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx23pcd=. or ohx23pcp=.) and tooth=23 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx23pcd ohx23pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx23pcm=. or ohx23pcl=.) and tooth=23 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx23pcm ohx23pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx23pcs=. or ohx23pca=.) and tooth=23 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx23pcs ohx23pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx23lad=. or ohx23las=.) and tooth=23 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx23lad ohx23las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx23lap=. or ohx23laa=.) and tooth=23 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx23lap ohx23laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx23pcd=. or ohx23pcs=.) and tooth=23 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx23pcd ohx23pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx23pcp=. or ohx23pca=.) and tooth=23 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx23pcp ohx23pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx23lad ne . and ohx23lap ne .) and tooth=23 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx23lad ohx23lap diffcal_db_dl;
run;

/*Tooth 24*/
proc print data=two (obs=10);
where tooth=24;
var SEQN tooth toothstat	ohx24lad ohx24lap diffcal_db_dl
							ohx24lam ohx24lal diffcal_midb_midl
							ohx24las ohx24laa diffcal_mb_ml
							ohx24pcd ohx24pcp diffpd_db_dl
							ohx24pcm ohx24pcl diffpd_midb_midl
							ohx24pcs ohx24pca diffpd_mb_ml
							ohx24lad ohx24las diffcal_db_mb
							ohx24lap ohx24laa diffcal_dl_ml
							ohx24pcd ohx24pcs diffpd_db_mb
							ohx24pcp ohx24pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx24lad=. or ohx24lap=.) and tooth=24 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx24lad ohx24lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx24lam=. or ohx24lal=.) and tooth=24 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx24lam ohx24lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx24las=. or ohx24laa=.) and tooth=24 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx24las ohx24laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx24pcd=. or ohx24pcp=.) and tooth=24 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx24pcd ohx24pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx24pcm=. or ohx24pcl=.) and tooth=24 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx24pcm ohx24pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx24pcs=. or ohx24pca=.) and tooth=24 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx24pcs ohx24pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx24lad=. or ohx24las=.) and tooth=24 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx24lad ohx24las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx24lap=. or ohx24laa=.) and tooth=24 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx24lap ohx24laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx24pcd=. or ohx24pcs=.) and tooth=24 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx24pcd ohx24pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx24pcp=. or ohx24pca=.) and tooth=24 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx24pcp ohx24pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx24lad ne . and ohx24lap ne .) and tooth=24 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx24lad ohx24lap diffcal_db_dl;
run;

/*Tooth 25*/
proc print data=two (obs=10);
where tooth=25;
var SEQN tooth toothstat	ohx25lad ohx25lap diffcal_db_dl
							ohx25lam ohx25lal diffcal_midb_midl
							ohx25las ohx25laa diffcal_mb_ml
							ohx25pcd ohx25pcp diffpd_db_dl
							ohx25pcm ohx25pcl diffpd_midb_midl
							ohx25pcs ohx25pca diffpd_mb_ml
							ohx25lad ohx25las diffcal_db_mb
							ohx25lap ohx25laa diffcal_dl_ml
							ohx25pcd ohx25pcs diffpd_db_mb
							ohx25pcp ohx25pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx25lad=. or ohx25lap=.) and tooth=25 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx25lad ohx25lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx25lam=. or ohx25lal=.) and tooth=25 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx25lam ohx25lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx25las=. or ohx25laa=.) and tooth=25 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx25las ohx25laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx25pcd=. or ohx25pcp=.) and tooth=25 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx25pcd ohx25pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx25pcm=. or ohx25pcl=.) and tooth=25 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx25pcm ohx25pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx25pcs=. or ohx25pca=.) and tooth=25 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx25pcs ohx25pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx25lad=. or ohx25las=.) and tooth=25 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx25lad ohx25las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx25lap=. or ohx25laa=.) and tooth=25 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx25lap ohx25laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx25pcd=. or ohx25pcs=.) and tooth=25 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx25pcd ohx25pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx25pcp=. or ohx25pca=.) and tooth=25 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx25pcp ohx25pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx25lad ne . and ohx25lap ne .) and tooth=25 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx25lad ohx25lap diffcal_db_dl;
run;

/*Tooth 26*/
proc print data=two (obs=10);
where tooth=26;
var SEQN tooth toothstat	ohx26lad ohx26lap diffcal_db_dl
							ohx26lam ohx26lal diffcal_midb_midl
							ohx26las ohx26laa diffcal_mb_ml
							ohx26pcd ohx26pcp diffpd_db_dl
							ohx26pcm ohx26pcl diffpd_midb_midl
							ohx26pcs ohx26pca diffpd_mb_ml
							ohx26lad ohx26las diffcal_db_mb
							ohx26lap ohx26laa diffcal_dl_ml
							ohx26pcd ohx26pcs diffpd_db_mb
							ohx26pcp ohx26pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx26lad=. or ohx26lap=.) and tooth=26 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx26lad ohx26lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx26lam=. or ohx26lal=.) and tooth=26 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx26lam ohx26lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx26las=. or ohx26laa=.) and tooth=26 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx26las ohx26laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx26pcd=. or ohx26pcp=.) and tooth=26 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx26pcd ohx26pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx26pcm=. or ohx26pcl=.) and tooth=26 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx26pcm ohx26pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx26pcs=. or ohx26pca=.) and tooth=26 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx26pcs ohx26pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx26lad=. or ohx26las=.) and tooth=26 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx26lad ohx26las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx26lap=. or ohx26laa=.) and tooth=26 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx26lap ohx26laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx26pcd=. or ohx26pcs=.) and tooth=26 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx26pcd ohx26pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx26pcp=. or ohx26pca=.) and tooth=26 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx26pcp ohx26pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx26lad ne . and ohx26lap ne .) and tooth=26 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx26lad ohx26lap diffcal_db_dl;
run;

/*Tooth 27*/
proc print data=two (obs=10);
where tooth=27;
var SEQN tooth toothstat	ohx27lad ohx27lap diffcal_db_dl
							ohx27lam ohx27lal diffcal_midb_midl
							ohx27las ohx27laa diffcal_mb_ml
							ohx27pcd ohx27pcp diffpd_db_dl
							ohx27pcm ohx27pcl diffpd_midb_midl
							ohx27pcs ohx27pca diffpd_mb_ml
							ohx27lad ohx27las diffcal_db_mb
							ohx27lap ohx27laa diffcal_dl_ml
							ohx27pcd ohx27pcs diffpd_db_mb
							ohx27pcp ohx27pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx27lad=. or ohx27lap=.) and tooth=27 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx27lad ohx27lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx27lam=. or ohx27lal=.) and tooth=27 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx27lam ohx27lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx27las=. or ohx27laa=.) and tooth=27 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx27las ohx27laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx27pcd=. or ohx27pcp=.) and tooth=27 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx27pcd ohx27pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx27pcm=. or ohx27pcl=.) and tooth=27 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx27pcm ohx27pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx27pcs=. or ohx27pca=.) and tooth=27 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx27pcs ohx27pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx27lad=. or ohx27las=.) and tooth=27 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx27lad ohx27las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx27lap=. or ohx27laa=.) and tooth=27 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx27lap ohx27laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx27pcd=. or ohx27pcs=.) and tooth=27 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx27pcd ohx27pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx27pcp=. or ohx27pca=.) and tooth=27 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx27pcp ohx27pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx27lad ne . and ohx27lap ne .) and tooth=27 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx27lad ohx27lap diffcal_db_dl;
run;

/*Tooth 28*/
proc print data=two (obs=10);
where tooth=28;
var SEQN tooth toothstat	ohx28lad ohx28lap diffcal_db_dl
							ohx28lam ohx28lal diffcal_midb_midl
							ohx28las ohx28laa diffcal_mb_ml
							ohx28pcd ohx28pcp diffpd_db_dl
							ohx28pcm ohx28pcl diffpd_midb_midl
							ohx28pcs ohx28pca diffpd_mb_ml
							ohx28lad ohx28las diffcal_db_mb
							ohx28lap ohx28laa diffcal_dl_ml
							ohx28pcd ohx28pcs diffpd_db_mb
							ohx28pcp ohx28pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx28lad=. or ohx28lap=.) and tooth=28 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx28lad ohx28lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx28lam=. or ohx28lal=.) and tooth=28 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx28lam ohx28lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx28las=. or ohx28laa=.) and tooth=28 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx28las ohx28laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx28pcd=. or ohx28pcp=.) and tooth=28 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx28pcd ohx28pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx28pcm=. or ohx28pcl=.) and tooth=28 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx28pcm ohx28pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx28pcs=. or ohx28pca=.) and tooth=28 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx28pcs ohx28pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx28lad=. or ohx28las=.) and tooth=28 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx28lad ohx28las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx28lap=. or ohx28laa=.) and tooth=28 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx28lap ohx28laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx28pcd=. or ohx28pcs=.) and tooth=28 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx28pcd ohx28pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx28pcp=. or ohx28pca=.) and tooth=28 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx28pcp ohx28pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx28lad ne . and ohx28lap ne .) and tooth=28 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx28lad ohx28lap diffcal_db_dl;
run;

/*Tooth 29*/
proc print data=two (obs=10);
where tooth=29;
var SEQN tooth toothstat	ohx29lad ohx29lap diffcal_db_dl
							ohx29lam ohx29lal diffcal_midb_midl
							ohx29las ohx29laa diffcal_mb_ml
							ohx29pcd ohx29pcp diffpd_db_dl
							ohx29pcm ohx29pcl diffpd_midb_midl
							ohx29pcs ohx29pca diffpd_mb_ml
							ohx29lad ohx29las diffcal_db_mb
							ohx29lap ohx29laa diffcal_dl_ml
							ohx29pcd ohx29pcs diffpd_db_mb
							ohx29pcp ohx29pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx29lad=. or ohx29lap=.) and tooth=29 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx29lad ohx29lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx29lam=. or ohx29lal=.) and tooth=29 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx29lam ohx29lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx29las=. or ohx29laa=.) and tooth=29 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx29las ohx29laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx29pcd=. or ohx29pcp=.) and tooth=29 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx29pcd ohx29pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx29pcm=. or ohx29pcl=.) and tooth=29 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx29pcm ohx29pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx29pcs=. or ohx29pca=.) and tooth=29 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx29pcs ohx29pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx29lad=. or ohx29las=.) and tooth=29 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx29lad ohx29las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx29lap=. or ohx29laa=.) and tooth=29 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx29lap ohx29laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx29pcd=. or ohx29pcs=.) and tooth=29 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx29pcd ohx29pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx29pcp=. or ohx29pca=.) and tooth=29 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx29pcp ohx29pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx29lad ne . and ohx29lap ne .) and tooth=29 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx29lad ohx29lap diffcal_db_dl;
run;

/*Tooth 30*/
proc print data=two (obs=10);
where tooth=30;
var SEQN tooth toothstat	ohx30lad ohx30lap diffcal_db_dl
							ohx30lam ohx30lal diffcal_midb_midl
							ohx30las ohx30laa diffcal_mb_ml
							ohx30pcd ohx30pcp diffpd_db_dl
							ohx30pcm ohx30pcl diffpd_midb_midl
							ohx30pcs ohx30pca diffpd_mb_ml
							ohx30lad ohx30las diffcal_db_mb
							ohx30lap ohx30laa diffcal_dl_ml
							ohx30pcd ohx30pcs diffpd_db_mb
							ohx30pcp ohx30pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx30lad=. or ohx30lap=.) and tooth=30 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx30lad ohx30lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx30lam=. or ohx30lal=.) and tooth=30 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx30lam ohx30lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx30las=. or ohx30laa=.) and tooth=30 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx30las ohx30laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx30pcd=. or ohx30pcp=.) and tooth=30 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx30pcd ohx30pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx30pcm=. or ohx30pcl=.) and tooth=30 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx30pcm ohx30pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx30pcs=. or ohx30pca=.) and tooth=30 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx30pcs ohx30pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx30lad=. or ohx30las=.) and tooth=30 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx30lad ohx30las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx30lap=. or ohx30laa=.) and tooth=30 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx30lap ohx30laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx30pcd=. or ohx30pcs=.) and tooth=30 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx30pcd ohx30pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx30pcp=. or ohx30pca=.) and tooth=30 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx30pcp ohx30pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx30lad ne . and ohx30lap ne .) and tooth=30 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx30lad ohx30lap diffcal_db_dl;
run;

/*Tooth 31*/
proc print data=two (obs=10);
where tooth=31;
var SEQN tooth toothstat	ohx31lad ohx31lap diffcal_db_dl
							ohx31lam ohx31lal diffcal_midb_midl
							ohx31las ohx31laa diffcal_mb_ml
							ohx31pcd ohx31pcp diffpd_db_dl
							ohx31pcm ohx31pcl diffpd_midb_midl
							ohx31pcs ohx31pca diffpd_mb_ml
							ohx31lad ohx31las diffcal_db_mb
							ohx31lap ohx31laa diffcal_dl_ml
							ohx31pcd ohx31pcs diffpd_db_mb
							ohx31pcp ohx31pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx31lad=. or ohx31lap=.) and tooth=31 and toothstat=2 and diffcal_db_dl ne .;
var SEQN tooth ohx31lad ohx31lap diffcal_db_dl;
run;

proc print data=two (obs=10);
where (ohx31lam=. or ohx31lal=.) and tooth=31 and toothstat=2 and diffcal_midb_midl ne .;
var SEQN tooth ohx31lam ohx31lal diffcal_midb_midl;
run;

proc print data=two (obs=10);
where (ohx31las=. or ohx31laa=.) and tooth=31 and toothstat=2 and diffcal_mb_ml ne .;
var SEQN tooth ohx31las ohx31laa diffcal_mb_ml;
run;

proc print data=two (obs=10);
where (ohx31pcd=. or ohx31pcp=.) and tooth=31 and toothstat=2 and diffpd_db_dl ne .;
var SEQN tooth ohx31pcd ohx31pcp diffpd_db_dl;
run;

proc print data=two (obs=10);
where (ohx31pcm=. or ohx31pcl=.) and tooth=31 and toothstat=2 and diffpd_midb_midl ne .;
var SEQN tooth ohx31pcm ohx31pcl diffpd_midb_midl;
run;

proc print data=two (obs=10);
where (ohx31pcs=. or ohx31pca=.) and tooth=31 and toothstat=2 and diffpd_mb_ml ne .;
var SEQN tooth ohx31pcs ohx31pca diffpd_mb_ml;
run;

proc print data=two (obs=10);
where (ohx31lad=. or ohx31las=.) and tooth=31 and toothstat=2 and diffcal_db_mb ne .;
var SEQN tooth ohx31lad ohx31las diffcal_db_mb;
run;

proc print data=two (obs=10);
where (ohx31lap=. or ohx31laa=.) and tooth=31 and toothstat=2 and diffcal_dl_ml ne .;
var SEQN tooth ohx31lap ohx31laa diffcal_dl_ml;
run;

proc print data=two (obs=10);
where (ohx31pcd=. or ohx31pcs=.) and tooth=31 and toothstat=2 and diffpd_db_mb ne .;
var SEQN tooth ohx31pcd ohx31pcs diffpd_db_mb;
run;

proc print data=two (obs=10);
where (ohx31pcp=. or ohx31pca=.) and tooth=31 and toothstat=2 and diffpd_dl_ml ne .;
var SEQN tooth ohx31pcp ohx31pca diffpd_dl_ml;
run;

proc print data=two (obs=10);
where (ohx31lad ne . and ohx31lap ne .) and tooth=31 and toothstat=2 and diffcal_db_dl=.;
var SEQN tooth ohx31lad ohx31lap diffcal_db_dl;
run;

/*Restricting to permanent teeth only*/
/*Note: a total of 245,248 teeth were permanent teeth*/
data two;
	set two;
	if perm=1;
	run;

proc sort data=two; by SEQN;
run;

/* Difference between buccal and lingual as well as between mesial and sital sites for the whole mouth*/
/*with complex design of NHANES*/
proc means data=two n nmiss mean std stderr;
var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc surveymeans data=two nmiss mean stderr;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

/* With complex deisgn of NHANES*/
proc sort data=two;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=two nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/* Stratifying differences in CAL/PD between buccal and lingual as well as mesial and distal by tooth type
	(anterior, premolar, and molar)*/

/*Anterior teeth*/
data anterior;
	/*used format for reordering of the variables*/
	format SEQN tooth diffcal_db_dl diffcal_midb_midl diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml
		   diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if tooth=6 or tooth=7 or tooth=8 or tooth=9 or tooth=10 or tooth=11 or tooth=22 or tooth=23 or tooth=24 or tooth=25
		or tooth=26 or tooth=27;
	keep SEQN tooth	diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml
		 diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc print data=anterior (obs=100);
	run;

proc means data=anterior n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=anterior;by SEQN;run;

proc surveymeans data=anterior nmiss mean stderr;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=anterior;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=anterior nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/*Premolars*/
data premolars;
	/*used format for reordering of the variables*/
	format SEQN tooth diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml
		   diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if tooth=4 or tooth=5 or tooth=12 or tooth=13 or tooth=20 or tooth=21 or tooth=28 or tooth=29;
	keep SEQN tooth	diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml
		 diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc print data=premolars (obs=100);
	run;

proc means data=premolars n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=premolars;by SEQN;run;

proc surveymeans data=premolars nmiss mean stderr std;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=premolars;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=premolars nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/*Molars*/
data molars;
	/*used format for reordering of the variables*/
	format SEQN tooth diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml
		   diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if tooth=2 or tooth=3 or tooth=14 or tooth=15 or tooth=18 or tooth=19 or tooth=30 or tooth=31;
	keep SEQN tooth	diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml
		 diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc print data=molars (obs=100);
	run;

proc means data=molars n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=molars;by SEQN;run;

proc surveymeans data=molars nmiss mean stderr std;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=molars;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=molars nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/* Stratifying differences in CAL/PD between buccal and lingual as well as mesial and distal by CDC/AAP definition
	(no perio, mild, moderate, and severe)*/

/*No periodontitis*/
data cdcno;
	/*used format for reordering of the variables*/
	format SEQN tooth periostatus diffcal_db_dl diffcal_midb_midl diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		   diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if periostatus=0;
	keep SEQN tooth	periostatus diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		 diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml SDMVSTRA SDMVPSU WTMEC6YR;
	run;

proc print data=cdcno (obs=100);
	run;

proc means data=cdcno n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=cdcno;by SEQN;run;

proc surveymeans data=cdcno nmiss mean stderr ;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=cdcno;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=cdcno nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/*Mild*/
data cdcmild;
	/*used format for reordering of the variables*/
	format SEQN tooth periostatus diffcal_db_dl diffcal_midb_midl diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		   diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if periostatus=1;
	keep SEQN tooth	periostatus diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		 diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml SDMVSTRA SDMVPSU WTMEC6YR;
	run;

proc print data=cdcmild (obs=100);
	run;

proc means data=cdcmild n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=cdcmild;by SEQN;run;

proc surveymeans data=cdcmild nmiss mean stderr std;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=cdcmild;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=cdcmild nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/*Moderate*/
data cdcmod;
	/*used format for reordering of the variables*/
	format SEQN tooth periostatus diffcal_db_dl diffcal_midb_midl diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		   diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if periostatus=2;
	keep SEQN tooth	periostatus diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		 diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc print data=cdcmod (obs=100);
	run;

proc means data=cdcmod n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=cdcmod;by SEQN;run;

proc surveymeans data=cdcmod nmiss mean stderr std;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=cdcmod;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=cdcmod nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/*Severe*/
data cdcsev;
	/*used format for reordering of the variables*/
	format SEQN tooth periostatus diffcal_db_dl diffcal_midb_midl diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		   diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if periostatus=3;
	keep SEQN tooth	periostatus diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		 diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc print data=cdcsev (obs=100);
	run;

proc means data=cdcsev n nmiss mean std stderr;
		var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
		 run;

/* Accounting for clustering of teeth*/
proc sort data=cdcsev;by SEQN;run;

proc surveymeans data=cdcsev nmiss mean stderr std;
	cluster SEQN;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

proc sort data=cdcsev;
	by SDMVSTRA SDMVPSU;
	run;

proc surveymeans data=cdcsev nmiss mean stderr;
	strata SDMVSTRA;
	cluster SDMVPSU;
	var diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl diffpd_mb_ml diffcal_db_mb
		 diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	weight WTMEC6YR;
	run;

/*Note: The total number of teeth in the CDC/AAP periodontitis (244,999) do not match the total number of permanent
teeth present (245,248)*/
/*I will check the number of permanent teeth among those who had missing CDC/AAP perio to make sure the numbers ass up*/
/*There should be 249 permanent teeth among those who had missing CDC/AAP periodontitis*/
data cdcmiss;
	/*used format for reordering of the variables*/
	format SEQN tooth periostatus diffcal_db_dl diffcal_midb_midl diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		   diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	set two;
	if periostatus=.;
	keep SEQN tooth	periostatus diffcal_db_dl diffcal_midb_midl	diffcal_mb_ml diffpd_db_dl diffpd_midb_midl
		 diffpd_mb_ml diffcal_db_mb diffcal_dl_ml diffpd_db_mb diffpd_dl_ml;
	run;

/*************************************************************************************************************/
/* Code Section 5 - Reprodcuing Table 2. Comparisons of average severity of clinical measures (mm) and teeth
by oral quadrant*/ 
/*************************************************************************************************************/

/*This is on tooth level instead of individual level for CAL and PD (same as Brenda's paper)*/
/*Added on 2/4/2021*/
data all;
	set one;
	if periostatus ne .;

	array lad (28)  	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
						ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;

	array las (28) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
						ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;

	array lap (28) 		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
						ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;

	array laa (28)		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
						ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;

	array pcd (28)  	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
						ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;

	array pcs (28) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs
						ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;

	array pcp (28) 		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp
						ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;

	array pca (28) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca
						ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
		
	array tooth	(28)	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
						OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
						OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC
						OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;

	/*Converting the dataset from indivudal level to teeth level by having 28 rows per individual
	and then outputting the calculated CAL/PD mean of four interproximal sites per tooth to each row*/
	do i=1 to 28;
	meanintcal=mean(of lad(i), las(i), lap(i), laa(i));
	meanintpd=mean(of pcd(i), pcs(i), pcp(i), pca(i));
	if tooth(i)=2 then perm=1; else perm=0;
	if tooth(i)=2 or tooth(i)=5 then perm_root=1; else perm_root=0;
	toothstat=tooth(i);
	output;
	end;
	label meanintcal='Mean clinical attachment loss of 4 interproximal sites per tooth';
	label meanintpd='Mean probing depth of 4 interproximal sites per tooth';
	label perm='Permenent tooth status';
	label perm_root='Permenent tooth or permanent tooth fragment status';
	label toothstat='Tooth status';
	format perm perm_root yesnoc.;
	run;

/*Note: the total number of participants included was 10,700 and after converting the dataset we got 299,600
(10,700*28 teeth) which makes sense*/

/*Renaming the rows to each tooth*/
data all2;
	set all;
	if i=1 then tooth=2;
	if i=2 then tooth=3;
	if i=3 then tooth=4;
	if i=4 then tooth=5;
	if i=5 then tooth=6;
	if i=6 then tooth=7;
	if i=7 then tooth=8;
	if i=8 then tooth=9;
	if i=9 then tooth=10;
	if i=10 then tooth=11;
	if i=11 then tooth=12;
	if i=12 then tooth=13;
	if i=13 then tooth=14;
	if i=14 then tooth=15;
	if i=15 then tooth=18;
	if i=16 then tooth=19;
	if i=17 then tooth=20;
	if i=18 then tooth=21;
	if i=19 then tooth=22;
	if i=20 then tooth=23;
	if i=21 then tooth=24;
	if i=22 then tooth=25;
	if i=23 then tooth=26;
	if i=24 then tooth=27;
	if i=25 then tooth=28;
	if i=26 then tooth=29;
	if i=27 then tooth=30;
	if i=28 then tooth=31;
	drop i;
	run;

/*Checking if outputted mean CAL (meanintcal) and mean PD (meanintpd) of each tooth to each row was correct*/
proc print data=all2 (obs=100);
var SEQN tooth toothstat meanintcal
	meanintcal02	meanintcal03	meanintcal04	meanintcal05	meanintcal06	meanintcal07	meanintcal08
	meanintcal09	meanintcal10	meanintcal11	meanintcal12	meanintcal13	meanintcal14	meanintcal15
	meanintcal18	meanintcal19	meanintcal20	meanintcal21	meanintcal22	meanintcal23	meanintcal24
	meanintcal25	meanintcal26	meanintcal27	meanintcal28	meanintcal29	meanintcal30	meanintcal31;
	run;

proc print data=all2 (obs=100);
var SEQN tooth toothstat meanintpd
	meanintpd02	meanintpd03	meanintpd04	meanintpd05	meanintpd06	meanintpd07	meanintpd08
	meanintpd09	meanintpd10	meanintpd11	meanintpd12	meanintpd13	meanintpd14	meanintpd15
	meanintpd18	meanintpd19	meanintpd20	meanintpd21	meanintpd22	meanintpd23	meanintpd24
	meanintpd25	meanintpd26	meanintpd27	meanintpd28	meanintpd29	meanintpd30	meanintpd31;
	run;

/*Checking if outputted
	tooth status (toothstat)
	permanent tooth presence (perm)
	permanent tooth or permanent root fragment (perm_root)
	of each tooth to each row were correct*/
proc print data=all2 (obs=100);
var SEQN tooth toothstat perm perm_root	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
										OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
										OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC
										OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;
										run;

/*Checking how many teeth were permanent root fragments*/
/*Note : a total of 4,258 teeth were permanent root fragments*/ 
proc print data=all2;
where toothstat=5;
var SEQN tooth toothstat meanintcal meanintpd;
run;

/*Cehcking how many permanent teeth were missing CAL*/
proc print data=all2;
where toothstat=2 and meanintcal=.;
var SEQN tooth toothstat meanintcal meanintpd;
run; 

proc print data=all2;
where SEQN=51653;
var SEQN tooth toothstat meanintcal meanintpd;;
run;

/*Note: a total of 329 teeth had measurements on mean CAL or mean PD and these were excluded from the analysis
on Comparisons of average severity of clinical measures (mm) and teeth by oral quadrant (Table 2) and 
Tooth level absolute comparisons of clinical measurement sites (mm) by tooth type and disease status (Table 1)*/
proc print data=all2;
where toothstat=5 and (meanintcal ne . or meanintpd ne .);
var SEQN tooth toothstat meanintcal meanintpd;
run;

/*Restricting to permanent teeth only*/
/*2/5/2021*/
/*Note: a total of 245,248 teeth were permanent teeth*/
data all2;
	set all2;
	if perm=1;
	run;

/*Calculating mean of mean CAL or PD of all teeth while accounting for clustering of teeth within individuals*/ 
proc sort data=all2;
	by SEQN;
	run;

proc surveymeans data=all2;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Upper right qudarant*/
data UR;
	set all2;
	if tooth ge 2 and tooth le 8;
	run;

proc print data=UR (obs=100);
var SEQN tooth OHX02TC ohx02lad ohx02las ohx02lap ohx02laa ohx02pcd ohx02pcs ohx02pcp ohx02pca meanintcal meanintpd;
run;

proc print data=UR (obs=100); 
var SEQN tooth;
run;

proc means data=UR n nmiss;
var meanintcal meanintpd;
run;

proc sort data=UR;
	by SEQN;
	run;

/*Calculating mean of mean CAL or PD of all teeth while accounting for clustering of teeth within individuals*/ 
proc surveymeans data=UR;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Anteriors*/
proc surveymeans data=UR;
where tooth=6 or tooth=7 or tooth=8;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Premolars*/
proc surveymeans data=UR;
where tooth=4 or tooth=5;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Molars*/
proc surveymeans data=UR;
where tooth=2 or tooth=3;
cluster SEQN;
var meanintcal meanintpd;
run;


/*Upper left qudarant*/
data UL;
	set all2;
	if tooth ge 9 and tooth le 15;
	run;

proc print data=UL (obs=100); 
var SEQN tooth;
run;

proc means data=UL n nmiss;
var meanintcal meanintpd;
run;

proc sort data=UL;
	by SEQN;
	run;

/*Calculating mean of mean CAL or PD of all teeth while accounting for clustering of teeth within individuals*/ 
proc surveymeans data=UL;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Anteriors*/
proc surveymeans data=UL;
where tooth=9 or tooth=10 or tooth=11;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Premolars*/
proc surveymeans data=UL;
where tooth=12 or tooth=13;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Molars*/
proc surveymeans data=UL;
where tooth=14 or tooth=15;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Lower left qudarant*/
data LL;
	set all2;
	if tooth ge 18 and tooth le 24;
	run;

proc print data=LL (obs=100); 
var SEQN tooth;
run;

proc means data=LL n nmiss;
var meanintcal meanintpd;
run;

proc sort data=LL;
	by SEQN;
	run;

/*Calculating mean of mean CAL or PD of all teeth while accounting for clustering of teeth within individuals*/ 
proc surveymeans data=LL;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Anteriors*/
proc surveymeans data=LL;
where tooth=22 or tooth=23 or tooth=24;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Premolars*/
proc surveymeans data=LL;
where tooth=20 or tooth=21;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Molars*/
proc surveymeans data=LL;
where tooth=18 or tooth=19;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Lower right qudarant*/
data LR;
	set all2;
	if tooth ge 25 and tooth le 31;
	run;

proc print data=LR (obs=100); 
var SEQN tooth;
run;

proc means data=LR n nmiss;
var meanintcal meanintpd;
run;

proc sort data=LR;
	by SEQN;
	run;

/*Calculating mean of mean CAL or PD of all teeth while accounting for clustering of teeth within individuals*/ 
proc surveymeans data=LR;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Anteriors*/
proc surveymeans data=LR;
where tooth=25 or tooth=26 or tooth=27;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Premolars*/
proc surveymeans data=LR;
where tooth=28 or tooth=29;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Molars*/
proc surveymeans data=LR;
where tooth=30 or tooth=31;
cluster SEQN;
var meanintcal meanintpd;
run;

/*Calculating mean number of teeth, mean number of teeth with CAL>= 6 mm, and mean number of teeth with PD>=5mm
in each quadrant*/
data nteeth;
	set one;
	if periostatus ne .;

	/*Upper right*/
	array toothUR	(7)		OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC;
	array laxUR 	(7) 	ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla;
	array pcxUR 	(7) 	ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc;

	/*Upper left*/
	array toothUL	(7)		OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC;
	array laxUL 	(7) 	ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla;
	array pcxUL 	(7) 	ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc;

	/*Lower left*/
	array toothLL	(7)		OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC;
	array laxLL 	(7) 	ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla;
	array pcxLL 	(7) 	ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc;

	/*Lower right*/
	array toothLR	(7)		OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;
	array laxLR 	(7) 	ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla;
	array pcxLR 	(7) 	ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc;

	toothcountUR=0;
	nteethipxla6mmUR=0;
	nteethipxpc5mmUR=0;
	toothcountUL=0;
	nteethipxla6mmUL=0;
	nteethipxpc5mmUL=0;
	toothcountLL=0;
	nteethipxla6mmLL=0;
	nteethipxpc5mmLL=0;
	toothcountLR=0;
	nteethipxla6mmLR=0;
	nteethipxpc5mmLR=0;
	do i=1 to 7; 
	if toothUR(i)=2 then toothcountUR=toothcountUR+1;
	if laxUR(i) ge 6 then nteethipxla6mmUR=nteethipxla6mmUR+1;
	if pcxUR(i) ge 5 then nteethipxpc5mmUR=nteethipxpc5mmUR+1;
	if toothUL(i)=2 then toothcountUL=toothcountUL+1;
	if laxUL(i) ge 6 then nteethipxla6mmUL=nteethipxla6mmUL+1;
	if pcxUL(i) ge 5 then nteethipxpc5mmUL=nteethipxpc5mmUL+1;
	if toothLL(i)=2 then toothcountLL=toothcountLL+1;
	if laxLL(i) ge 6 then nteethipxla6mmLL=nteethipxla6mmLL+1;
	if pcxLL(i) ge 5 then nteethipxpc5mmLL=nteethipxpc5mmLL+1;
	if toothLR(i)=2 then toothcountLR=toothcountLR+1;
	if laxLR(i) ge 6 then nteethipxla6mmLR=nteethipxla6mmLR+1;
	if pcxLR(i) ge 5 then nteethipxpc5mmLR=nteethipxpc5mmLR+1;
	end;
	run;

/*Checking if mean number of teeth with CAL>= 6 mm and mean number of teeth with PD>=5mm in each quadrant
were correctly done*/
proc print data=nteeth (obs=100);
var SEQN	ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla nteethipxla6mmUR
			ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc nteethipxpc5mmUR
			ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla nteethipxla6mmUL
			ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc nteethipxpc5mmUL
			ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla nteethipxla6mmLL
			ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc nteethipxpc5mmLL
			ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla nteethipxla6mmLR
			ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc nteethipxpc5mmLR
			OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC toothcountUR
			OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC toothcountUL
			OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC toothcountLL
			OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC toothcountLR;
			run;

proc means data=nteeth n nmiss mean stderr;
var toothcountUR nteethipxla6mmUR nteethipxpc5mmUR
	toothcountUL nteethipxla6mmUL nteethipxpc5mmUL
	toothcountLL nteethipxla6mmLL nteethipxpc5mmLL
	toothcountLR nteethipxla6mmLR nteethipxpc5mmLR;
	run;

/***************************************************************************************************************/
/* Code Section 6 - Reproducing Figure S1. Sensitivity estimates for identification of severe periodontitis
cases according to clinical sites measured and teeth evaluated*/ 
/***************************************************************************************************************/

/*According to clinical sites measured and teeth evaluated with only interproximal sites in partial-mouth*/

/*Upper right quadrant*/
data URsens;
	set one;
	
	/*Mesiobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethURmb (7) 	ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las;
	array pdURmb (7) 	ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs;

	nteethipxla6mmURmb=0;
	nteethipxpc5mmURmb=0;
	do count=1 to 7; 
	if teethURmb (count) ge 6 then nteethipxla6mmURmb=nteethipxla6mmURmb+1;
	if pdURmb(count) ge 5 then nteethipxpc5mmURmb=nteethipxpc5mmURmb+1;
	end; 
	if nteethipxla6mmURmb>=2 AND nteethipxpc5mmURmb>=1 then periostatusURmb=3;

	if 	ohx02las=. and
		ohx03las=. and 
		ohx04las=. and 
		ohx05las=. and
		ohx06las=. and
		ohx07las=. and 
		ohx08las=. then do; periostatusURmb=.; end;

	/*Mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethURml (7) 	ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa;
	array pdURml (7) 	ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca;

	nteethipxla6mmURml=0;
	nteethipxpc5mmURml=0;
	do count=1 to 7; 
	if teethURml (count) ge 6 then nteethipxla6mmURml=nteethipxla6mmURml+1;
	if pdURml(count) ge 5 then nteethipxpc5mmURml=nteethipxpc5mmURml+1;
	end; 
	if nteethipxla6mmURml>=2 AND nteethipxpc5mmURml>=1 then periostatusURml=3;

	if 	ohx02laa=. and
		ohx03laa=. and 
		ohx04laa=. and 
		ohx05laa=. and
		ohx06laa=. and
		ohx07laa=. and 
		ohx08laa=. then do; periostatusURml=.; end;

	/*Distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethURdb (7) 	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad;
	array pdURdb (7) 	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd;

	nteethipxla6mmURdb=0;
	nteethipxpc5mmURdb=0;
	do count=1 to 7; 
	if teethURdb (count) ge 6 then nteethipxla6mmURdb=nteethipxla6mmURdb+1;
	if pdURdb(count) ge 5 then nteethipxpc5mmURdb=nteethipxpc5mmURdb+1;
	end; 
	if nteethipxla6mmURdb>=2 AND nteethipxpc5mmURdb>=1 then periostatusURdb=3;

	if 	ohx02lad=. and
		ohx03lad=. and 
		ohx04lad=. and 
		ohx05lad=. and
		ohx06lad=. and
		ohx07lad=. and 
		ohx08lad=. then do; periostatusURdb=.; end;

	/*Distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethURdl (7) 	ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap;
	array pdURdl (7) 	ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp;

	nteethipxla6mmURdl=0;
	nteethipxpc5mmURdl=0;
	do count=1 to 7; 
	if teethURdl (count) ge 6 then nteethipxla6mmURdl=nteethipxla6mmURdl+1;
	if pdURdl(count) ge 5 then nteethipxpc5mmURdl=nteethipxpc5mmURdl+1;
	end; 
	if nteethipxla6mmURdl>=2 AND nteethipxpc5mmURdl>=1 then periostatusURdl=3;

	if 	ohx02lap=. and
		ohx03lap=. and 
		ohx04lap=. and 
		ohx05lap=. and
		ohx06lap=. and
		ohx07lap=. and 
		ohx08lap=. then do; periostatusURdl=.; end;

	/*Mesiobuccal and mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasURmbml (7) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las;
	array laaURmbml (7)		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa;
	array laxURmbml (7) ohx02maxlaURmbml ohx03maxlaURmbml ohx04maxlaURmbml ohx05maxlaURmbml ohx06maxlaURmbml
						ohx07maxlaURmbml ohx08maxlaURmbml;

	array pcsURmbml (7) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs;
	array pcaURmbml (7)		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca;
	array pcxURmbml (7) ohx02maxpcURmbml ohx03maxpcURmbml ohx04maxpcURmbml ohx05maxpcURmbml ohx06maxpcURmbml
						ohx07maxpcURmbml ohx08maxpcURmbml;

	do count=1 to 7; laxURmbml(count)=max(of lasURmbml(count),laaURmbml(count));
	pcxURmbml(count)=max(of pcsURmbml(count),pcaURmbml(count));
	end;
	drop count;

	nteethipxla6mmURmbml=0;
	nteethipxpc5mmURmbml=0;
	do count=1 to 7; 
	if laxURmbml(count) ge 6 then nteethipxla6mmURmbml=nteethipxla6mmURmbml+1;
	if pcxURmbml(count) ge 5 then nteethipxpc5mmURmbml=nteethipxpc5mmURmbml+1;
	end; 
	if nteethipxla6mmURmbml>=2 AND nteethipxpc5mmURmbml>=1 then periostatusURmbml=3;

	if 	ohx02las=. and
		ohx03las=. and 
		ohx04las=. and 
		ohx05las=. and
		ohx06las=. and
		ohx07las=. and 
		ohx08las=. and
		ohx02laa=. and
		ohx03laa=. and 
		ohx04laa=. and 
		ohx05laa=. and
		ohx06laa=. and
		ohx07laa=. and 
		ohx08laa=. then do; periostatusURmbml=.; end;

	/*Distobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array ladURdbdl (7) 		ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad;
	array lapURdbdl (7)		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap;
	array laxURdbdl (7) ohx02maxlaURdbdl ohx03maxlaURdbdl ohx04maxlaURdbdl ohx05maxlaURdbdl ohx06maxlaURdbdl
						ohx07maxlaURdbdl ohx08maxlaURdbdl;

	array pcdURdbdl (7) 		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd;
	array pcpURdbdl (7)		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp;
	array pcxURdbdl (7) ohx02maxpcURdbdl ohx03maxpcURdbdl ohx04maxpcURdbdl ohx05maxpcURdbdl ohx06maxpcURdbdl
						ohx07maxpcURdbdl ohx08maxpcURdbdl;

	do count=1 to 7; laxURdbdl(count)=max(of ladURdbdl(count),lapURdbdl(count));
	pcxURdbdl(count)=max(of pcdURdbdl(count),pcpURdbdl(count));
	end;
	drop count;

	nteethipxla6mmURdbdl=0;
	nteethipxpc5mmURdbdl=0;
	do count=1 to 7; 
	if laxURdbdl(count) ge 6 then nteethipxla6mmURdbdl=nteethipxla6mmURdbdl+1;
	if pcxURdbdl(count) ge 5 then nteethipxpc5mmURdbdl=nteethipxpc5mmURdbdl+1;
	end; 
	if nteethipxla6mmURdbdl>=2 AND nteethipxpc5mmURdbdl>=1 then periostatusURdbdl=3;

	if 	ohx02lad=. and
		ohx03lad=. and 
		ohx04lad=. and 
		ohx05lad=. and
		ohx06lad=. and
		ohx07lad=. and 
		ohx08lad=. and
		ohx02lap=. and
		ohx03lap=. and 
		ohx04lap=. and 
		ohx05lap=. and
		ohx06lap=. and
		ohx07lap=. and 
		ohx08lap=. then do; periostatusURdbdl=.; end;

	/*Mesiobuccal and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasURmbdb (7) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las;
	array ladURmbdb (7)		ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad;
	array laxURmbdb (7) ohx02maxlaURmbdb ohx03maxlaURmbdb ohx04maxlaURmbdb ohx05maxlaURmbdb ohx06maxlaURmbdb
						ohx07maxlaURmbdb ohx08maxlaURmbdb;

	array pcsURmbdb (7) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs;
	array pcdURmbdb (7)		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd;
	array pcxURmbdb (7) ohx02maxpcURmbdb ohx03maxpcURmbdb ohx04maxpcURmbdb ohx05maxpcURmbdb ohx06maxpcURmbdb
						ohx07maxpcURmbdb ohx08maxpcURmbdb;

	do count=1 to 7; laxURmbdb(count)=max(of ladURmbdb(count),lasURmbdb(count));
	pcxURmbdb(count)=max(of pcsURmbdb(count),pcdURmbdb(count));
	end;
	drop count;

	nteethipxla6mmURmbdb=0;
	nteethipxpc5mmURmbdb=0;
	do count=1 to 7; 
	if laxURmbdb(count) ge 6 then nteethipxla6mmURmbdb=nteethipxla6mmURmbdb+1;
	if pcxURmbdb(count) ge 5 then nteethipxpc5mmURmbdb=nteethipxpc5mmURmbdb+1;
	end; 
	if nteethipxla6mmURmbdb>=2 AND nteethipxpc5mmURmbdb>=1 then periostatusURmbdb=3;

	if 	ohx02las=. and
		ohx03las=. and 
		ohx04las=. and 
		ohx05las=. and
		ohx06las=. and
		ohx07las=. and 
		ohx08las=. and
		ohx02lad=. and
		ohx03lad=. and 
		ohx04lad=. and 
		ohx05lad=. and
		ohx06lad=. and
		ohx07lad=. and 
		ohx08lad=. then do; periostatusURmbdb=.; end;

	/*Mesiolingual and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaURmldl (7) 		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa;
	array lapURmldl (7)		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap;
	array laxURmldl (7) ohx02maxlaURmldl ohx03maxlaURmldl ohx04maxlaURmldl ohx05maxlaURmldl ohx06maxlaURmldl
						ohx07maxlaURmldl ohx08maxlaURmldl;

	array pcaURmldl (7) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca;
	array pcpURmldl (7)		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp;
	array pcxURmldl (7) ohx02maxpcURmldl ohx03maxpcURmldl ohx04maxpcURmldl ohx05maxpcURmldl ohx06maxpcURmldl
						ohx07maxpcURmldl ohx08maxpcURmldl;

	do count=1 to 7; laxURmldl(count)=max(of laaURmldl(count),lapURmldl(count));
	pcxURmldl(count)=max(of pcaURmldl(count),pcpURmldl(count));
	end;
	drop count;

	nteethipxla6mmURmldl=0;
	nteethipxpc5mmURmldl=0;
	do count=1 to 7; 
	if laxURmldl(count) ge 6 then nteethipxla6mmURmldl=nteethipxla6mmURmldl+1;
	if pcxURmldl(count) ge 5 then nteethipxpc5mmURmldl=nteethipxpc5mmURmldl+1;
	end; 
	if nteethipxla6mmURmldl>=2 AND nteethipxpc5mmURmldl>=1 then periostatusURmldl=3;

	if 	ohx02laa=. and
		ohx03laa=. and 
		ohx04laa=. and 
		ohx05laa=. and
		ohx06laa=. and
		ohx07laa=. and 
		ohx08laa=. and
		ohx02lap=. and
		ohx03lap=. and 
		ohx04lap=. and 
		ohx05lap=. and
		ohx06lap=. and
		ohx07lap=. and 
		ohx08lap=. then do; periostatusURmldl=.; end;

	/*Mesiobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasURmbdl (7) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las;
	array lapURmbdl (7)		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap;
	array laxURmbdl (7) ohx02maxlaURmbdl ohx03maxlaURmbdl ohx04maxlaURmbdl ohx05maxlaURmbdl ohx06maxlaURmbdl
						ohx07maxlaURmbdl ohx08maxlaURmbdl;

	array pcsURmbdl (7) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs;
	array pcpURmbdl (7)		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp;
	array pcxURmbdl (7) ohx02maxpcURmbdl ohx03maxpcURmbdl ohx04maxpcURmbdl ohx05maxpcURmbdl ohx06maxpcURmbdl
						ohx07maxpcURmbdl ohx08maxpcURmbdl;

	do count=1 to 7; laxURmbdl(count)=max(of lasURmbdl(count),lapURmbdl(count));
	pcxURmbdl(count)=max(of pcsURmbdl(count),pcpURmbdl(count));
	end;
	drop count;

	nteethipxla6mmURmbdl=0;
	nteethipxpc5mmURmbdl=0;
	do count=1 to 7; 
	if laxURmbdl(count) ge 6 then nteethipxla6mmURmbdl=nteethipxla6mmURmbdl+1;
	if pcxURmbdl(count) ge 5 then nteethipxpc5mmURmbdl=nteethipxpc5mmURmbdl+1;
	end; 
	if nteethipxla6mmURmbdl>=2 AND nteethipxpc5mmURmbdl>=1 then periostatusURmbdl=3;

	if 	ohx02las=. and
		ohx03las=. and 
		ohx04las=. and 
		ohx05las=. and
		ohx06las=. and
		ohx07las=. and 
		ohx08las=. and
		ohx02lap=. and
		ohx03lap=. and 
		ohx04lap=. and 
		ohx05lap=. and
		ohx06lap=. and
		ohx07lap=. and 
		ohx08lap=. then do; periostatusURmbdl=.; end;

	/*Mesiolingual and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaURmldb (7) 		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa;
	array ladURmldb (7)		ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad;
	array laxURmldb (7) ohx02maxlaURmldb ohx03maxlaURmldb ohx04maxlaURmldb ohx05maxlaURmldb ohx06maxlaURmldb
						ohx07maxlaURmldb ohx08maxlaURmldb;

	array pcaURmldb (7) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca;
	array pcdURmldb (7)		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd;
	array pcxURmldb (7) ohx02maxpcURmldb ohx03maxpcURmldb ohx04maxpcURmldb ohx05maxpcURmldb ohx06maxpcURmldb
						ohx07maxpcURmldb ohx08maxpcURmldb;

	do count=1 to 7; laxURmldb(count)=max(of laaURmldb(count),ladURmldb(count));
	pcxURmldb(count)=max(of pcaURmldb(count),pcdURmldb(count));
	end;
	drop count;

	nteethipxla6mmURmldb=0;
	nteethipxpc5mmURmldb=0;
	do count=1 to 7; 
	if laxURmldb(count) ge 6 then nteethipxla6mmURmldb=nteethipxla6mmURmldb+1;
	if pcxURmldb(count) ge 5 then nteethipxpc5mmURmldb=nteethipxpc5mmURmldb+1;
	end; 
	if nteethipxla6mmURmldb>=2 AND nteethipxpc5mmURmldb>=1 then periostatusURmldb=3;

	if 	ohx02laa=. and
		ohx03laa=. and 
		ohx04laa=. and 
		ohx05laa=. and
		ohx06laa=. and
		ohx07laa=. and 
		ohx08laa=. and
		ohx02lad=. and
		ohx03lad=. and 
		ohx04lad=. and 
		ohx05lad=. and
		ohx06lad=. and
		ohx07lad=. and 
		ohx08lad=. then do; periostatusURmldb=.; end;

	/*All interproximal sites*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasURall (7) 		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las;
	array laaURall (7)		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa;
	array ladURall (7) 		ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad;
	array lapURall (7)		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap;
	array laxURall (7) 		ohx02maxlaURall ohx03maxlaURall ohx04maxlaURall ohx05maxlaURall ohx06maxlaURall
							ohx07maxlaURall ohx08maxlaURall;

	array pcsURall (7) 		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs;
	array pcaURall (7)		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca;
	array pcdURall (7) 		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd;
	array pcpURall (7)		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp;
	array pcxURall (7) 		ohx02maxpcURall ohx03maxpcURall ohx04maxpcURall ohx05maxpcURall ohx06maxpcURall
							ohx07maxpcURall ohx08maxpcURall;

	do count=1 to 7; laxURall(count)=max(of lasURall(count),laaURall(count), ladURall(count), lapURall(count));
	pcxURall(count)=max(of pcsURall(count),pcaURall(count), pcdURall(count), pcpURall(count));
	end;
	drop count;

	nteethipxla6mmURall=0;
	nteethipxpc5mmURall=0;
	do count=1 to 7; 
	if laxURall(count) ge 6 then nteethipxla6mmURall=nteethipxla6mmURall+1;
	if pcxURall(count) ge 5 then nteethipxpc5mmURall=nteethipxpc5mmURall+1;
	end; 
	if nteethipxla6mmURall>=2 AND nteethipxpc5mmURall>=1 then periostatusURall=3;

	if 	ohx02las=. and
		ohx03las=. and 
		ohx04las=. and 
		ohx05las=. and
		ohx06las=. and
		ohx07las=. and 
		ohx08las=. and
		ohx02laa=. and
		ohx03laa=. and 
		ohx04laa=. and 
		ohx05laa=. and
		ohx06laa=. and
		ohx07laa=. and 
		ohx08laa=. and
		ohx02lad=. and
		ohx03lad=. and 
		ohx04lad=. and 
		ohx05lad=. and
		ohx06lad=. and
		ohx07lad=. and 
		ohx08lad=. and
		ohx02lap=. and
		ohx03lap=. and 
		ohx04lap=. and 
		ohx05lap=. and
		ohx06lap=. and
		ohx07lap=. and 
		ohx08lap=. then do; periostatusURall=.; end;
	run;

/*Checking if severe perio was correctly coded using different interproximal sites*/
/*Mesiobuccal*/
proc print data=URsens (obs=100);
where periostatusURmb=.;
var SEQN	ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las nteethipxla6mmURmb
			ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs nteethipxpc5mmURmb
			periostatusURmb;
			run;

/*Mesiolingual*/
proc print data=URsens (obs=200);
var SEQN	ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa nteethipxla6mmURml
			ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca nteethipxpc5mmURml
			periostatusURml;
			run;

/*Distobuccal*/
proc print data=URsens (obs=100);
var SEQN	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad nteethipxla6mmURdb
			ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd nteethipxpc5mmURdb
			periostatusURdb;
			run;

/*Distolingual*/
proc print data=URsens (obs=100);
var SEQN	ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap nteethipxla6mmURdl
			ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp nteethipxpc5mmURdl
			periostatusURdl;
			run;

/*Mesiobuccal and mesiolingual*/
proc print data=URsens (obs=100);
var SEQN	ohx02las ohx02laa ohx02maxlaURmbml 
			ohx03las ohx03laa ohx03maxlaURmbml
			ohx04las ohx04laa ohx04maxlaURmbml
			ohx05las ohx05laa ohx05maxlaURmbml
			ohx06las ohx06laa ohx06maxlaURmbml
			ohx07las ohx07laa ohx07maxlaURmbml 
			ohx08las ohx08laa ohx08maxlaURmbml
			ohx02pcs ohx02pca ohx02maxpcURmbml 
			ohx03pcs ohx03pca ohx03maxpcURmbml
			ohx04pcs ohx04pca ohx04maxpcURmbml
			ohx05pcs ohx05pca ohx05maxpcURmbml
			ohx06pcs ohx06pca ohx06maxpcURmbml
			ohx07pcs ohx07pca ohx07maxpcURmbml 
			ohx08pcs ohx08pca ohx08maxpcURmbml;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURmbml ohx03maxlaURmbml ohx04maxlaURmbml ohx05maxlaURmbml ohx06maxlaURmbml
			ohx07maxlaURmbml ohx08maxlaURmbml nteethipxla6mmURmbml
			ohx02maxpcURmbml ohx03maxpcURmbml ohx04maxpcURmbml ohx05maxpcURmbml ohx06maxpcURmbml
			ohx07maxpcURmbml ohx08maxpcURmbml nteethipxpc5mmURmbml
			periostatusURmbml;
			run;

/*Distobuccal and distolingual*/
proc print data=URsens (obs=100);
var SEQN	ohx02lad ohx02lap ohx02maxlaURdbdl 
			ohx03lad ohx03lap ohx03maxlaURdbdl
			ohx04lad ohx04lap ohx04maxlaURdbdl
			ohx05lad ohx05lap ohx05maxlaURdbdl
			ohx06lad ohx06lap ohx06maxlaURdbdl
			ohx07lad ohx07lap ohx07maxlaURdbdl 
			ohx08lad ohx08lap ohx08maxlaURdbdl
			ohx02pcd ohx02pcp ohx02maxpcURdbdl 
			ohx03pcd ohx03pcp ohx03maxpcURdbdl
			ohx04pcd ohx04pcp ohx04maxpcURdbdl
			ohx05pcd ohx05pcp ohx05maxpcURdbdl
			ohx06pcd ohx06pcp ohx06maxpcURdbdl
			ohx07pcd ohx07pcp ohx07maxpcURdbdl 
			ohx08pcd ohx08pcp ohx08maxpcURdbdl;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURdbdl ohx03maxlaURdbdl ohx04maxlaURdbdl ohx05maxlaURdbdl ohx06maxlaURdbdl
			ohx07maxlaURdbdl ohx08maxlaURdbdl nteethipxla6mmURdbdl
			ohx02maxpcURdbdl ohx03maxpcURdbdl ohx04maxpcURdbdl ohx05maxpcURdbdl ohx06maxpcURdbdl
			ohx07maxpcURdbdl ohx08maxpcURdbdl nteethipxpc5mmURdbdl
			periostatusURdbdl;
			run;

/*Mesiobuccal and distobuccal*/
proc print data=URsens (obs=100);
var SEQN	ohx02las ohx02lad ohx02maxlaURmbdb 
			ohx03las ohx03lad ohx03maxlaURmbdb
			ohx04las ohx04lad ohx04maxlaURmbdb
			ohx05las ohx05lad ohx05maxlaURmbdb
			ohx06las ohx06lad ohx06maxlaURmbdb
			ohx07las ohx07lad ohx07maxlaURmbdb 
			ohx08las ohx08lad ohx08maxlaURmbdb
			ohx02pcs ohx02pcd ohx02maxpcURmbdb 
			ohx03pcs ohx03pcd ohx03maxpcURmbdb
			ohx04pcs ohx04pcd ohx04maxpcURmbdb
			ohx05pcs ohx05pcd ohx05maxpcURmbdb
			ohx06pcs ohx06pcd ohx06maxpcURmbdb
			ohx07pcs ohx07pcd ohx07maxpcURmbdb 
			ohx08pcs ohx08pcd ohx08maxpcURmbdb;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURmbdb ohx03maxlaURmbdb ohx04maxlaURmbdb ohx05maxlaURmbdb ohx06maxlaURmbdb
			ohx07maxlaURmbdb ohx08maxlaURmbdb nteethipxla6mmURmbdb
			ohx02maxpcURmbdb ohx03maxpcURmbdb ohx04maxpcURmbdb ohx05maxpcURmbdb ohx06maxpcURmbdb
			ohx07maxpcURmbdb ohx08maxpcURmbdb nteethipxpc5mmURmbdb
			periostatusURmbdb;
			run;

/*Mesiolingual and distolingual*/
proc print data=URsens (obs=100);
var SEQN	ohx02laa ohx02lap ohx02maxlaURmldl 
			ohx03laa ohx03lap ohx03maxlaURmldl
			ohx04laa ohx04lap ohx04maxlaURmldl
			ohx05laa ohx05lap ohx05maxlaURmldl
			ohx06laa ohx06lap ohx06maxlaURmldl
			ohx07laa ohx07lap ohx07maxlaURmldl 
			ohx08laa ohx08lap ohx08maxlaURmldl
			ohx02pca ohx02pcp ohx02maxpcURmldl 
			ohx03pca ohx03pcp ohx03maxpcURmldl
			ohx04pca ohx04pcp ohx04maxpcURmldl
			ohx05pca ohx05pcp ohx05maxpcURmldl
			ohx06pca ohx06pcp ohx06maxpcURmldl
			ohx07pca ohx07pcp ohx07maxpcURmldl 
			ohx08pca ohx08pcp ohx08maxpcURmldl;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURmldl ohx03maxlaURmldl ohx04maxlaURmldl ohx05maxlaURmldl ohx06maxlaURmldl
			ohx07maxlaURmldl ohx08maxlaURmldl nteethipxla6mmURmldl
			ohx02maxpcURmldl ohx03maxpcURmldl ohx04maxpcURmldl ohx05maxpcURmldl ohx06maxpcURmldl
			ohx07maxpcURmldl ohx08maxpcURmldl nteethipxpc5mmURmldl
			periostatusURmldl;
			run;

/*Mesiobuccal and distolingual*/
proc print data=URsens (obs=100);
var SEQN	ohx02las ohx02lap ohx02maxlaURmbdl 
			ohx03las ohx03lap ohx03maxlaURmbdl
			ohx04las ohx04lap ohx04maxlaURmbdl
			ohx05las ohx05lap ohx05maxlaURmbdl
			ohx06las ohx06lap ohx06maxlaURmbdl
			ohx07las ohx07lap ohx07maxlaURmbdl 
			ohx08las ohx08lap ohx08maxlaURmbdl
			ohx02pcs ohx02pcp ohx02maxpcURmbdl 
			ohx03pcs ohx03pcp ohx03maxpcURmbdl
			ohx04pcs ohx04pcp ohx04maxpcURmbdl
			ohx05pcs ohx05pcp ohx05maxpcURmbdl
			ohx06pcs ohx06pcp ohx06maxpcURmbdl
			ohx07pcs ohx07pcp ohx07maxpcURmbdl 
			ohx08pcs ohx08pcp ohx08maxpcURmbdl;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURmbdl ohx03maxlaURmbdl ohx04maxlaURmbdl ohx05maxlaURmbdl ohx06maxlaURmbdl
			ohx07maxlaURmbdl ohx08maxlaURmbdl nteethipxla6mmURmbdl
			ohx02maxpcURmbdl ohx03maxpcURmbdl ohx04maxpcURmbdl ohx05maxpcURmbdl ohx06maxpcURmbdl
			ohx07maxpcURmbdl ohx08maxpcURmbdl nteethipxpc5mmURmbdl
			periostatusURmbdl;
			run;

/*Mesiolingual and distobuccal*/
proc print data=URsens (obs=100);
var SEQN	ohx02laa ohx02lad ohx02maxlaURmldb 
			ohx03laa ohx03lad ohx03maxlaURmldb
			ohx04laa ohx04lad ohx04maxlaURmldb
			ohx05laa ohx05lad ohx05maxlaURmldb
			ohx06laa ohx06lad ohx06maxlaURmldb
			ohx07laa ohx07lad ohx07maxlaURmldb 
			ohx08laa ohx08lad ohx08maxlaURmldb
			ohx02pca ohx02pcd ohx02maxpcURmldb 
			ohx03pca ohx03pcd ohx03maxpcURmldb
			ohx04pca ohx04pcd ohx04maxpcURmldb
			ohx05pca ohx05pcd ohx05maxpcURmldb
			ohx06pca ohx06pcd ohx06maxpcURmldb
			ohx07pca ohx07pcd ohx07maxpcURmldb 
			ohx08pca ohx08pcd ohx08maxpcURmldb;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURmldb ohx03maxlaURmldb ohx04maxlaURmldb ohx05maxlaURmldb ohx06maxlaURmldb
			ohx07maxlaURmldb ohx08maxlaURmldb nteethipxla6mmURmldb
			ohx02maxpcURmldb ohx03maxpcURmldb ohx04maxpcURmldb ohx05maxpcURmldb ohx06maxpcURmldb
			ohx07maxpcURmldb ohx08maxpcURmldb nteethipxpc5mmURmldb
			periostatusURmldb;
			run;

/*All interproximal sites*/
proc print data=URsens (obs=100);
var SEQN	ohx02las ohx02laa ohx02lad ohx02lap ohx02maxlaURall 
			ohx03las ohx03laa ohx03lad ohx03lap ohx03maxlaURall
			ohx04las ohx04laa ohx04lad ohx04lap ohx04maxlaURall
			ohx05las ohx05laa ohx05lad ohx05lap ohx05maxlaURall
			ohx06las ohx06laa ohx06lad ohx06lap ohx06maxlaURall
			ohx07las ohx07laa ohx07lad ohx07lap ohx07maxlaURall 
			ohx08las ohx08laa ohx08lad ohx08lap ohx08maxlaURall
			ohx02pcs ohx02pca ohx02pcd ohx02pcp ohx02maxpcURall 
			ohx03pcs ohx03pca ohx03pcd ohx03pcp ohx03maxpcURall
			ohx04pcs ohx04pca ohx04pcd ohx04pcp ohx04maxpcURall
			ohx05pcs ohx05pca ohx05pcd ohx05pcp ohx05maxpcURall
			ohx06pcs ohx06pca ohx06pcd ohx06pcp ohx06maxpcURall
			ohx07pcs ohx07pca ohx07pcd ohx07pcp ohx07maxpcURall 
			ohx08pcs ohx08pca ohx08pcd ohx08pcp ohx08maxpcURall;
			run;

proc print data=URsens (obs=100);
var SEQN	ohx02maxlaURall ohx03maxlaURall ohx04maxlaURall ohx05maxlaURall ohx06maxlaURall
			ohx07maxlaURall ohx08maxlaURall nteethipxla6mmURall
			ohx02maxpcURall ohx03maxpcURall ohx04maxpcURall ohx05maxpcURall ohx06maxpcURall
			ohx07maxpcURall ohx08maxpcURall nteethipxpc5mmURall
			periostatusURall;
			run;
	
proc freq data=URsens;
tables periostatusURmb*periostatus/missing nopercent norow;
tables periostatusURml*periostatus/missing nopercent norow;
tables periostatusURdb*periostatus/missing nopercent norow;
tables periostatusURdl*periostatus/missing nopercent norow;
tables periostatusURmbml*periostatus/missing nopercent norow;
tables periostatusURdbdl*periostatus/missing nopercent norow;
tables periostatusURmbdb*periostatus/missing nopercent norow;
tables periostatusURmldl*periostatus/missing nopercent norow;
tables periostatusURmbdl*periostatus/missing nopercent norow;
tables periostatusURmldb*periostatus/missing nopercent norow;
tables periostatusURall*periostatus/missing nopercent norow;
run;

/*Saving the URsens as a permanent dataset to produce a figure*/
data part.URsens;
	set URsens;
	run;
	
/*Upper left quadrant*/
data ULsens;
	set one;
	
	/*Mesiobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethULmb (7) 	ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las;
	array pdULmb (7) 	ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs;

	nteethipxla6mmULmb=0;
	nteethipxpc5mmULmb=0;
	do count=1 to 7; 
	if teethULmb (count) ge 6 then nteethipxla6mmULmb=nteethipxla6mmULmb+1;
	if pdULmb(count) ge 5 then nteethipxpc5mmULmb=nteethipxpc5mmULmb+1;
	end; 
	if nteethipxla6mmULmb>=2 AND nteethipxpc5mmULmb>=1 then periostatusULmb=3;

	if 	ohx09las=. and
		ohx10las=. and 
		ohx11las=. and 
		ohx12las=. and
		ohx13las=. and
		ohx14las=. and 
		ohx15las=. then do; periostatusULmb=.; end;

	/*Mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethULml (7) 	ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa;
	array pdULml (7) 	ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca;

	nteethipxla6mmULml=0;
	nteethipxpc5mmULml=0;
	do count=1 to 7; 
	if teethULml (count) ge 6 then nteethipxla6mmULml=nteethipxla6mmULml+1;
	if pdULml(count) ge 5 then nteethipxpc5mmULml=nteethipxpc5mmULml+1;
	end; 
	if nteethipxla6mmULml>=2 AND nteethipxpc5mmULml>=1 then periostatusULml=3;

	if 	ohx09laa=. and
		ohx10laa=. and 
		ohx11laa=. and 
		ohx12laa=. and
		ohx13laa=. and
		ohx14laa=. and 
		ohx15laa=. then do; periostatusULml=.; end;

	/*Distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethULdb (7) 	ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad;
	array pdULdb (7) 	ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd;

	nteethipxla6mmULdb=0;
	nteethipxpc5mmULdb=0;
	do count=1 to 7; 
	if teethULdb (count) ge 6 then nteethipxla6mmULdb=nteethipxla6mmULdb+1;
	if pdULdb(count) ge 5 then nteethipxpc5mmULdb=nteethipxpc5mmULdb+1;
	end; 
	if nteethipxla6mmULdb>=2 AND nteethipxpc5mmULdb>=1 then periostatusULdb=3;

	if 	ohx09lad=. and
		ohx10lad=. and 
		ohx11lad=. and 
		ohx12lad=. and
		ohx13lad=. and
		ohx14lad=. and 
		ohx15lad=. then do; periostatusULdb=.; end;

	/*Distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethULdl (7) 	ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap;
	array pdULdl (7) 	ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp;

	nteethipxla6mmULdl=0;
	nteethipxpc5mmULdl=0;
	do count=1 to 7; 
	if teethULdl (count) ge 6 then nteethipxla6mmULdl=nteethipxla6mmULdl+1;
	if pdULdl(count) ge 5 then nteethipxpc5mmULdl=nteethipxpc5mmULdl+1;
	end; 
	if nteethipxla6mmULdl>=2 AND nteethipxpc5mmULdl>=1 then periostatusULdl=3;

	if 	ohx09lap=. and
		ohx10lap=. and 
		ohx11lap=. and 
		ohx12lap=. and
		ohx13lap=. and
		ohx14lap=. and 
		ohx15lap=. then do; periostatusULdl=.; end;

	/*Mesiobuccal and mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasULmbml (7) 		ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las;
	array laaULmbml (7)		ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa;
	array laxULmbml (7) ohx09maxlaULmbml ohx10maxlaULmbml ohx11maxlaULmbml ohx12maxlaULmbml ohx13maxlaULmbml
						ohx14maxlaULmbml ohx15maxlaULmbml;

	array pcsULmbml (7) 		ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs;
	array pcaULmbml (7)		ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca;
	array pcxULmbml (7) ohx09maxpcULmbml ohx10maxpcULmbml ohx11maxpcULmbml ohx12maxpcULmbml ohx13maxpcULmbml
						ohx14maxpcULmbml ohx15maxpcULmbml;

	do count=1 to 7; laxULmbml(count)=max(of lasULmbml(count),laaULmbml(count));
	pcxULmbml(count)=max(of pcsULmbml(count),pcaULmbml(count));
	end;
	drop count;

	nteethipxla6mmULmbml=0;
	nteethipxpc5mmULmbml=0;
	do count=1 to 7; 
	if laxULmbml (count) ge 6 then nteethipxla6mmULmbml=nteethipxla6mmULmbml+1;
	if pcxULmbml(count) ge 5 then nteethipxpc5mmULmbml=nteethipxpc5mmULmbml+1;
	end; 
	if nteethipxla6mmULmbml>=2 AND nteethipxpc5mmULmbml>=1 then periostatusULmbml=3;

	if 	ohx09las=. and
		ohx10las=. and 
		ohx11las=. and 
		ohx12las=. and
		ohx13las=. and
		ohx14las=. and 
		ohx15las=. and
		ohx09laa=. and
		ohx10laa=. and 
		ohx11laa=. and 
		ohx12laa=. and
		ohx13laa=. and
		ohx14laa=. and 
		ohx15laa=. then do; periostatusULmbml=.; end;

	/*Distobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array ladULdbdl (7) 		ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad;
	array lapULdbdl (7)		ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap;
	array laxULdbdl (7) ohx09maxlaULdbdl ohx10maxlaULdbdl ohx11maxlaULdbdl ohx12maxlaULdbdl ohx13maxlaULdbdl
						ohx14maxlaULdbdl ohx15maxlaULdbdl;

	array pcdULdbdl (7) 		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd;
	array pcpULdbdl (7)		ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp;
	array pcxULdbdl (7) ohx09maxpcULdbdl ohx10maxpcULdbdl ohx11maxpcULdbdl ohx12maxpcULdbdl ohx13maxpcULdbdl
						ohx14maxpcULdbdl ohx15maxpcULdbdl;

	do count=1 to 7; laxULdbdl(count)=max(of ladULdbdl(count),lapULdbdl(count));
	pcxULdbdl(count)=max(of pcdULdbdl(count),pcpULdbdl(count));
	end;
	drop count;

	nteethipxla6mmULdbdl=0;
	nteethipxpc5mmULdbdl=0;
	do count=1 to 7; 
	if laxULdbdl (count) ge 6 then nteethipxla6mmULdbdl=nteethipxla6mmULdbdl+1;
	if pcxULdbdl(count) ge 5 then nteethipxpc5mmULdbdl=nteethipxpc5mmULdbdl+1;
	end; 
	if nteethipxla6mmULdbdl>=2 AND nteethipxpc5mmULdbdl>=1 then periostatusULdbdl=3;

	if 	ohx09lad=. and
		ohx10lad=. and 
		ohx11lad=. and 
		ohx12lad=. and
		ohx13lad=. and
		ohx14lad=. and 
		ohx15lad=. and
		ohx09lap=. and
		ohx10lap=. and 
		ohx11lap=. and 
		ohx12lap=. and
		ohx13lap=. and
		ohx14lap=. and 
		ohx15lap=. then do; periostatusULdbdl=.; end;

	/*Mesiobuccal and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasULmbdb (7) 		ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las;
	array ladULmbdb (7)		ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad;
	array laxULmbdb (7) ohx09maxlaULmbdb ohx10maxlaULmbdb ohx11maxlaULmbdb ohx12maxlaULmbdb ohx13maxlaULmbdb
						ohx14maxlaULmbdb ohx15maxlaULmbdb;

	array pcsULmbdb (7) 		ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs;
	array pcdULmbdb (7)		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd;
	array pcxULmbdb (7) ohx09maxpcULmbdb ohx10maxpcULmbdb ohx11maxpcULmbdb ohx12maxpcULmbdb ohx13maxpcULmbdb
						ohx14maxpcULmbdb ohx15maxpcULmbdb;

	do count=1 to 7; laxULmbdb(count)=max(of ladULmbdb(count),lasULmbdb(count));
	pcxULmbdb(count)=max(of pcsULmbdb(count),pcdULmbdb(count));
	end;
	drop count;

	nteethipxla6mmULmbdb=0;
	nteethipxpc5mmULmbdb=0;
	do count=1 to 7; 
	if laxULmbdb (count) ge 6 then nteethipxla6mmULmbdb=nteethipxla6mmULmbdb+1;
	if pcxULmbdb(count) ge 5 then nteethipxpc5mmULmbdb=nteethipxpc5mmULmbdb+1;
	end; 
	if nteethipxla6mmULmbdb>=2 AND nteethipxpc5mmULmbdb>=1 then periostatusULmbdb=3;

	if 	ohx09las=. and
		ohx10las=. and 
		ohx11las=. and 
		ohx12las=. and
		ohx13las=. and
		ohx14las=. and 
		ohx15las=. and
		ohx09lad=. and
		ohx10lad=. and 
		ohx11lad=. and 
		ohx12lad=. and
		ohx13lad=. and
		ohx14lad=. and 
		ohx15lad=. then do; periostatusULmbdb=.; end;

	/*Mesiolingual and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaULmldl (7) 		ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa;
	array lapULmldl (7)		ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap;
	array laxULmldl (7) ohx09maxlaULmldl ohx10maxlaULmldl ohx11maxlaULmldl ohx12maxlaULmldl ohx13maxlaULmldl
						ohx14maxlaULmldl ohx15maxlaULmldl;

	array pcaULmldl (7) 		ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca;
	array pcpULmldl (7)		ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp;
	array pcxULmldl (7) ohx09maxpcULmldl ohx10maxpcULmldl ohx11maxpcULmldl ohx12maxpcULmldl ohx13maxpcULmldl
						ohx14maxpcULmldl ohx15maxpcULmldl;

	do count=1 to 7; laxULmldl(count)=max(of laaULmldl(count),lapULmldl(count));
	pcxULmldl(count)=max(of pcaULmldl(count),pcpULmldl(count));
	end;
	drop count;

	nteethipxla6mmULmldl=0;
	nteethipxpc5mmULmldl=0;
	do count=1 to 7; 
	if laxULmldl (count) ge 6 then nteethipxla6mmULmldl=nteethipxla6mmULmldl+1;
	if pcxULmldl(count) ge 5 then nteethipxpc5mmULmldl=nteethipxpc5mmULmldl+1;
	end; 
	if nteethipxla6mmULmldl>=2 AND nteethipxpc5mmULmldl>=1 then periostatusULmldl=3;

	if 	ohx09laa=. and
		ohx10laa=. and 
		ohx11laa=. and 
		ohx12laa=. and
		ohx13laa=. and
		ohx14laa=. and 
		ohx15laa=. and
		ohx09lap=. and
		ohx10lap=. and 
		ohx11lap=. and 
		ohx12lap=. and
		ohx13lap=. and
		ohx14lap=. and 
		ohx15lap=. then do; periostatusULmldl=.; end;

	/*Mesiobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasULmbdl (7) 		ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las;
	array lapULmbdl (7)		ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap;
	array laxULmbdl (7) ohx09maxlaULmbdl ohx10maxlaULmbdl ohx11maxlaULmbdl ohx12maxlaULmbdl ohx13maxlaULmbdl
						ohx14maxlaULmbdl ohx15maxlaULmbdl;

	array pcsULmbdl (7) 		ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs;
	array pcpULmbdl (7)		ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp;
	array pcxULmbdl (7) ohx09maxpcULmbdl ohx10maxpcULmbdl ohx11maxpcULmbdl ohx12maxpcULmbdl ohx13maxpcULmbdl
						ohx14maxpcULmbdl ohx15maxpcULmbdl;

	do count=1 to 7; laxULmbdl(count)=max(of lasULmbdl(count),lapULmbdl(count));
	pcxULmbdl(count)=max(of pcsULmbdl(count),pcpULmbdl(count));
	end;
	drop count;

	nteethipxla6mmULmbdl=0;
	nteethipxpc5mmULmbdl=0;
	do count=1 to 7; 
	if laxULmbdl (count) ge 6 then nteethipxla6mmULmbdl=nteethipxla6mmULmbdl+1;
	if pcxULmbdl(count) ge 5 then nteethipxpc5mmULmbdl=nteethipxpc5mmULmbdl+1;
	end; 
	if nteethipxla6mmULmbdl>=2 AND nteethipxpc5mmULmbdl>=1 then periostatusULmbdl=3;

	if 	ohx09las=. and
		ohx10las=. and 
		ohx11las=. and 
		ohx12las=. and
		ohx13las=. and
		ohx14las=. and 
		ohx15las=. and
		ohx09lap=. and
		ohx10lap=. and 
		ohx11lap=. and 
		ohx12lap=. and
		ohx13lap=. and
		ohx14lap=. and 
		ohx15lap=. then do; periostatusULmbdl=.; end;

	/*Mesiolingual and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaULmldb (7) 		ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa;
	array ladULmldb (7)		ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad;
	array laxULmldb (7) ohx09maxlaULmldb ohx10maxlaULmldb ohx11maxlaULmldb ohx12maxlaULmldb ohx13maxlaULmldb
						ohx14maxlaULmldb ohx15maxlaULmldb;

	array pcaULmldb (7) 		ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca;
	array pcdULmldb (7)		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd;
	array pcxULmldb (7) ohx09maxpcULmldb ohx10maxpcULmldb ohx11maxpcULmldb ohx12maxpcULmldb ohx13maxpcULmldb
						ohx14maxpcULmldb ohx15maxpcULmldb;

	do count=1 to 7; laxULmldb(count)=max(of laaULmldb(count),ladULmldb(count));
	pcxULmldb(count)=max(of pcaULmldb(count),pcdULmldb(count));
	end;
	drop count;

	nteethipxla6mmULmldb=0;
	nteethipxpc5mmULmldb=0;
	do count=1 to 7; 
	if laxULmldb (count) ge 6 then nteethipxla6mmULmldb=nteethipxla6mmULmldb+1;
	if pcxULmldb(count) ge 5 then nteethipxpc5mmULmldb=nteethipxpc5mmULmldb+1;
	end; 
	if nteethipxla6mmULmldb>=2 AND nteethipxpc5mmULmldb>=1 then periostatusULmldb=3;

	if 	ohx09laa=. and
		ohx10laa=. and 
		ohx11laa=. and 
		ohx12laa=. and
		ohx13laa=. and
		ohx14laa=. and 
		ohx15laa=. and
		ohx09lad=. and
		ohx10lad=. and 
		ohx11lad=. and 
		ohx12lad=. and
		ohx13lad=. and
		ohx14lad=. and 
		ohx15lad=. then do; periostatusULmldb=.; end;

	/*All interproximal site*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasULall (7) 		ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las;
	array laaULall (7)		ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa;
	array ladULall (7)		ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad;
	array lapULall (7)		ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap;
	array laxULall (7) 		ohx09maxlaULall ohx10maxlaULall ohx11maxlaULall ohx12maxlaULall ohx13maxlaULall
							ohx14maxlaULall ohx15maxlaULall;

	array pcsULall (7) 		ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs;
	array pcaULall (7)		ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca;
	array pcdULall (7)		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd;
	array pcpULall (7)		ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp;
	array pcxULall (7) 		ohx09maxpcULall ohx10maxpcULall ohx11maxpcULall ohx12maxpcULall ohx13maxpcULall
							ohx14maxpcULall ohx15maxpcULall;

	do count=1 to 7; laxULall(count)=max(of lasULall(count),laaULall(count), ladULall(count),lapULall(count));
	pcxULall(count)=max(of pcsULall(count),pcaULall(count), pcdULall(count),pcpULall(count));
	end;
	drop count;

	nteethipxla6mmULall=0;
	nteethipxpc5mmULall=0;
	do count=1 to 7; 
	if laxULall (count) ge 6 then nteethipxla6mmULall=nteethipxla6mmULall+1;
	if pcxULall(count) ge 5 then nteethipxpc5mmULall=nteethipxpc5mmULall+1;
	end; 
	if nteethipxla6mmULall>=2 AND nteethipxpc5mmULall>=1 then periostatusULall=3;

	if 	ohx09las=. and
		ohx10las=. and 
		ohx11las=. and 
		ohx12las=. and
		ohx13las=. and
		ohx14las=. and 
		ohx15las=. and
		ohx09laa=. and
		ohx10laa=. and 
		ohx11laa=. and 
		ohx12laa=. and
		ohx13laa=. and
		ohx14laa=. and 
		ohx15laa=. and
		ohx09lad=. and
		ohx10lad=. and 
		ohx11lad=. and 
		ohx12lad=. and
		ohx13lad=. and
		ohx14lad=. and 
		ohx15lad=. and
		ohx09lap=. and
		ohx10lap=. and 
		ohx11lap=. and 
		ohx12lap=. and
		ohx13lap=. and
		ohx14lap=. and 
		ohx15lap=. then do; periostatusULall=.; end;
	run;

/*Checking if severe perio was correctly coded using different interproximal sites*/
/*Mesiobuccal*/
proc print data=ULsens (obs=200);
var SEQN	ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las nteethipxla6mmULmb
			ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs nteethipxpc5mmULmb
			periostatusULmb;
			run;

/*Mesiolingual*/
proc print data=ULsens (obs=200);
var SEQN	ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa nteethipxla6mmULml
			ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca nteethipxpc5mmULml
			periostatusULml;
			run;

/*Distobuccal*/
proc print data=ULsens (obs=100);
var SEQN	ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad nteethipxla6mmULdb
			ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd nteethipxpc5mmULdb
			periostatusULdb;
			run;

/*Distolingual*/
proc print data=ULsens (obs=100);
var SEQN	ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap nteethipxla6mmULdl
			ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp nteethipxpc5mmULdl
			periostatusULdl;
			run;

/*Mesiobuccal and mesiolingual*/
proc print data=ULsens (obs=100);
var SEQN	ohx09las ohx09laa ohx09maxlaULmbml 
			ohx10las ohx10laa ohx10maxlaULmbml
			ohx11las ohx11laa ohx11maxlaULmbml
			ohx12las ohx12laa ohx12maxlaULmbml
			ohx13las ohx13laa ohx13maxlaULmbml
			ohx14las ohx14laa ohx14maxlaULmbml 
			ohx15las ohx15laa ohx15maxlaULmbml
			ohx09pcs ohx09pca ohx09maxpcULmbml 
			ohx10pcs ohx10pca ohx10maxpcULmbml
			ohx11pcs ohx11pca ohx11maxpcULmbml
			ohx12pcs ohx12pca ohx12maxpcULmbml
			ohx13pcs ohx13pca ohx13maxpcULmbml
			ohx14pcs ohx14pca ohx14maxpcULmbml 
			ohx15pcs ohx15pca ohx15maxpcULmbml;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULmbml ohx10maxlaULmbml ohx11maxlaULmbml ohx12maxlaULmbml ohx13maxlaULmbml
			ohx14maxlaULmbml ohx15maxlaULmbml nteethipxla6mmULmbml
			ohx09maxpcULmbml ohx10maxpcULmbml ohx11maxpcULmbml ohx12maxpcULmbml ohx13maxpcULmbml
			ohx14maxpcULmbml ohx15maxpcULmbml nteethipxpc5mmULmbml
			periostatusULmbml;
			run;

/*Distobuccal and distolingual*/
proc print data=ULsens (obs=100);
var SEQN	ohx09lad ohx09lap ohx09maxlaULdbdl 
			ohx10lad ohx10lap ohx10maxlaULdbdl
			ohx11lad ohx11lap ohx11maxlaULdbdl
			ohx12lad ohx12lap ohx12maxlaULdbdl
			ohx13lad ohx13lap ohx13maxlaULdbdl
			ohx14lad ohx14lap ohx14maxlaULdbdl 
			ohx15lad ohx15lap ohx15maxlaULdbdl
			ohx09pcd ohx09pcp ohx09maxpcULdbdl 
			ohx10pcd ohx10pcp ohx10maxpcULdbdl
			ohx11pcd ohx11pcp ohx11maxpcULdbdl
			ohx12pcd ohx12pcp ohx12maxpcULdbdl
			ohx13pcd ohx13pcp ohx13maxpcULdbdl
			ohx14pcd ohx14pcp ohx14maxpcULdbdl 
			ohx15pcd ohx15pcp ohx15maxpcULdbdl;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULdbdl ohx10maxlaULdbdl ohx11maxlaULdbdl ohx12maxlaULdbdl ohx13maxlaULdbdl
			ohx14maxlaULdbdl ohx15maxlaULdbdl nteethipxla6mmULdbdl
			ohx09maxpcULdbdl ohx10maxpcULdbdl ohx11maxpcULdbdl ohx12maxpcULdbdl ohx13maxpcULdbdl
			ohx14maxpcULdbdl ohx15maxpcULdbdl nteethipxpc5mmULdbdl
			periostatusULdbdl;
			run;

/*Mesiobuccal and distobuccal*/
proc print data=ULsens (obs=100);
var SEQN	ohx09las ohx09lad ohx09maxlaULmbdb 
			ohx10las ohx10lad ohx10maxlaULmbdb
			ohx11las ohx11lad ohx11maxlaULmbdb
			ohx12las ohx12lad ohx12maxlaULmbdb
			ohx13las ohx13lad ohx13maxlaULmbdb
			ohx14las ohx14lad ohx14maxlaULmbdb 
			ohx15las ohx15lad ohx15maxlaULmbdb
			ohx09pcs ohx09pcd ohx09maxpcULmbdb 
			ohx10pcs ohx10pcd ohx10maxpcULmbdb
			ohx11pcs ohx11pcd ohx11maxpcULmbdb
			ohx12pcs ohx12pcd ohx12maxpcULmbdb
			ohx13pcs ohx13pcd ohx13maxpcULmbdb
			ohx14pcs ohx14pcd ohx14maxpcULmbdb 
			ohx15pcs ohx15pcd ohx15maxpcULmbdb;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULmbdb ohx10maxlaULmbdb ohx11maxlaULmbdb ohx12maxlaULmbdb ohx13maxlaULmbdb
			ohx14maxlaULmbdb ohx15maxlaULmbdb nteethipxla6mmULmbdb
			ohx09maxpcULmbdb ohx10maxpcULmbdb ohx11maxpcULmbdb ohx12maxpcULmbdb ohx13maxpcULmbdb
			ohx14maxpcULmbdb ohx15maxpcULmbdb nteethipxpc5mmULmbdb
			periostatusULmbdb;
			run;

/*Mesiolingual and distolingual*/
proc print data=ULsens (obs=100);
var SEQN	ohx09laa ohx09lap ohx09maxlaULmldl 
			ohx10laa ohx10lap ohx10maxlaULmldl
			ohx11laa ohx11lap ohx11maxlaULmldl
			ohx12laa ohx12lap ohx12maxlaULmldl
			ohx13laa ohx13lap ohx13maxlaULmldl
			ohx14laa ohx14lap ohx14maxlaULmldl 
			ohx15laa ohx15lap ohx15maxlaULmldl
			ohx09pca ohx09pcp ohx09maxpcULmldl 
			ohx10pca ohx10pcp ohx10maxpcULmldl
			ohx11pca ohx11pcp ohx11maxpcULmldl
			ohx12pca ohx12pcp ohx12maxpcULmldl
			ohx13pca ohx13pcp ohx13maxpcULmldl
			ohx14pca ohx14pcp ohx14maxpcULmldl 
			ohx15pca ohx15pcp ohx15maxpcULmldl;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULmldl ohx10maxlaULmldl ohx11maxlaULmldl ohx12maxlaULmldl ohx13maxlaULmldl
			ohx14maxlaULmldl ohx15maxlaULmldl nteethipxla6mmULmldl
			ohx09maxpcULmldl ohx10maxpcULmldl ohx11maxpcULmldl ohx12maxpcULmldl ohx13maxpcULmldl
			ohx14maxpcULmldl ohx15maxpcULmldl nteethipxpc5mmULmldl
			periostatusULmldl;
			run;

/*Mesiobuccal and distolingual*/
proc print data=ULsens (obs=100);
var SEQN	ohx09las ohx09lap ohx09maxlaULmbdl 
			ohx10las ohx10lap ohx10maxlaULmbdl
			ohx11las ohx11lap ohx11maxlaULmbdl
			ohx12las ohx12lap ohx12maxlaULmbdl
			ohx13las ohx13lap ohx13maxlaULmbdl
			ohx14las ohx14lap ohx14maxlaULmbdl 
			ohx15las ohx15lap ohx15maxlaULmbdl
			ohx09pcs ohx09pcp ohx09maxpcULmbdl 
			ohx10pcs ohx10pcp ohx10maxpcULmbdl
			ohx11pcs ohx11pcp ohx11maxpcULmbdl
			ohx12pcs ohx12pcp ohx12maxpcULmbdl
			ohx13pcs ohx13pcp ohx13maxpcULmbdl
			ohx14pcs ohx14pcp ohx14maxpcULmbdl 
			ohx15pcs ohx15pcp ohx15maxpcULmbdl;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULmbdl ohx10maxlaULmbdl ohx11maxlaULmbdl ohx12maxlaULmbdl ohx13maxlaULmbdl
			ohx14maxlaULmbdl ohx15maxlaULmbdl nteethipxla6mmULmbdl
			ohx09maxpcULmbdl ohx10maxpcULmbdl ohx11maxpcULmbdl ohx12maxpcULmbdl ohx13maxpcULmbdl
			ohx14maxpcULmbdl ohx15maxpcULmbdl nteethipxpc5mmULmbdl
			periostatusULmbdl;
			run;

/*Mesiolingual and distobuccal*/
proc print data=ULsens (obs=100);
var SEQN	ohx09laa ohx09lad ohx09maxlaULmldb 
			ohx10laa ohx10lad ohx10maxlaULmldb
			ohx11laa ohx11lad ohx11maxlaULmldb
			ohx12laa ohx12lad ohx12maxlaULmldb
			ohx13laa ohx13lad ohx13maxlaULmldb
			ohx14laa ohx14lad ohx14maxlaULmldb 
			ohx15laa ohx15lad ohx15maxlaULmldb
			ohx09pca ohx09pcd ohx09maxpcULmldb 
			ohx10pca ohx10pcd ohx10maxpcULmldb
			ohx11pca ohx11pcd ohx11maxpcULmldb
			ohx12pca ohx12pcd ohx12maxpcULmldb
			ohx13pca ohx13pcd ohx13maxpcULmldb
			ohx14pca ohx14pcd ohx14maxpcULmldb 
			ohx15pca ohx15pcd ohx15maxpcULmldb;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULmldb ohx10maxlaULmldb ohx11maxlaULmldb ohx12maxlaULmldb ohx13maxlaULmldb
			ohx14maxlaULmldb ohx15maxlaULmldb nteethipxla6mmULmldb
			ohx09maxpcULmldb ohx10maxpcULmldb ohx11maxpcULmldb ohx12maxpcULmldb ohx13maxpcULmldb
			ohx14maxpcULmldb ohx15maxpcULmldb nteethipxpc5mmULmldb
			periostatusULmldb;
			run;

/*All interproximal sites*/
proc print data=ULsens (obs=100);
var SEQN	ohx09las ohx09laa ohx09lad ohx09lap ohx09maxlaULall 
			ohx10las ohx10laa ohx10lad ohx10lap ohx10maxlaULall
			ohx11las ohx11laa ohx11lad ohx11lap ohx11maxlaULall
			ohx12las ohx12laa ohx12lad ohx12lap ohx12maxlaULall
			ohx13las ohx13laa ohx13lad ohx13lap ohx13maxlaULall
			ohx14las ohx14laa ohx14lad ohx14lap ohx14maxlaULall 
			ohx15las ohx15laa ohx15lad ohx15lap ohx15maxlaULall
			ohx09pcs ohx09pca ohx09pcd ohx09pcp ohx09maxpcULall 
			ohx10pcs ohx10pca ohx10pcd ohx10pcp ohx10maxpcULall
			ohx11pcs ohx11pca ohx11pcd ohx11pcp ohx11maxpcULall
			ohx12pcs ohx12pca ohx12pcd ohx12pcp ohx12maxpcULall
			ohx13pcs ohx13pca ohx13pcd ohx13pcp ohx13maxpcULall
			ohx14pcs ohx14pca ohx14pcd ohx14pcp ohx14maxpcULall 
			ohx15pcs ohx15pca ohx15pcd ohx15pcp ohx15maxpcULall;
			run;

proc print data=ULsens (obs=100);
var SEQN	ohx09maxlaULall ohx10maxlaULall ohx11maxlaULall ohx12maxlaULall ohx13maxlaULall
			ohx14maxlaULall ohx15maxlaULall nteethipxla6mmULall
			ohx09maxpcULall ohx10maxpcULall ohx11maxpcULall ohx12maxpcULall ohx13maxpcULall
			ohx14maxpcULall ohx15maxpcULall nteethipxpc5mmULall
			periostatusULall;
			run;

proc freq data=ULsens;
tables periostatusULmb*periostatus/missing nopercent norow;
tables periostatusULml*periostatus/missing nopercent norow;
tables periostatusULdb*periostatus/missing nopercent norow;
tables periostatusULdl*periostatus/missing nopercent norow;
tables periostatusULmbml*periostatus/missing nopercent norow;
tables periostatusULdbdl*periostatus/missing nopercent norow;
tables periostatusULmbdb*periostatus/missing nopercent norow;
tables periostatusULmldl*periostatus/missing nopercent norow;
tables periostatusULmbdl*periostatus/missing nopercent norow;
tables periostatusULmldb*periostatus/missing nopercent norow;
tables periostatusULall*periostatus/missing nopercent norow;
run;

/*Saving the ULsens as a permanent dataset to produce a figure*/
data part.ULsens;
	set ULsens;
	run;

/*Lower left quadrant*/
data LLsens;
	set one;
	
	/*Mesiobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLLmb (7) 	ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array pdLLmb (7) 	ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;

	nteethipxla6mmLLmb=0;
	nteethipxpc5mmLLmb=0;
	do count=1 to 7; 
	if teethLLmb (count) ge 6 then nteethipxla6mmLLmb=nteethipxla6mmLLmb+1;
	if pdLLmb(count) ge 5 then nteethipxpc5mmLLmb=nteethipxpc5mmLLmb+1;
	end; 
	if nteethipxla6mmLLmb>=2 AND nteethipxpc5mmLLmb>=1 then periostatusLLmb=3;

	if 	ohx18las=. and
		ohx19las=. and 
		ohx20las=. and 
		ohx21las=. and
		ohx22las=. and
		ohx23las=. and 
		ohx24las=. then do; periostatusLLmb=.; end;

	/*Mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLLml (7) 	ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array pdLLml (7) 	ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;

	nteethipxla6mmLLml=0;
	nteethipxpc5mmLLml=0;
	do count=1 to 7; 
	if teethLLml (count) ge 6 then nteethipxla6mmLLml=nteethipxla6mmLLml+1;
	if pdLLml(count) ge 5 then nteethipxpc5mmLLml=nteethipxpc5mmLLml+1;
	end; 
	if nteethipxla6mmLLml>=2 AND nteethipxpc5mmLLml>=1 then periostatusLLml=3;

	if 	ohx18laa=. and
		ohx19laa=. and 
		ohx20laa=. and 
		ohx21laa=. and
		ohx22laa=. and
		ohx23laa=. and 
		ohx24laa=. then do; periostatusLLml=.; end;

	/*Distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLLdb (7) 	ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array pdLLdb (7) 	ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;

	nteethipxla6mmLLdb=0;
	nteethipxpc5mmLLdb=0;
	do count=1 to 7; 
	if teethLLdb (count) ge 6 then nteethipxla6mmLLdb=nteethipxla6mmLLdb+1;
	if pdLLdb(count) ge 5 then nteethipxpc5mmLLdb=nteethipxpc5mmLLdb+1;
	end; 
	if nteethipxla6mmLLdb>=2 AND nteethipxpc5mmLLdb>=1 then periostatusLLdb=3;

	if 	ohx18lad=. and
		ohx19lad=. and 
		ohx20lad=. and 
		ohx21lad=. and
		ohx22lad=. and
		ohx23lad=. and 
		ohx24lad=. then do; periostatusLLdb=.; end;

	/*Distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLLdl (7) 	ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array pdLLdl (7) 	ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;

	nteethipxla6mmLLdl=0;
	nteethipxpc5mmLLdl=0;
	do count=1 to 7; 
	if teethLLdl (count) ge 6 then nteethipxla6mmLLdl=nteethipxla6mmLLdl+1;
	if pdLLdl(count) ge 5 then nteethipxpc5mmLLdl=nteethipxpc5mmLLdl+1;
	end; 
	if nteethipxla6mmLLdl>=2 AND nteethipxpc5mmLLdl>=1 then periostatusLLdl=3;

	if 	ohx18lap=. and
		ohx19lap=. and 
		ohx20lap=. and 
		ohx21lap=. and
		ohx22lap=. and
		ohx23lap=. and 
		ohx24lap=. then do; periostatusLLdl=.; end;

	/*Mesiobuccal and mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLLmbml (7) 		ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array laaLLmbml (7)		ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array laxLLmbml (7) ohx18maxlaLLmbml ohx19maxlaLLmbml ohx20maxlaLLmbml ohx21maxlaLLmbml ohx22maxlaLLmbml
						ohx23maxlaLLmbml ohx24maxlaLLmbml;

	array pcsLLmbml (7) 		ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;
	array pcaLLmbml (7)		ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;
	array pcxLLmbml (7) ohx18maxpcLLmbml ohx19maxpcLLmbml ohx20maxpcLLmbml ohx21maxpcLLmbml ohx22maxpcLLmbml
						ohx23maxpcLLmbml ohx24maxpcLLmbml;

	do count=1 to 7; laxLLmbml(count)=max(of lasLLmbml(count),laaLLmbml(count));
	pcxLLmbml(count)=max(of pcsLLmbml(count),pcaLLmbml(count));
	end;
	drop count;

	nteethipxla6mmLLmbml=0;
	nteethipxpc5mmLLmbml=0;
	do count=1 to 7; 
	if laxLLmbml(count) ge 6 then nteethipxla6mmLLmbml=nteethipxla6mmLLmbml+1;
	if pcxLLmbml(count) ge 5 then nteethipxpc5mmLLmbml=nteethipxpc5mmLLmbml+1;
	end; 
	if nteethipxla6mmLLmbml>=2 AND nteethipxpc5mmLLmbml>=1 then periostatusLLmbml=3;

	if 	ohx18las=. and
		ohx19las=. and 
		ohx20las=. and 
		ohx21las=. and
		ohx22las=. and
		ohx23las=. and 
		ohx24las=. and
		ohx18laa=. and
		ohx19laa=. and 
		ohx20laa=. and 
		ohx21laa=. and
		ohx22laa=. and
		ohx23laa=. and 
		ohx24laa=. then do; periostatusLLmbml=.; end;

	/*Distobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array ladLLdbdl (7) 		ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array lapLLdbdl (7)		ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array laxLLdbdl (7) ohx18maxlaLLdbdl ohx19maxlaLLdbdl ohx20maxlaLLdbdl ohx21maxlaLLdbdl ohx22maxlaLLdbdl
						ohx23maxlaLLdbdl ohx24maxlaLLdbdl;

	array pcdLLdbdl (7) 		ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;
	array pcpLLdbdl (7)		ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;
	array pcxLLdbdl (7) ohx18maxpcLLdbdl ohx19maxpcLLdbdl ohx20maxpcLLdbdl ohx21maxpcLLdbdl ohx22maxpcLLdbdl
						ohx23maxpcLLdbdl ohx24maxpcLLdbdl;

	do count=1 to 7; laxLLdbdl(count)=max(of ladLLdbdl(count),lapLLdbdl(count));
	pcxLLdbdl(count)=max(of pcdLLdbdl(count),pcpLLdbdl(count));
	end;
	drop count;

	nteethipxla6mmLLdbdl=0;
	nteethipxpc5mmLLdbdl=0;
	do count=1 to 7; 
	if laxLLdbdl(count) ge 6 then nteethipxla6mmLLdbdl=nteethipxla6mmLLdbdl+1;
	if pcxLLdbdl(count) ge 5 then nteethipxpc5mmLLdbdl=nteethipxpc5mmLLdbdl+1;
	end; 
	if nteethipxla6mmLLdbdl>=2 AND nteethipxpc5mmLLdbdl>=1 then periostatusLLdbdl=3;

	if 	ohx18lad=. and
		ohx19lad=. and 
		ohx20lad=. and 
		ohx21lad=. and
		ohx22lad=. and
		ohx23lad=. and 
		ohx24lad=. and
		ohx18lap=. and
		ohx19lap=. and 
		ohx20lap=. and 
		ohx21lap=. and
		ohx22lap=. and
		ohx23lap=. and 
		ohx24lap=. then do; periostatusLLdbdl=.; end;

	/*Mesiobuccal and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLLmbdb (7) 		ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array ladLLmbdb (7)		ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array laxLLmbdb (7) ohx18maxlaLLmbdb ohx19maxlaLLmbdb ohx20maxlaLLmbdb ohx21maxlaLLmbdb ohx22maxlaLLmbdb
						ohx23maxlaLLmbdb ohx24maxlaLLmbdb;

	array pcsLLmbdb (7) 		ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;
	array pcdLLmbdb (7)		ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;
	array pcxLLmbdb (7) ohx18maxpcLLmbdb ohx19maxpcLLmbdb ohx20maxpcLLmbdb ohx21maxpcLLmbdb ohx22maxpcLLmbdb
						ohx23maxpcLLmbdb ohx24maxpcLLmbdb;

	do count=1 to 7; laxLLmbdb(count)=max(of ladLLmbdb(count),lasLLmbdb(count));
	pcxLLmbdb(count)=max(of pcsLLmbdb(count),pcdLLmbdb(count));
	end;
	drop count;

	nteethipxla6mmLLmbdb=0;
	nteethipxpc5mmLLmbdb=0;
	do count=1 to 7; 
	if laxLLmbdb(count) ge 6 then nteethipxla6mmLLmbdb=nteethipxla6mmLLmbdb+1;
	if pcxLLmbdb(count) ge 5 then nteethipxpc5mmLLmbdb=nteethipxpc5mmLLmbdb+1;
	end; 
	if nteethipxla6mmLLmbdb>=2 AND nteethipxpc5mmLLmbdb>=1 then periostatusLLmbdb=3;

	if 	ohx18las=. and
		ohx19las=. and 
		ohx20las=. and 
		ohx21las=. and
		ohx22las=. and
		ohx23las=. and 
		ohx24las=. and
		ohx18lad=. and
		ohx19lad=. and 
		ohx20lad=. and 
		ohx21lad=. and
		ohx22lad=. and
		ohx23lad=. and 
		ohx24lad=. then do; periostatusLLmbdb=.; end;

	/*Mesiolingual and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaLLmldl (7) 		ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array lapLLmldl (7)		ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array laxLLmldl (7) ohx18maxlaLLmldl ohx19maxlaLLmldl ohx20maxlaLLmldl ohx21maxlaLLmldl ohx22maxlaLLmldl
						ohx23maxlaLLmldl ohx24maxlaLLmldl;

	array pcaLLmldl (7) 		ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;
	array pcpLLmldl (7)		ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;
	array pcxLLmldl (7) ohx18maxpcLLmldl ohx19maxpcLLmldl ohx20maxpcLLmldl ohx21maxpcLLmldl ohx22maxpcLLmldl
						ohx23maxpcLLmldl ohx24maxpcLLmldl;

	do count=1 to 7; laxLLmldl(count)=max(of laaLLmldl(count),lapLLmldl(count));
	pcxLLmldl(count)=max(of pcaLLmldl(count),pcpLLmldl(count));
	end;
	drop count;

	nteethipxla6mmLLmldl=0;
	nteethipxpc5mmLLmldl=0;
	do count=1 to 7; 
	if laxLLmldl(count) ge 6 then nteethipxla6mmLLmldl=nteethipxla6mmLLmldl+1;
	if pcxLLmldl(count) ge 5 then nteethipxpc5mmLLmldl=nteethipxpc5mmLLmldl+1;
	end; 
	if nteethipxla6mmLLmldl>=2 AND nteethipxpc5mmLLmldl>=1 then periostatusLLmldl=3;

	if 	ohx18laa=. and
		ohx19laa=. and 
		ohx20laa=. and 
		ohx21laa=. and
		ohx22laa=. and
		ohx23laa=. and 
		ohx24laa=. and
		ohx18lap=. and
		ohx19lap=. and 
		ohx20lap=. and 
		ohx21lap=. and
		ohx22lap=. and
		ohx23lap=. and 
		ohx24lap=. then do; periostatusLLmldl=.; end;

	/*Mesiobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLLmbdl (7) 		ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array lapLLmbdl (7)		ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array laxLLmbdl (7) ohx18maxlaLLmbdl ohx19maxlaLLmbdl ohx20maxlaLLmbdl ohx21maxlaLLmbdl ohx22maxlaLLmbdl
						ohx23maxlaLLmbdl ohx24maxlaLLmbdl;

	array pcsLLmbdl (7) 		ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;
	array pcpLLmbdl (7)		ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;
	array pcxLLmbdl (7) ohx18maxpcLLmbdl ohx19maxpcLLmbdl ohx20maxpcLLmbdl ohx21maxpcLLmbdl ohx22maxpcLLmbdl
						ohx23maxpcLLmbdl ohx24maxpcLLmbdl;

	do count=1 to 7; laxLLmbdl(count)=max(of lasLLmbdl(count),lapLLmbdl(count));
	pcxLLmbdl(count)=max(of pcsLLmbdl(count),pcpLLmbdl(count));
	end;
	drop count;

	nteethipxla6mmLLmbdl=0;
	nteethipxpc5mmLLmbdl=0;
	do count=1 to 7; 
	if laxLLmbdl(count) ge 6 then nteethipxla6mmLLmbdl=nteethipxla6mmLLmbdl+1;
	if pcxLLmbdl(count) ge 5 then nteethipxpc5mmLLmbdl=nteethipxpc5mmLLmbdl+1;
	end; 
	if nteethipxla6mmLLmbdl>=2 AND nteethipxpc5mmLLmbdl>=1 then periostatusLLmbdl=3;

	if 	ohx18las=. and
		ohx19las=. and 
		ohx20las=. and 
		ohx21las=. and
		ohx22las=. and
		ohx23las=. and 
		ohx24las=. and
		ohx18lap=. and
		ohx19lap=. and 
		ohx20lap=. and 
		ohx21lap=. and
		ohx22lap=. and
		ohx23lap=. and 
		ohx24lap=. then do; periostatusLLmbdl=.; end;

	/*Mesiolingual and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaLLmldb (7) 		ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array ladLLmldb (7)		ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array laxLLmldb (7) ohx18maxlaLLmldb ohx19maxlaLLmldb ohx20maxlaLLmldb ohx21maxlaLLmldb ohx22maxlaLLmldb
						ohx23maxlaLLmldb ohx24maxlaLLmldb;

	array pcaLLmldb (7) 		ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;
	array pcdLLmldb (7)		ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;
	array pcxLLmldb (7) ohx18maxpcLLmldb ohx19maxpcLLmldb ohx20maxpcLLmldb ohx21maxpcLLmldb ohx22maxpcLLmldb
						ohx23maxpcLLmldb ohx24maxpcLLmldb;

	do count=1 to 7; laxLLmldb(count)=max(of laaLLmldb(count),ladLLmldb(count));
	pcxLLmldb(count)=max(of pcaLLmldb(count),pcdLLmldb(count));
	end;
	drop count;

	nteethipxla6mmLLmldb=0;
	nteethipxpc5mmLLmldb=0;
	do count=1 to 7; 
	if laxLLmldb(count) ge 6 then nteethipxla6mmLLmldb=nteethipxla6mmLLmldb+1;
	if pcxLLmldb(count) ge 5 then nteethipxpc5mmLLmldb=nteethipxpc5mmLLmldb+1;
	end; 
	if nteethipxla6mmLLmldb>=2 AND nteethipxpc5mmLLmldb>=1 then periostatusLLmldb=3;

	if 	ohx18laa=. and
		ohx19laa=. and 
		ohx20laa=. and 
		ohx21laa=. and
		ohx22laa=. and
		ohx23laa=. and 
		ohx24laa=. and
		ohx18lad=. and
		ohx19lad=. and 
		ohx20lad=. and 
		ohx21lad=. and
		ohx22lad=. and
		ohx23lad=. and 
		ohx24lad=. then do; periostatusLLmldb=.; end;

	/*All interproximal sites*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLLall (7)		ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array laaLLall (7) 		ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array ladLLall (7)		ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array lapLLall (7)		ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array laxLLall (7) 		ohx18maxlaLLall ohx19maxlaLLall ohx20maxlaLLall ohx21maxlaLLall ohx22maxlaLLall
							ohx23maxlaLLall ohx24maxlaLLall;

	array pcsLLall (7)		ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;
	array pcaLLall (7) 		ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;
	array pcdLLall (7)		ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;
	array pcpLLall (7)		ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;
	array pcxLLall (7) 		ohx18maxpcLLall ohx19maxpcLLall ohx20maxpcLLall ohx21maxpcLLall ohx22maxpcLLall
							ohx23maxpcLLall ohx24maxpcLLall;

	do count=1 to 7; laxLLall(count)=max(of lasLLall(count),laaLLall(count), ladLLall(count),lapLLall(count));
	pcxLLall(count)=max(of pcsLLall(count),pcaLLall(count), pcdLLall(count),pcpLLall(count));
	end;
	drop count;

	nteethipxla6mmLLall=0;
	nteethipxpc5mmLLall=0;
	do count=1 to 7; 
	if laxLLall(count) ge 6 then nteethipxla6mmLLall=nteethipxla6mmLLall+1;
	if pcxLLall(count) ge 5 then nteethipxpc5mmLLall=nteethipxpc5mmLLall+1;
	end; 
	if nteethipxla6mmLLall>=2 AND nteethipxpc5mmLLall>=1 then periostatusLLall=3;

	if 	ohx18las=. and
		ohx19las=. and 
		ohx20las=. and 
		ohx21las=. and
		ohx22las=. and
		ohx23las=. and 
		ohx24las=. and
		ohx18laa=. and
		ohx19laa=. and 
		ohx20laa=. and 
		ohx21laa=. and
		ohx22laa=. and
		ohx23laa=. and 
		ohx24laa=. and
		ohx18lad=. and
		ohx19lad=. and 
		ohx20lad=. and 
		ohx21lad=. and
		ohx22lad=. and
		ohx23lad=. and 
		ohx24lad=. and
		ohx18lap=. and
		ohx19lap=. and 
		ohx20lap=. and 
		ohx21lap=. and
		ohx22lap=. and
		ohx23lap=. and 
		ohx24lap=. then do; periostatusLLall=.; end;
	run;

/*Checking if severe perio was correctly coded using different interproximal sites*/
/*Mesiobuccal*/
proc print data=LLsens (obs=100);
var SEQN	ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las nteethipxla6mmLLmb
			ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs nteethipxpc5mmLLmb
			periostatusLLmb;
			run;

/*Mesiolingual*/
proc print data=LLsens (obs=200);
var SEQN	ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa nteethipxla6mmLLml
			ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca nteethipxpc5mmLLml
			periostatusLLml;
			run;

/*Distobuccal*/
proc print data=LLsens (obs=190);
var SEQN	ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad nteethipxla6mmLLdb
			ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd nteethipxpc5mmLLdb
			periostatusLLdb;
			run;

/*Distolingual*/
proc print data=LLsens (obs=190);
var SEQN	ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap nteethipxla6mmLLdl
			ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp nteethipxpc5mmLLdl
			periostatusLLdl;
			run;

/*Mesiobuccal and mesiolingual*/
proc print data=LLsens (obs=190);
var SEQN	ohx18las ohx18laa ohx18maxlaLLmbml 
			ohx19las ohx19laa ohx19maxlaLLmbml
			ohx20las ohx20laa ohx20maxlaLLmbml
			ohx21las ohx21laa ohx21maxlaLLmbml
			ohx22las ohx22laa ohx22maxlaLLmbml
			ohx23las ohx23laa ohx23maxlaLLmbml 
			ohx24las ohx24laa ohx24maxlaLLmbml
			ohx18pcs ohx18pca ohx18maxpcLLmbml 
			ohx19pcs ohx19pca ohx19maxpcLLmbml
			ohx20pcs ohx20pca ohx20maxpcLLmbml
			ohx21pcs ohx21pca ohx21maxpcLLmbml
			ohx22pcs ohx22pca ohx22maxpcLLmbml
			ohx23pcs ohx23pca ohx23maxpcLLmbml 
			ohx24pcs ohx24pca ohx24maxpcLLmbml;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLmbml ohx19maxlaLLmbml ohx20maxlaLLmbml ohx21maxlaLLmbml ohx22maxlaLLmbml
			ohx23maxlaLLmbml ohx24maxlaLLmbml nteethipxla6mmLLmbml
			ohx18maxpcLLmbml ohx19maxpcLLmbml ohx20maxpcLLmbml ohx21maxpcLLmbml ohx22maxpcLLmbml
			ohx23maxpcLLmbml ohx24maxpcLLmbml nteethipxpc5mmLLmbml
			periostatusLLmbml;
			run;

/*Distobuccal and distolingual*/
proc print data=LLsens (obs=190);
var SEQN	ohx18lad ohx18lap ohx18maxlaLLdbdl 
			ohx19lad ohx19lap ohx19maxlaLLdbdl
			ohx20lad ohx20lap ohx20maxlaLLdbdl
			ohx21lad ohx21lap ohx21maxlaLLdbdl
			ohx22lad ohx22lap ohx22maxlaLLdbdl
			ohx23lad ohx23lap ohx23maxlaLLdbdl 
			ohx24lad ohx24lap ohx24maxlaLLdbdl
			ohx18pcd ohx18pcp ohx18maxpcLLdbdl 
			ohx19pcd ohx19pcp ohx19maxpcLLdbdl
			ohx20pcd ohx20pcp ohx20maxpcLLdbdl
			ohx21pcd ohx21pcp ohx21maxpcLLdbdl
			ohx22pcd ohx22pcp ohx22maxpcLLdbdl
			ohx23pcd ohx23pcp ohx23maxpcLLdbdl 
			ohx24pcd ohx24pcp ohx24maxpcLLdbdl;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLdbdl ohx19maxlaLLdbdl ohx20maxlaLLdbdl ohx21maxlaLLdbdl ohx22maxlaLLdbdl
			ohx23maxlaLLdbdl ohx24maxlaLLdbdl nteethipxla6mmLLdbdl
			ohx18maxpcLLdbdl ohx19maxpcLLdbdl ohx20maxpcLLdbdl ohx21maxpcLLdbdl ohx22maxpcLLdbdl
			ohx23maxpcLLdbdl ohx24maxpcLLdbdl nteethipxpc5mmLLdbdl
			periostatusLLdbdl;
			run;

/*Mesiobuccal and distobuccal*/
proc print data=LLsens (obs=190);
var SEQN	ohx18las ohx18lad ohx18maxlaLLmbdb 
			ohx19las ohx19lad ohx19maxlaLLmbdb
			ohx20las ohx20lad ohx20maxlaLLmbdb
			ohx21las ohx21lad ohx21maxlaLLmbdb
			ohx22las ohx22lad ohx22maxlaLLmbdb
			ohx23las ohx23lad ohx23maxlaLLmbdb 
			ohx24las ohx24lad ohx24maxlaLLmbdb
			ohx18pcs ohx18pcd ohx18maxpcLLmbdb 
			ohx19pcs ohx19pcd ohx19maxpcLLmbdb
			ohx20pcs ohx20pcd ohx20maxpcLLmbdb
			ohx21pcs ohx21pcd ohx21maxpcLLmbdb
			ohx22pcs ohx22pcd ohx22maxpcLLmbdb
			ohx23pcs ohx23pcd ohx23maxpcLLmbdb 
			ohx24pcs ohx24pcd ohx24maxpcLLmbdb;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLmbdb ohx19maxlaLLmbdb ohx20maxlaLLmbdb ohx21maxlaLLmbdb ohx22maxlaLLmbdb
			ohx23maxlaLLmbdb ohx24maxlaLLmbdb nteethipxla6mmLLmbdb
			ohx18maxpcLLmbdb ohx19maxpcLLmbdb ohx20maxpcLLmbdb ohx21maxpcLLmbdb ohx22maxpcLLmbdb
			ohx23maxpcLLmbdb ohx24maxpcLLmbdb nteethipxpc5mmLLmbdb
			periostatusLLmbdb;
			run;

/*Mesiolingual and distolingual*/
proc print data=LLsens (obs=190);
var SEQN	ohx18laa ohx18lap ohx18maxlaLLmldl 
			ohx19laa ohx19lap ohx19maxlaLLmldl
			ohx20laa ohx20lap ohx20maxlaLLmldl
			ohx21laa ohx21lap ohx21maxlaLLmldl
			ohx22laa ohx22lap ohx22maxlaLLmldl
			ohx23laa ohx23lap ohx23maxlaLLmldl 
			ohx24laa ohx24lap ohx24maxlaLLmldl
			ohx18pca ohx18pcp ohx18maxpcLLmldl 
			ohx19pca ohx19pcp ohx19maxpcLLmldl
			ohx20pca ohx20pcp ohx20maxpcLLmldl
			ohx21pca ohx21pcp ohx21maxpcLLmldl
			ohx22pca ohx22pcp ohx22maxpcLLmldl
			ohx23pca ohx23pcp ohx23maxpcLLmldl 
			ohx24pca ohx24pcp ohx24maxpcLLmldl;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLmldl ohx19maxlaLLmldl ohx20maxlaLLmldl ohx21maxlaLLmldl ohx22maxlaLLmldl
			ohx23maxlaLLmldl ohx24maxlaLLmldl nteethipxla6mmLLmldl
			ohx18maxpcLLmldl ohx19maxpcLLmldl ohx20maxpcLLmldl ohx21maxpcLLmldl ohx22maxpcLLmldl
			ohx23maxpcLLmldl ohx24maxpcLLmldl nteethipxpc5mmLLmldl
			periostatusLLmldl;
			run;

/*Mesiobuccal and distolingual*/
proc print data=LLsens (obs=190);
var SEQN	ohx18las ohx18lap ohx18maxlaLLmbdl 
			ohx19las ohx19lap ohx19maxlaLLmbdl
			ohx20las ohx20lap ohx20maxlaLLmbdl
			ohx21las ohx21lap ohx21maxlaLLmbdl
			ohx22las ohx22lap ohx22maxlaLLmbdl
			ohx23las ohx23lap ohx23maxlaLLmbdl 
			ohx24las ohx24lap ohx24maxlaLLmbdl
			ohx18pcs ohx18pcp ohx18maxpcLLmbdl 
			ohx19pcs ohx19pcp ohx19maxpcLLmbdl
			ohx20pcs ohx20pcp ohx20maxpcLLmbdl
			ohx21pcs ohx21pcp ohx21maxpcLLmbdl
			ohx22pcs ohx22pcp ohx22maxpcLLmbdl
			ohx23pcs ohx23pcp ohx23maxpcLLmbdl 
			ohx24pcs ohx24pcp ohx24maxpcLLmbdl;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLmbdl ohx19maxlaLLmbdl ohx20maxlaLLmbdl ohx21maxlaLLmbdl ohx22maxlaLLmbdl
			ohx23maxlaLLmbdl ohx24maxlaLLmbdl nteethipxla6mmLLmbdl
			ohx18maxpcLLmbdl ohx19maxpcLLmbdl ohx20maxpcLLmbdl ohx21maxpcLLmbdl ohx22maxpcLLmbdl
			ohx23maxpcLLmbdl ohx24maxpcLLmbdl nteethipxpc5mmLLmbdl
			periostatusLLmbdl;
			run;

/*Mesiolingual and distobuccal*/
proc print data=LLsens (obs=190);
var SEQN	ohx18laa ohx18lad ohx18maxlaLLmldb 
			ohx19laa ohx19lad ohx19maxlaLLmldb
			ohx20laa ohx20lad ohx20maxlaLLmldb
			ohx21laa ohx21lad ohx21maxlaLLmldb
			ohx22laa ohx22lad ohx22maxlaLLmldb
			ohx23laa ohx23lad ohx23maxlaLLmldb 
			ohx24laa ohx24lad ohx24maxlaLLmldb
			ohx18pca ohx18pcd ohx18maxpcLLmldb 
			ohx19pca ohx19pcd ohx19maxpcLLmldb
			ohx20pca ohx20pcd ohx20maxpcLLmldb
			ohx21pca ohx21pcd ohx21maxpcLLmldb
			ohx22pca ohx22pcd ohx22maxpcLLmldb
			ohx23pca ohx23pcd ohx23maxpcLLmldb 
			ohx24pca ohx24pcd ohx24maxpcLLmldb;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLmldb ohx19maxlaLLmldb ohx20maxlaLLmldb ohx21maxlaLLmldb ohx22maxlaLLmldb
			ohx23maxlaLLmldb ohx24maxlaLLmldb nteethipxla6mmLLmldb
			ohx18maxpcLLmldb ohx19maxpcLLmldb ohx20maxpcLLmldb ohx21maxpcLLmldb ohx22maxpcLLmldb
			ohx23maxpcLLmldb ohx24maxpcLLmldb nteethipxpc5mmLLmldb
			periostatusLLmldb;
			run;

/*All interproximal sites*/
proc print data=LLsens (obs=190);
var SEQN	ohx18las ohx18laa ohx18lad ohx18lap ohx18maxlaLLall 
			ohx19las ohx19laa ohx19lad ohx19lap ohx19maxlaLLall
			ohx20las ohx20laa ohx20lad ohx20lap ohx20maxlaLLall
			ohx21las ohx21laa ohx21lad ohx21lap ohx21maxlaLLall
			ohx22las ohx22laa ohx22lad ohx22lap ohx22maxlaLLall
			ohx23las ohx23laa ohx23lad ohx23lap ohx23maxlaLLall 
			ohx24las ohx24laa ohx24lad ohx24lap ohx24maxlaLLall
			ohx18pcs ohx18pca ohx18pcd ohx18pcp ohx18maxpcLLall 
			ohx19pcs ohx19pca ohx19pcd ohx19pcp ohx19maxpcLLall
			ohx20pcs ohx20pca ohx20pcd ohx20pcp ohx20maxpcLLall
			ohx21pcs ohx21pca ohx21pcd ohx21pcp ohx21maxpcLLall
			ohx22pcs ohx22pca ohx22pcd ohx22pcp ohx22maxpcLLall
			ohx23pcs ohx23pca ohx23pcd ohx23pcp ohx23maxpcLLall 
			ohx24pcs ohx24pca ohx24pcd ohx24pcp ohx24maxpcLLall;
			run;

proc print data=LLsens (obs=190);
var SEQN	ohx18maxlaLLall ohx19maxlaLLall ohx20maxlaLLall ohx21maxlaLLall ohx22maxlaLLall
			ohx23maxlaLLall ohx24maxlaLLall nteethipxla6mmLLall
			ohx18maxpcLLall ohx19maxpcLLall ohx20maxpcLLall ohx21maxpcLLall ohx22maxpcLLall
			ohx23maxpcLLall ohx24maxpcLLall nteethipxpc5mmLLall
			periostatusLLall;
			run;

proc freq data=LLsens;
tables periostatusLLmb*periostatus/missing nopercent norow;
tables periostatusLLml*periostatus/missing nopercent norow;
tables periostatusLLdb*periostatus/missing nopercent norow;
tables periostatusLLdl*periostatus/missing nopercent norow;
tables periostatusLLmbml*periostatus/missing nopercent norow;
tables periostatusLLdbdl*periostatus/missing nopercent norow;
tables periostatusLLmbdb*periostatus/missing nopercent norow;
tables periostatusLLmldl*periostatus/missing nopercent norow;
tables periostatusLLmbdl*periostatus/missing nopercent norow;
tables periostatusLLmldb*periostatus/missing nopercent norow;
tables periostatusLLall*periostatus/missing nopercent norow;
run;

/*Saving the LLsens as a permanent dataset to produce a figure*/
data part.LLsens;
	set LLsens;
	run;

/*Lower right quadrant*/
data LRsens;
	set one;
	
	/*Mesiobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLRmb (7) 	ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array pdLRmb (7) 	ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;

	nteethipxla6mmLRmb=0;
	nteethipxpc5mmLRmb=0;
	do count=1 to 7; 
	if teethLRmb (count) ge 6 then nteethipxla6mmLRmb=nteethipxla6mmLRmb+1;
	if pdLRmb(count) ge 5 then nteethipxpc5mmLRmb=nteethipxpc5mmLRmb+1;
	end; 
	if nteethipxla6mmLRmb>=2 AND nteethipxpc5mmLRmb>=1 then periostatusLRmb=3;

	if 	ohx25las=. and
		ohx26las=. and 
		ohx27las=. and 
		ohx28las=. and
		ohx29las=. and
		ohx30las=. and 
		ohx31las=. then do; periostatusLRmb=.; end;

	/*Mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLRml (7) 	ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array pdLRml (7) 	ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;

	nteethipxla6mmLRml=0;
	nteethipxpc5mmLRml=0;
	do count=1 to 7; 
	if teethLRml (count) ge 6 then nteethipxla6mmLRml=nteethipxla6mmLRml+1;
	if pdLRml(count) ge 5 then nteethipxpc5mmLRml=nteethipxpc5mmLRml+1;
	end; 
	if nteethipxla6mmLRml>=2 AND nteethipxpc5mmLRml>=1 then periostatusLRml=3;

	if 	ohx25laa=. and
		ohx26laa=. and 
		ohx27laa=. and 
		ohx28laa=. and
		ohx29laa=. and
		ohx30laa=. and 
		ohx31laa=. then do; periostatusLRml=.; end;

	/*Distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLRdb (7) 	ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array pdLRdb (7) 	ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;

	nteethipxla6mmLRdb=0;
	nteethipxpc5mmLRdb=0;
	do count=1 to 7; 
	if teethLRdb (count) ge 6 then nteethipxla6mmLRdb=nteethipxla6mmLRdb+1;
	if pdLRdb(count) ge 5 then nteethipxpc5mmLRdb=nteethipxpc5mmLRdb+1;
	end; 
	if nteethipxla6mmLRdb>=2 AND nteethipxpc5mmLRdb>=1 then periostatusLRdb=3;

	if 	ohx25lad=. and
		ohx26lad=. and 
		ohx27lad=. and 
		ohx28lad=. and
		ohx29lad=. and
		ohx30lad=. and 
		ohx31lad=. then do; periostatusLRdb=.; end;

	/*Distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array teethLRdl (7) 	ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array pdLRdl (7) 	ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;

	nteethipxla6mmLRdl=0;
	nteethipxpc5mmLRdl=0;
	do count=1 to 7; 
	if teethLRdl (count) ge 6 then nteethipxla6mmLRdl=nteethipxla6mmLRdl+1;
	if pdLRdl(count) ge 5 then nteethipxpc5mmLRdl=nteethipxpc5mmLRdl+1;
	end; 
	if nteethipxla6mmLRdl>=2 AND nteethipxpc5mmLRdl>=1 then periostatusLRdl=3;

	if 	ohx25lap=. and
		ohx26lap=. and 
		ohx27lap=. and 
		ohx28lap=. and
		ohx29lap=. and
		ohx30lap=. and 
		ohx31lap=. then do; periostatusLRdl=.; end;

	/*Mesiobuccal and mesiolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLRmbml (7) 		ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array laaLRmbml (7)		ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array laxLRmbml (7) ohx25maxlaLRmbml ohx26maxlaLRmbml ohx27maxlaLRmbml ohx28maxlaLRmbml ohx29maxlaLRmbml
						ohx30maxlaLRmbml ohx31maxlaLRmbml;

	array pcsLRmbml (7) 		ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;
	array pcaLRmbml (7)		ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
	array pcxLRmbml (7) ohx25maxpcLRmbml ohx26maxpcLRmbml ohx27maxpcLRmbml ohx28maxpcLRmbml ohx29maxpcLRmbml
						ohx30maxpcLRmbml ohx31maxpcLRmbml;

	do count=1 to 7; laxLRmbml(count)=max(of lasLRmbml(count),laaLRmbml(count));
	pcxLRmbml(count)=max(of pcsLRmbml(count),pcaLRmbml(count));
	end;
	drop count;

	nteethipxla6mmLRmbml=0;
	nteethipxpc5mmLRmbml=0;
	do count=1 to 7; 
	if laxLRmbml(count) ge 6 then nteethipxla6mmLRmbml=nteethipxla6mmLRmbml+1;
	if pcxLRmbml(count) ge 5 then nteethipxpc5mmLRmbml=nteethipxpc5mmLRmbml+1;
	end; 
	if nteethipxla6mmLRmbml>=2 AND nteethipxpc5mmLRmbml>=1 then periostatusLRmbml=3;

	if 	ohx25las=. and
		ohx26las=. and 
		ohx27las=. and 
		ohx28las=. and
		ohx29las=. and
		ohx30las=. and 
		ohx31las=. and
		ohx25laa=. and
		ohx26laa=. and 
		ohx27laa=. and 
		ohx28laa=. and
		ohx29laa=. and
		ohx30laa=. and 
		ohx31laa=. then do; periostatusLRmbml=.; end;

	/*Distobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array ladLRdbdl (7) 		ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array lapLRdbdl (7)		ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array laxLRdbdl (7) ohx25maxlaLRdbdl ohx26maxlaLRdbdl ohx27maxlaLRdbdl ohx28maxlaLRdbdl ohx29maxlaLRdbdl
						ohx30maxlaLRdbdl ohx31maxlaLRdbdl;

	array pcdLRdbdl (7) 		ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;
	array pcpLRdbdl (7)		ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;
	array pcxLRdbdl (7) ohx25maxpcLRdbdl ohx26maxpcLRdbdl ohx27maxpcLRdbdl ohx28maxpcLRdbdl ohx29maxpcLRdbdl
						ohx30maxpcLRdbdl ohx31maxpcLRdbdl;

	do count=1 to 7; laxLRdbdl(count)=max(of ladLRdbdl(count),lapLRdbdl(count));
	pcxLRdbdl(count)=max(of pcdLRdbdl(count),pcpLRdbdl(count));
	end;
	drop count;

	nteethipxla6mmLRdbdl=0;
	nteethipxpc5mmLRdbdl=0;
	do count=1 to 7; 
	if laxLRdbdl(count) ge 6 then nteethipxla6mmLRdbdl=nteethipxla6mmLRdbdl+1;
	if pcxLRdbdl(count) ge 5 then nteethipxpc5mmLRdbdl=nteethipxpc5mmLRdbdl+1;
	end; 
	if nteethipxla6mmLRdbdl>=2 AND nteethipxpc5mmLRdbdl>=1 then periostatusLRdbdl=3;

	if 	ohx25lad=. and
		ohx26lad=. and 
		ohx27lad=. and 
		ohx28lad=. and
		ohx29lad=. and
		ohx30lad=. and 
		ohx31lad=. and
		ohx25lap=. and
		ohx26lap=. and 
		ohx27lap=. and 
		ohx28lap=. and
		ohx29lap=. and
		ohx30lap=. and 
		ohx31lap=. then do; periostatusLRdbdl=.; end;

	/*Mesiobuccal and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLRmbdb (7) 		ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array ladLRmbdb (7)		ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array laxLRmbdb (7) ohx25maxlaLRmbdb ohx26maxlaLRmbdb ohx27maxlaLRmbdb ohx28maxlaLRmbdb ohx29maxlaLRmbdb
						ohx30maxlaLRmbdb ohx31maxlaLRmbdb;

	array pcsLRmbdb (7) 		ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;
	array pcdLRmbdb (7)		ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;
	array pcxLRmbdb (7) ohx25maxpcLRmbdb ohx26maxpcLRmbdb ohx27maxpcLRmbdb ohx28maxpcLRmbdb ohx29maxpcLRmbdb
						ohx30maxpcLRmbdb ohx31maxpcLRmbdb;

	do count=1 to 7; laxLRmbdb(count)=max(of ladLRmbdb(count),lasLRmbdb(count));
	pcxLRmbdb(count)=max(of pcsLRmbdb(count),pcdLRmbdb(count));
	end;
	drop count;

	nteethipxla6mmLRmbdb=0;
	nteethipxpc5mmLRmbdb=0;
	do count=1 to 7; 
	if laxLRmbdb(count) ge 6 then nteethipxla6mmLRmbdb=nteethipxla6mmLRmbdb+1;
	if pcxLRmbdb(count) ge 5 then nteethipxpc5mmLRmbdb=nteethipxpc5mmLRmbdb+1;
	end; 
	if nteethipxla6mmLRmbdb>=2 AND nteethipxpc5mmLRmbdb>=1 then periostatusLRmbdb=3;

	if 	ohx25las=. and
		ohx26las=. and 
		ohx27las=. and 
		ohx28las=. and
		ohx29las=. and
		ohx30las=. and 
		ohx31las=. and
		ohx25lad=. and
		ohx26lad=. and 
		ohx27lad=. and 
		ohx28lad=. and
		ohx29lad=. and
		ohx30lad=. and 
		ohx31lad=. then do; periostatusLRmbdb=.; end;

	/*Mesiolingual and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaLRmldl (7) 		ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array lapLRmldl (7)		ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array laxLRmldl (7) ohx25maxlaLRmldl ohx26maxlaLRmldl ohx27maxlaLRmldl ohx28maxlaLRmldl ohx29maxlaLRmldl
						ohx30maxlaLRmldl ohx31maxlaLRmldl;

	array pcaLRmldl (7) 		ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
	array pcpLRmldl (7)		ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;
	array pcxLRmldl (7) ohx25maxpcLRmldl ohx26maxpcLRmldl ohx27maxpcLRmldl ohx28maxpcLRmldl ohx29maxpcLRmldl
						ohx30maxpcLRmldl ohx31maxpcLRmldl;

	do count=1 to 7; laxLRmldl(count)=max(of laaLRmldl(count),lapLRmldl(count));
	pcxLRmldl(count)=max(of pcaLRmldl(count),pcpLRmldl(count));
	end;
	drop count;

	nteethipxla6mmLRmldl=0;
	nteethipxpc5mmLRmldl=0;
	do count=1 to 7; 
	if laxLRmldl(count) ge 6 then nteethipxla6mmLRmldl=nteethipxla6mmLRmldl+1;
	if pcxLRmldl(count) ge 5 then nteethipxpc5mmLRmldl=nteethipxpc5mmLRmldl+1;
	end; 
	if nteethipxla6mmLRmldl>=2 AND nteethipxpc5mmLRmldl>=1 then periostatusLRmldl=3;

	if 	ohx25laa=. and
		ohx26laa=. and 
		ohx27laa=. and 
		ohx28laa=. and
		ohx29laa=. and
		ohx30laa=. and 
		ohx31laa=. and
		ohx25lap=. and
		ohx26lap=. and 
		ohx27lap=. and 
		ohx28lap=. and
		ohx29lap=. and
		ohx30lap=. and 
		ohx31lap=. then do; periostatusLRmldl=.; end;

	/*Mesiobuccal and distolingual sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLRmbdl (7) 		ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array lapLRmbdl (7)		ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array laxLRmbdl (7) ohx25maxlaLRmbdl ohx26maxlaLRmbdl ohx27maxlaLRmbdl ohx28maxlaLRmbdl ohx29maxlaLRmbdl
						ohx30maxlaLRmbdl ohx31maxlaLRmbdl;

	array pcsLRmbdl (7) 		ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;
	array pcpLRmbdl (7)		ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;
	array pcxLRmbdl (7) ohx25maxpcLRmbdl ohx26maxpcLRmbdl ohx27maxpcLRmbdl ohx28maxpcLRmbdl ohx29maxpcLRmbdl
						ohx30maxpcLRmbdl ohx31maxpcLRmbdl;

	do count=1 to 7; laxLRmbdl(count)=max(of lasLRmbdl(count),lapLRmbdl(count));
	pcxLRmbdl(count)=max(of pcsLRmbdl(count),pcpLRmbdl(count));
	end;
	drop count;

	nteethipxla6mmLRmbdl=0;
	nteethipxpc5mmLRmbdl=0;
	do count=1 to 7; 
	if laxLRmbdl(count) ge 6 then nteethipxla6mmLRmbdl=nteethipxla6mmLRmbdl+1;
	if pcxLRmbdl(count) ge 5 then nteethipxpc5mmLRmbdl=nteethipxpc5mmLRmbdl+1;
	end; 
	if nteethipxla6mmLRmbdl>=2 AND nteethipxpc5mmLRmbdl>=1 then periostatusLRmbdl=3;

	if 	ohx25las=. and
		ohx26las=. and 
		ohx27las=. and 
		ohx28las=. and
		ohx29las=. and
		ohx30las=. and 
		ohx31las=. and
		ohx25lap=. and
		ohx26lap=. and 
		ohx27lap=. and 
		ohx28lap=. and
		ohx29lap=. and
		ohx30lap=. and 
		ohx31lap=. then do; periostatusLRmbdl=.; end;

	/*Mesiolingual and distobuccal sites only*/
	/* CDC/AAP severe periodontitis defintion*/
	array laaLRmldb (7) 		ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array ladLRmldb (7)		ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array laxLRmldb (7) ohx25maxlaLRmldb ohx26maxlaLRmldb ohx27maxlaLRmldb ohx28maxlaLRmldb ohx29maxlaLRmldb
						ohx30maxlaLRmldb ohx31maxlaLRmldb;

	array pcaLRmldb (7) 		ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
	array pcdLRmldb (7)		ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;
	array pcxLRmldb (7) ohx25maxpcLRmldb ohx26maxpcLRmldb ohx27maxpcLRmldb ohx28maxpcLRmldb ohx29maxpcLRmldb
						ohx30maxpcLRmldb ohx31maxpcLRmldb;

	do count=1 to 7; laxLRmldb(count)=max(of laaLRmldb(count),ladLRmldb(count));
	pcxLRmldb(count)=max(of pcaLRmldb(count),pcdLRmldb(count));
	end;
	drop count;

	nteethipxla6mmLRmldb=0;
	nteethipxpc5mmLRmldb=0;
	do count=1 to 7; 
	if laxLRmldb(count) ge 6 then nteethipxla6mmLRmldb=nteethipxla6mmLRmldb+1;
	if pcxLRmldb(count) ge 5 then nteethipxpc5mmLRmldb=nteethipxpc5mmLRmldb+1;
	end; 
	if nteethipxla6mmLRmldb>=2 AND nteethipxpc5mmLRmldb>=1 then periostatusLRmldb=3;

	if 	ohx25laa=. and
		ohx26laa=. and 
		ohx27laa=. and 
		ohx28laa=. and
		ohx29laa=. and
		ohx30laa=. and 
		ohx31laa=. and
		ohx25lad=. and
		ohx26lad=. and 
		ohx27lad=. and 
		ohx28lad=. and
		ohx29lad=. and
		ohx30lad=. and 
		ohx31lad=. then do; periostatusLRmldb=.; end;

	/*All interproximal sites*/
	/* CDC/AAP severe periodontitis defintion*/
	array lasLRall (7)		ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array laaLRall (7) 		ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array ladLRall (7)		ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array lapLRall (7)		ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array laxLRall (7) ohx25maxlaLRall ohx26maxlaLRall ohx27maxlaLRall ohx28maxlaLRall ohx29maxlaLRall
						ohx30maxlaLRall ohx31maxlaLRall;

	array pcsLRall (7)		ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;
	array pcaLRall (7) 		ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
	array pcdLRall (7)		ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;
	array pcpLRall (7)		ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;
	array pcxLRall (7) ohx25maxpcLRall ohx26maxpcLRall ohx27maxpcLRall ohx28maxpcLRall ohx29maxpcLRall
						ohx30maxpcLRall ohx31maxpcLRall;

	do count=1 to 7; laxLRall(count)=max(of lasLRall(count),laaLRall(count), ladLRall(count),lapLRall(count));
	pcxLRall(count)=max(of pcsLRall(count),pcaLRall(count), pcdLRall(count),pcpLRall(count));
	end;
	drop count;

	nteethipxla6mmLRall=0;
	nteethipxpc5mmLRall=0;
	do count=1 to 7; 
	if laxLRall(count) ge 6 then nteethipxla6mmLRall=nteethipxla6mmLRall+1;
	if pcxLRall(count) ge 5 then nteethipxpc5mmLRall=nteethipxpc5mmLRall+1;
	end; 
	if nteethipxla6mmLRall>=2 AND nteethipxpc5mmLRall>=1 then periostatusLRall=3;

	if 	ohx25las=. and
		ohx26las=. and 
		ohx27las=. and 
		ohx28las=. and
		ohx29las=. and
		ohx30las=. and 
		ohx31las=. and
		ohx25laa=. and
		ohx26laa=. and 
		ohx27laa=. and 
		ohx28laa=. and
		ohx29laa=. and
		ohx30laa=. and 
		ohx31laa=. and
		ohx25lad=. and
		ohx26lad=. and 
		ohx27lad=. and 
		ohx28lad=. and
		ohx29lad=. and
		ohx30lad=. and 
		ohx31lad=. and
		ohx25lap=. and
		ohx26lap=. and 
		ohx27lap=. and 
		ohx28lap=. and
		ohx29lap=. and
		ohx30lap=. and 
		ohx31lap=. then do; periostatusLRall=.; end;
	run;

/*Checking if severe perio was correctly coded using different interproximal sites*/
/*Mesiobuccal*/
proc print data=LRsens (obs=260);
var SEQN	ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las nteethipxla6mmLRmb
			ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs nteethipxpc5mmLRmb
			periostatusLRmb;
			run;

/*Mesiolingual*/
proc print data=LRsens (obs=270);
var SEQN	ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa nteethipxla6mmLRml
			ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca nteethipxpc5mmLRml
			periostatusLRml;
			run;

/*Distobuccal*/
proc print data=LRsens (obs=260);
var SEQN	ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad nteethipxla6mmLRdb
			ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd nteethipxpc5mmLRdb
			periostatusLRdb;
			run;

/*Distolingual*/
proc print data=LRsens (obs=260);
var SEQN	ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap nteethipxla6mmLRdl
			ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp nteethipxpc5mmLRdl
			periostatusLRdl;
			run;

/*Mesiobuccal and mesiolingual*/
proc print data=LRsens (obs=260);
var SEQN	ohx25las ohx25laa ohx25maxlaLRmbml 
			ohx26las ohx26laa ohx26maxlaLRmbml
			ohx27las ohx27laa ohx27maxlaLRmbml
			ohx28las ohx28laa ohx28maxlaLRmbml
			ohx29las ohx29laa ohx29maxlaLRmbml
			ohx30las ohx30laa ohx30maxlaLRmbml 
			ohx31las ohx31laa ohx31maxlaLRmbml
			ohx25pcs ohx25pca ohx25maxpcLRmbml 
			ohx26pcs ohx26pca ohx26maxpcLRmbml
			ohx27pcs ohx27pca ohx27maxpcLRmbml
			ohx28pcs ohx28pca ohx28maxpcLRmbml
			ohx29pcs ohx29pca ohx29maxpcLRmbml
			ohx30pcs ohx30pca ohx30maxpcLRmbml 
			ohx31pcs ohx31pca ohx31maxpcLRmbml;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRmbml ohx26maxlaLRmbml ohx27maxlaLRmbml ohx28maxlaLRmbml ohx29maxlaLRmbml
			ohx30maxlaLRmbml ohx31maxlaLRmbml nteethipxla6mmLRmbml
			ohx25maxpcLRmbml ohx26maxpcLRmbml ohx27maxpcLRmbml ohx28maxpcLRmbml ohx29maxpcLRmbml
			ohx30maxpcLRmbml ohx31maxpcLRmbml nteethipxpc5mmLRmbml
			periostatusLRmbml;
			run;

/*Distobuccal and distolingual*/
proc print data=LRsens (obs=260);
var SEQN	ohx25lad ohx25lap ohx25maxlaLRdbdl 
			ohx26lad ohx26lap ohx26maxlaLRdbdl
			ohx27lad ohx27lap ohx27maxlaLRdbdl
			ohx28lad ohx28lap ohx28maxlaLRdbdl
			ohx29lad ohx29lap ohx29maxlaLRdbdl
			ohx30lad ohx30lap ohx30maxlaLRdbdl 
			ohx31lad ohx31lap ohx31maxlaLRdbdl
			ohx25pcd ohx25pcp ohx25maxpcLRdbdl 
			ohx26pcd ohx26pcp ohx26maxpcLRdbdl
			ohx27pcd ohx27pcp ohx27maxpcLRdbdl
			ohx28pcd ohx28pcp ohx28maxpcLRdbdl
			ohx29pcd ohx29pcp ohx29maxpcLRdbdl
			ohx30pcd ohx30pcp ohx30maxpcLRdbdl 
			ohx31pcd ohx31pcp ohx31maxpcLRdbdl;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRdbdl ohx26maxlaLRdbdl ohx27maxlaLRdbdl ohx28maxlaLRdbdl ohx29maxlaLRdbdl
			ohx30maxlaLRdbdl ohx31maxlaLRdbdl nteethipxla6mmLRdbdl
			ohx25maxpcLRdbdl ohx26maxpcLRdbdl ohx27maxpcLRdbdl ohx28maxpcLRdbdl ohx29maxpcLRdbdl
			ohx30maxpcLRdbdl ohx31maxpcLRdbdl nteethipxpc5mmLRdbdl
			periostatusLRdbdl;
			run;

/*Mesiobuccal and distobuccal*/
proc print data=LRsens (obs=260);
var SEQN	ohx25las ohx25lad ohx25maxlaLRmbdb 
			ohx26las ohx26lad ohx26maxlaLRmbdb
			ohx27las ohx27lad ohx27maxlaLRmbdb
			ohx28las ohx28lad ohx28maxlaLRmbdb
			ohx29las ohx29lad ohx29maxlaLRmbdb
			ohx30las ohx30lad ohx30maxlaLRmbdb 
			ohx31las ohx31lad ohx31maxlaLRmbdb
			ohx25pcs ohx25pcd ohx25maxpcLRmbdb 
			ohx26pcs ohx26pcd ohx26maxpcLRmbdb
			ohx27pcs ohx27pcd ohx27maxpcLRmbdb
			ohx28pcs ohx28pcd ohx28maxpcLRmbdb
			ohx29pcs ohx29pcd ohx29maxpcLRmbdb
			ohx30pcs ohx30pcd ohx30maxpcLRmbdb 
			ohx31pcs ohx31pcd ohx31maxpcLRmbdb;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRmbdb ohx26maxlaLRmbdb ohx27maxlaLRmbdb ohx28maxlaLRmbdb ohx29maxlaLRmbdb
			ohx30maxlaLRmbdb ohx31maxlaLRmbdb nteethipxla6mmLRmbdb
			ohx25maxpcLRmbdb ohx26maxpcLRmbdb ohx27maxpcLRmbdb ohx28maxpcLRmbdb ohx29maxpcLRmbdb
			ohx30maxpcLRmbdb ohx31maxpcLRmbdb nteethipxpc5mmLRmbdb
			periostatusLRmbdb;
			run;

/*Mesiolingual and distolingual*/
proc print data=LRsens (obs=260);
var SEQN	ohx25laa ohx25lap ohx25maxlaLRmldl 
			ohx26laa ohx26lap ohx26maxlaLRmldl
			ohx27laa ohx27lap ohx27maxlaLRmldl
			ohx28laa ohx28lap ohx28maxlaLRmldl
			ohx29laa ohx29lap ohx29maxlaLRmldl
			ohx30laa ohx30lap ohx30maxlaLRmldl 
			ohx31laa ohx31lap ohx31maxlaLRmldl
			ohx25pca ohx25pcp ohx25maxpcLRmldl 
			ohx26pca ohx26pcp ohx26maxpcLRmldl
			ohx27pca ohx27pcp ohx27maxpcLRmldl
			ohx28pca ohx28pcp ohx28maxpcLRmldl
			ohx29pca ohx29pcp ohx29maxpcLRmldl
			ohx30pca ohx30pcp ohx30maxpcLRmldl 
			ohx31pca ohx31pcp ohx31maxpcLRmldl;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRmldl ohx26maxlaLRmldl ohx27maxlaLRmldl ohx28maxlaLRmldl ohx29maxlaLRmldl
			ohx30maxlaLRmldl ohx31maxlaLRmldl nteethipxla6mmLRmldl
			ohx25maxpcLRmldl ohx26maxpcLRmldl ohx27maxpcLRmldl ohx28maxpcLRmldl ohx29maxpcLRmldl
			ohx30maxpcLRmldl ohx31maxpcLRmldl nteethipxpc5mmLRmldl
			periostatusLRmldl;
			run;

/*Mesiobuccal and distolingual*/
proc print data=LRsens (obs=260);
var SEQN	ohx25las ohx25lap ohx25maxlaLRmbdl 
			ohx26las ohx26lap ohx26maxlaLRmbdl
			ohx27las ohx27lap ohx27maxlaLRmbdl
			ohx28las ohx28lap ohx28maxlaLRmbdl
			ohx29las ohx29lap ohx29maxlaLRmbdl
			ohx30las ohx30lap ohx30maxlaLRmbdl 
			ohx31las ohx31lap ohx31maxlaLRmbdl
			ohx25pcs ohx25pcp ohx25maxpcLRmbdl 
			ohx26pcs ohx26pcp ohx26maxpcLRmbdl
			ohx27pcs ohx27pcp ohx27maxpcLRmbdl
			ohx28pcs ohx28pcp ohx28maxpcLRmbdl
			ohx29pcs ohx29pcp ohx29maxpcLRmbdl
			ohx30pcs ohx30pcp ohx30maxpcLRmbdl 
			ohx31pcs ohx31pcp ohx31maxpcLRmbdl;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRmbdl ohx26maxlaLRmbdl ohx27maxlaLRmbdl ohx28maxlaLRmbdl ohx29maxlaLRmbdl
			ohx30maxlaLRmbdl ohx31maxlaLRmbdl nteethipxla6mmLRmbdl
			ohx25maxpcLRmbdl ohx26maxpcLRmbdl ohx27maxpcLRmbdl ohx28maxpcLRmbdl ohx29maxpcLRmbdl
			ohx30maxpcLRmbdl ohx31maxpcLRmbdl nteethipxpc5mmLRmbdl
			periostatusLRmbdl;
			run;

/*Mesiolingual and distobuccal*/
proc print data=LRsens (obs=260);
var SEQN	ohx25laa ohx25lad ohx25maxlaLRmldb 
			ohx26laa ohx26lad ohx26maxlaLRmldb
			ohx27laa ohx27lad ohx27maxlaLRmldb
			ohx28laa ohx28lad ohx28maxlaLRmldb
			ohx29laa ohx29lad ohx29maxlaLRmldb
			ohx30laa ohx30lad ohx30maxlaLRmldb 
			ohx31laa ohx31lad ohx31maxlaLRmldb
			ohx25pca ohx25pcd ohx25maxpcLRmldb 
			ohx26pca ohx26pcd ohx26maxpcLRmldb
			ohx27pca ohx27pcd ohx27maxpcLRmldb
			ohx28pca ohx28pcd ohx28maxpcLRmldb
			ohx29pca ohx29pcd ohx29maxpcLRmldb
			ohx30pca ohx30pcd ohx30maxpcLRmldb 
			ohx31pca ohx31pcd ohx31maxpcLRmldb;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRmldb ohx26maxlaLRmldb ohx27maxlaLRmldb ohx28maxlaLRmldb ohx29maxlaLRmldb
			ohx30maxlaLRmldb ohx31maxlaLRmldb nteethipxla6mmLRmldb
			ohx25maxpcLRmldb ohx26maxpcLRmldb ohx27maxpcLRmldb ohx28maxpcLRmldb ohx29maxpcLRmldb
			ohx30maxpcLRmldb ohx31maxpcLRmldb nteethipxpc5mmLRmldb
			periostatusLRmldb;
			run;

/*All interproximal sites*/
proc print data=LRsens (obs=260);
var SEQN	ohx25las ohx25laa ohx25lad ohx25lap ohx25maxlaLRall 
			ohx26las ohx26laa ohx26lad ohx26lap ohx26maxlaLRall
			ohx27las ohx27laa ohx27lad ohx27lap ohx27maxlaLRall
			ohx28las ohx28laa ohx28lad ohx28lap ohx28maxlaLRall
			ohx29las ohx29laa ohx29lad ohx29lap ohx29maxlaLRall
			ohx30las ohx30laa ohx30lad ohx30lap ohx30maxlaLRall 
			ohx31las ohx31laa ohx31lad ohx31lap ohx31maxlaLRall
			ohx25pcs ohx25pca ohx25pcd ohx25pcp ohx25maxpcLRall 
			ohx26pcs ohx26pca ohx26pcd ohx26pcp ohx26maxpcLRall
			ohx27pcs ohx27pca ohx27pcd ohx27pcp ohx27maxpcLRall
			ohx28pcs ohx28pca ohx28pcd ohx28pcp ohx28maxpcLRall
			ohx29pcs ohx29pca ohx29pcd ohx29pcp ohx29maxpcLRall
			ohx30pcs ohx30pca ohx30pcd ohx30pcp ohx30maxpcLRall 
			ohx31pcs ohx31pca ohx31pcd ohx31pcp ohx31maxpcLRall;
			run;

proc print data=LRsens (obs=260);
var SEQN	ohx25maxlaLRall ohx26maxlaLRall ohx27maxlaLRall ohx28maxlaLRall ohx29maxlaLRall
			ohx30maxlaLRall ohx31maxlaLRall nteethipxla6mmLRall
			ohx25maxpcLRall ohx26maxpcLRall ohx27maxpcLRall ohx28maxpcLRall ohx29maxpcLRall
			ohx30maxpcLRall ohx31maxpcLRall nteethipxpc5mmLRall
			periostatusLRall;
			run;

proc freq data=LRsens;
tables periostatusLRmb*periostatus/missing nopercent norow;
tables periostatusLRml*periostatus/missing nopercent norow;
tables periostatusLRdb*periostatus/missing nopercent norow;
tables periostatusLRdl*periostatus/missing nopercent norow;
tables periostatusLRmbml*periostatus/missing nopercent norow;
tables periostatusLRdbdl*periostatus/missing nopercent norow;
tables periostatusLRmbdb*periostatus/missing nopercent norow;
tables periostatusLRmldl*periostatus/missing nopercent norow;
tables periostatusLRmbdl*periostatus/missing nopercent norow;
tables periostatusLRmldb*periostatus/missing nopercent norow;
tables periostatusLRall*periostatus/missing nopercent norow;
run;

/*Saving the LRsens as a permanent dataset to produce a figure*/
data part.LRsens;
	set LRsens;
	run;

/* We will use the numbers from UR, UL, LL, and LR to calculate the sensitivity estimates for detecting severe
periodontitis for their combinations*/
/*Numbers from UR*/
data URnteeth;
	set URsens;
	keep SEQN	nteethipxla6mmURmb nteethipxpc5mmURmb periostatusURmb
				nteethipxla6mmURml nteethipxpc5mmURml periostatusURml
				nteethipxla6mmURdb nteethipxpc5mmURdb periostatusURdb
				nteethipxla6mmURdl nteethipxpc5mmURdl periostatusURdl
				nteethipxla6mmURmbml nteethipxpc5mmURmbml periostatusURmbml
				nteethipxla6mmURdbdl nteethipxpc5mmURdbdl periostatusURdbdl
				nteethipxla6mmURmbdb nteethipxpc5mmURmbdb periostatusURmbdb
				nteethipxla6mmURmldl nteethipxpc5mmURmldl periostatusURmldl
				nteethipxla6mmURmbdl nteethipxpc5mmURmbdl periostatusURmbdl
				nteethipxla6mmURmldb nteethipxpc5mmURmldb periostatusURmldb
				nteethipxla6mmURall nteethipxpc5mmURall periostatusURall;
				run;

/*Numbers from UL*/
data ULnteeth;
	set ULsens;
	keep SEQN	nteethipxla6mmULmb nteethipxpc5mmULmb periostatusULmb
				nteethipxla6mmULml nteethipxpc5mmULml periostatusULml
				nteethipxla6mmULdb nteethipxpc5mmULdb periostatusULdb
				nteethipxla6mmULdl nteethipxpc5mmULdl periostatusULdl
				nteethipxla6mmULmbml nteethipxpc5mmULmbml periostatusULmbml
				nteethipxla6mmULdbdl nteethipxpc5mmULdbdl periostatusULdbdl
				nteethipxla6mmULmbdb nteethipxpc5mmULmbdb periostatusULmbdb
				nteethipxla6mmULmldl nteethipxpc5mmULmldl periostatusULmldl
				nteethipxla6mmULmbdl nteethipxpc5mmULmbdl periostatusULmbdl
				nteethipxla6mmULmldb nteethipxpc5mmULmldb periostatusULmldb
				nteethipxla6mmULall nteethipxpc5mmULall periostatusULall;
				run;

/*Numbers from LL*/
data LLnteeth;
	set LLsens;
	keep SEQN	nteethipxla6mmLLmb nteethipxpc5mmLLmb periostatusLLmb
				nteethipxla6mmLLml nteethipxpc5mmLLml periostatusLLml
				nteethipxla6mmLLdb nteethipxpc5mmLLdb periostatusLLdb
				nteethipxla6mmLLdl nteethipxpc5mmLLdl periostatusLLdl
				nteethipxla6mmLLmbml nteethipxpc5mmLLmbml periostatusLLmbml
				nteethipxla6mmLLdbdl nteethipxpc5mmLLdbdl periostatusLLdbdl
				nteethipxla6mmLLmbdb nteethipxpc5mmLLmbdb periostatusLLmbdb
				nteethipxla6mmLLmldl nteethipxpc5mmLLmldl periostatusLLmldl
				nteethipxla6mmLLmbdl nteethipxpc5mmLLmbdl periostatusLLmbdl
				nteethipxla6mmLLmldb nteethipxpc5mmLLmldb periostatusLLmldb
				nteethipxla6mmLLall nteethipxpc5mmLLall periostatusLLall;
				run;

/*Numbers from LR*/
data LRnteeth;
	set LRsens;
	keep SEQN	nteethipxla6mmLRmb nteethipxpc5mmLRmb periostatusLRmb
				nteethipxla6mmLRml nteethipxpc5mmLRml periostatusLRml
				nteethipxla6mmLRdb nteethipxpc5mmLRdb periostatusLRdb
				nteethipxla6mmLRdl nteethipxpc5mmLRdl periostatusLRdl
				nteethipxla6mmLRmbml nteethipxpc5mmLRmbml periostatusLRmbml
				nteethipxla6mmLRdbdl nteethipxpc5mmLRdbdl periostatusLRdbdl
				nteethipxla6mmLRmbdb nteethipxpc5mmLRmbdb periostatusLRmbdb
				nteethipxla6mmLRmldl nteethipxpc5mmLRmldl periostatusLRmldl
				nteethipxla6mmLRmbdl nteethipxpc5mmLRmbdl periostatusLRmbdl
				nteethipxla6mmLRmldb nteethipxpc5mmLRmldb periostatusLRmldb
				nteethipxla6mmLRall nteethipxpc5mmLRall periostatusLRall;
				run;

/*FM periodontitis status from the original dataset we created (data one)*/
data periostatus;
	set one;
	keep SEQN periostatus;
	run;

/*Sorting all five previous datasets*/
proc sort data=URnteeth; by SEQN;run;
proc sort data=ULnteeth; by SEQN;run;
proc sort data=LLnteeth; by SEQN;run;
proc sort data=LRnteeth; by SEQN;run;
proc sort data=periostatus; by SEQN; run;

/*Merging the five datasets by the sequence number (SEQN)*/
data combquad;
	merge URnteeth ULnteeth LLnteeth LRnteeth periostatus;
	by SEQN;

	/*UR and LL*/
	nteethipxla6mmURLLmb=nteethipxla6mmURmb+nteethipxla6mmLLmb;
	nteethipxla6mmURLLml=nteethipxla6mmURml+nteethipxla6mmLLml;
	nteethipxla6mmURLLdb=nteethipxla6mmURdb+nteethipxla6mmLLdb;
	nteethipxla6mmURLLdl=nteethipxla6mmURdl+nteethipxla6mmLLdl;
	nteethipxla6mmURLLmbml=nteethipxla6mmURmbml+nteethipxla6mmLLmbml;
	nteethipxla6mmURLLdbdl=nteethipxla6mmURdbdl+nteethipxla6mmLLdbdl;
	nteethipxla6mmURLLmbdb=nteethipxla6mmURmbdb+nteethipxla6mmLLmbdb;
	nteethipxla6mmURLLmldl=nteethipxla6mmURmldl+nteethipxla6mmLLmldl;
	nteethipxla6mmURLLmbdl=nteethipxla6mmURmbdl+nteethipxla6mmLLmbdl;
	nteethipxla6mmURLLmldb=nteethipxla6mmURmldb+nteethipxla6mmLLmldb;
	nteethipxla6mmURLLall=nteethipxla6mmURall+nteethipxla6mmLLall;

	nteethipxpc5mmURLLmb=nteethipxpc5mmURmb+nteethipxpc5mmLLmb;
	nteethipxpc5mmURLLml=nteethipxpc5mmURml+nteethipxpc5mmLLml;
	nteethipxpc5mmURLLdb=nteethipxpc5mmURdb+nteethipxpc5mmLLdb;
	nteethipxpc5mmURLLdl=nteethipxpc5mmURdl+nteethipxpc5mmLLdl;
	nteethipxpc5mmURLLmbml=nteethipxpc5mmURmbml+nteethipxpc5mmLLmbml;
	nteethipxpc5mmURLLdbdl=nteethipxpc5mmURdbdl+nteethipxpc5mmLLdbdl;
	nteethipxpc5mmURLLmbdb=nteethipxpc5mmURmbdb+nteethipxpc5mmLLmbdb;
	nteethipxpc5mmURLLmldl=nteethipxpc5mmURmldl+nteethipxpc5mmLLmldl;
	nteethipxpc5mmURLLmbdl=nteethipxpc5mmURmbdl+nteethipxpc5mmLLmbdl;
	nteethipxpc5mmURLLmldb=nteethipxpc5mmURmldb+nteethipxpc5mmLLmldb;
	nteethipxpc5mmURLLall=nteethipxpc5mmURall+nteethipxpc5mmLLall;

	if nteethipxla6mmURLLmb>=2 AND nteethipxpc5mmURLLmb>=1 then periostatusURLLmb=3;
	if nteethipxla6mmURLLml>=2 AND nteethipxpc5mmURLLml>=1 then periostatusURLLml=3;
	if nteethipxla6mmURLLdb>=2 AND nteethipxpc5mmURLLdb>=1 then periostatusURLLdb=3;
	if nteethipxla6mmURLLdl>=2 AND nteethipxpc5mmURLLdl>=1 then periostatusURLLdl=3;
	if nteethipxla6mmURLLmbml>=2 AND nteethipxpc5mmURLLmbml>=1 then periostatusURLLmbml=3;
	if nteethipxla6mmURLLdbdl>=2 AND nteethipxpc5mmURLLdbdl>=1 then periostatusURLLdbdl=3;
	if nteethipxla6mmURLLmbdb>=2 AND nteethipxpc5mmURLLmbdb>=1 then periostatusURLLmbdb=3;
	if nteethipxla6mmURLLmldl>=2 AND nteethipxpc5mmURLLmldl>=1 then periostatusURLLmldl=3;
	if nteethipxla6mmURLLmbdl>=2 AND nteethipxpc5mmURLLmbdl>=1 then periostatusURLLmbdl=3;
	if nteethipxla6mmURLLmldb>=2 AND nteethipxpc5mmURLLmldb>=1 then periostatusURLLmldb=3;
	if nteethipxla6mmURLLall>=2 AND nteethipxpc5mmURLLall>=1 then periostatusURLLall=3;

	/*UR and LR*/
	nteethipxla6mmURLRmb=nteethipxla6mmURmb+nteethipxla6mmLRmb;
	nteethipxla6mmURLRml=nteethipxla6mmURml+nteethipxla6mmLRml;
	nteethipxla6mmURLRdb=nteethipxla6mmURdb+nteethipxla6mmLRdb;
	nteethipxla6mmURLRdl=nteethipxla6mmURdl+nteethipxla6mmLRdl;
	nteethipxla6mmURLRmbml=nteethipxla6mmURmbml+nteethipxla6mmLRmbml;
	nteethipxla6mmURLRdbdl=nteethipxla6mmURdbdl+nteethipxla6mmLRdbdl;
	nteethipxla6mmURLRmbdb=nteethipxla6mmURmbdb+nteethipxla6mmLRmbdb;
	nteethipxla6mmURLRmldl=nteethipxla6mmURmldl+nteethipxla6mmLRmldl;
	nteethipxla6mmURLRmbdl=nteethipxla6mmURmbdl+nteethipxla6mmLRmbdl;
	nteethipxla6mmURLRmldb=nteethipxla6mmURmldb+nteethipxla6mmLRmldb;
	nteethipxla6mmURLRall=nteethipxla6mmURall+nteethipxla6mmLRall;

	nteethipxpc5mmURLRmb=nteethipxpc5mmURmb+nteethipxpc5mmLRmb;
	nteethipxpc5mmURLRml=nteethipxpc5mmURml+nteethipxpc5mmLRml;
	nteethipxpc5mmURLRdb=nteethipxpc5mmURdb+nteethipxpc5mmLRdb;
	nteethipxpc5mmURLRdl=nteethipxpc5mmURdl+nteethipxpc5mmLRdl;
	nteethipxpc5mmURLRmbml=nteethipxpc5mmURmbml+nteethipxpc5mmLRmbml;
	nteethipxpc5mmURLRdbdl=nteethipxpc5mmURdbdl+nteethipxpc5mmLRdbdl;
	nteethipxpc5mmURLRmbdb=nteethipxpc5mmURmbdb+nteethipxpc5mmLRmbdb;
	nteethipxpc5mmURLRmldl=nteethipxpc5mmURmldl+nteethipxpc5mmLRmldl;
	nteethipxpc5mmURLRmbdl=nteethipxpc5mmURmbdl+nteethipxpc5mmLRmbdl;
	nteethipxpc5mmURLRmldb=nteethipxpc5mmURmldb+nteethipxpc5mmLRmldb;
	nteethipxpc5mmURLRall=nteethipxpc5mmURall+nteethipxpc5mmLRall;

	if nteethipxla6mmURLRmb>=2 AND nteethipxpc5mmURLRmb>=1 then periostatusURLRmb=3;
	if nteethipxla6mmURLRml>=2 AND nteethipxpc5mmURLRml>=1 then periostatusURLRml=3;
	if nteethipxla6mmURLRdb>=2 AND nteethipxpc5mmURLRdb>=1 then periostatusURLRdb=3;
	if nteethipxla6mmURLRdl>=2 AND nteethipxpc5mmURLRdl>=1 then periostatusURLRdl=3;
	if nteethipxla6mmURLRmbml>=2 AND nteethipxpc5mmURLRmbml>=1 then periostatusURLRmbml=3;
	if nteethipxla6mmURLRdbdl>=2 AND nteethipxpc5mmURLRdbdl>=1 then periostatusURLRdbdl=3;
	if nteethipxla6mmURLRmbdb>=2 AND nteethipxpc5mmURLRmbdb>=1 then periostatusURLRmbdb=3;
	if nteethipxla6mmURLRmldl>=2 AND nteethipxpc5mmURLRmldl>=1 then periostatusURLRmldl=3;
	if nteethipxla6mmURLRmbdl>=2 AND nteethipxpc5mmURLRmbdl>=1 then periostatusURLRmbdl=3;
	if nteethipxla6mmURLRmldb>=2 AND nteethipxpc5mmURLRmldb>=1 then periostatusURLRmldb=3;
	if nteethipxla6mmURLRall>=2 AND nteethipxpc5mmURLRall>=1 then periostatusURLRall=3;

	/*UR and UL*/
	nteethipxla6mmURULmb=nteethipxla6mmURmb+nteethipxla6mmULmb;
	nteethipxla6mmURULml=nteethipxla6mmURml+nteethipxla6mmULml;
	nteethipxla6mmURULdb=nteethipxla6mmURdb+nteethipxla6mmULdb;
	nteethipxla6mmURULdl=nteethipxla6mmURdl+nteethipxla6mmULdl;
	nteethipxla6mmURULmbml=nteethipxla6mmURmbml+nteethipxla6mmULmbml;
	nteethipxla6mmURULdbdl=nteethipxla6mmURdbdl+nteethipxla6mmULdbdl;
	nteethipxla6mmURULmbdb=nteethipxla6mmURmbdb+nteethipxla6mmULmbdb;
	nteethipxla6mmURULmldl=nteethipxla6mmURmldl+nteethipxla6mmULmldl;
	nteethipxla6mmURULmbdl=nteethipxla6mmURmbdl+nteethipxla6mmULmbdl;
	nteethipxla6mmURULmldb=nteethipxla6mmURmldb+nteethipxla6mmULmldb;
	nteethipxla6mmURULall=nteethipxla6mmURall+nteethipxla6mmULall;

	nteethipxpc5mmURULmb=nteethipxpc5mmURmb+nteethipxpc5mmULmb;
	nteethipxpc5mmURULml=nteethipxpc5mmURml+nteethipxpc5mmULml;
	nteethipxpc5mmURULdb=nteethipxpc5mmURdb+nteethipxpc5mmULdb;
	nteethipxpc5mmURULdl=nteethipxpc5mmURdl+nteethipxpc5mmULdl;
	nteethipxpc5mmURULmbml=nteethipxpc5mmURmbml+nteethipxpc5mmULmbml;
	nteethipxpc5mmURULdbdl=nteethipxpc5mmURdbdl+nteethipxpc5mmULdbdl;
	nteethipxpc5mmURULmbdb=nteethipxpc5mmURmbdb+nteethipxpc5mmULmbdb;
	nteethipxpc5mmURULmldl=nteethipxpc5mmURmldl+nteethipxpc5mmULmldl;
	nteethipxpc5mmURULmbdl=nteethipxpc5mmURmbdl+nteethipxpc5mmULmbdl;
	nteethipxpc5mmURULmldb=nteethipxpc5mmURmldb+nteethipxpc5mmULmldb;
	nteethipxpc5mmURULall=nteethipxpc5mmURall+nteethipxpc5mmULall;

	if nteethipxla6mmURULmb>=2 AND nteethipxpc5mmURULmb>=1 then periostatusURULmb=3;
	if nteethipxla6mmURULml>=2 AND nteethipxpc5mmURULml>=1 then periostatusURULml=3;
	if nteethipxla6mmURULdb>=2 AND nteethipxpc5mmURULdb>=1 then periostatusURULdb=3;
	if nteethipxla6mmURULdl>=2 AND nteethipxpc5mmURULdl>=1 then periostatusURULdl=3;
	if nteethipxla6mmURULmbml>=2 AND nteethipxpc5mmURULmbml>=1 then periostatusURULmbml=3;
	if nteethipxla6mmURULdbdl>=2 AND nteethipxpc5mmURULdbdl>=1 then periostatusURULdbdl=3;
	if nteethipxla6mmURULmbdb>=2 AND nteethipxpc5mmURULmbdb>=1 then periostatusURULmbdb=3;
	if nteethipxla6mmURULmldl>=2 AND nteethipxpc5mmURULmldl>=1 then periostatusURULmldl=3;
	if nteethipxla6mmURULmbdl>=2 AND nteethipxpc5mmURULmbdl>=1 then periostatusURULmbdl=3;
	if nteethipxla6mmURULmldb>=2 AND nteethipxpc5mmURULmldb>=1 then periostatusURULmldb=3;
	if nteethipxla6mmURULall>=2 AND nteethipxpc5mmURULall>=1 then periostatusURULall=3;

	/*UL and LR*/
	nteethipxla6mmULLRmb=nteethipxla6mmULmb+nteethipxla6mmLRmb;
	nteethipxla6mmULLRml=nteethipxla6mmULml+nteethipxla6mmLRml;
	nteethipxla6mmULLRdb=nteethipxla6mmULdb+nteethipxla6mmLRdb;
	nteethipxla6mmULLRdl=nteethipxla6mmULdl+nteethipxla6mmLRdl;
	nteethipxla6mmULLRmbml=nteethipxla6mmULmbml+nteethipxla6mmLRmbml;
	nteethipxla6mmULLRdbdl=nteethipxla6mmULdbdl+nteethipxla6mmLRdbdl;
	nteethipxla6mmULLRmbdb=nteethipxla6mmULmbdb+nteethipxla6mmLRmbdb;
	nteethipxla6mmULLRmldl=nteethipxla6mmULmldl+nteethipxla6mmLRmldl;
	nteethipxla6mmULLRmbdl=nteethipxla6mmULmbdl+nteethipxla6mmLRmbdl;
	nteethipxla6mmULLRmldb=nteethipxla6mmULmldb+nteethipxla6mmLRmldb;
	nteethipxla6mmULLRall=nteethipxla6mmULall+nteethipxla6mmLRall;

	nteethipxpc5mmULLRmb=nteethipxpc5mmULmb+nteethipxpc5mmLRmb;
	nteethipxpc5mmULLRml=nteethipxpc5mmULml+nteethipxpc5mmLRml;
	nteethipxpc5mmULLRdb=nteethipxpc5mmULdb+nteethipxpc5mmLRdb;
	nteethipxpc5mmULLRdl=nteethipxpc5mmULdl+nteethipxpc5mmLRdl;
	nteethipxpc5mmULLRmbml=nteethipxpc5mmULmbml+nteethipxpc5mmLRmbml;
	nteethipxpc5mmULLRdbdl=nteethipxpc5mmULdbdl+nteethipxpc5mmLRdbdl;
	nteethipxpc5mmULLRmbdb=nteethipxpc5mmULmbdb+nteethipxpc5mmLRmbdb;
	nteethipxpc5mmULLRmldl=nteethipxpc5mmULmldl+nteethipxpc5mmLRmldl;
	nteethipxpc5mmULLRmbdl=nteethipxpc5mmULmbdl+nteethipxpc5mmLRmbdl;
	nteethipxpc5mmULLRmldb=nteethipxpc5mmULmldb+nteethipxpc5mmLRmldb;
	nteethipxpc5mmULLRall=nteethipxpc5mmULall+nteethipxpc5mmLRall;

	if nteethipxla6mmULLRmb>=2 AND nteethipxpc5mmULLRmb>=1 then periostatusULLRmb=3;
	if nteethipxla6mmULLRml>=2 AND nteethipxpc5mmULLRml>=1 then periostatusULLRml=3;
	if nteethipxla6mmULLRdb>=2 AND nteethipxpc5mmULLRdb>=1 then periostatusULLRdb=3;
	if nteethipxla6mmULLRdl>=2 AND nteethipxpc5mmULLRdl>=1 then periostatusULLRdl=3;
	if nteethipxla6mmULLRmbml>=2 AND nteethipxpc5mmULLRmbml>=1 then periostatusULLRmbml=3;
	if nteethipxla6mmULLRdbdl>=2 AND nteethipxpc5mmULLRdbdl>=1 then periostatusULLRdbdl=3;
	if nteethipxla6mmULLRmbdb>=2 AND nteethipxpc5mmULLRmbdb>=1 then periostatusULLRmbdb=3;
	if nteethipxla6mmULLRmldl>=2 AND nteethipxpc5mmULLRmldl>=1 then periostatusULLRmldl=3;
	if nteethipxla6mmULLRmbdl>=2 AND nteethipxpc5mmULLRmbdl>=1 then periostatusULLRmbdl=3;
	if nteethipxla6mmULLRmldb>=2 AND nteethipxpc5mmULLRmldb>=1 then periostatusULLRmldb=3;
	if nteethipxla6mmULLRall>=2 AND nteethipxpc5mmULLRall>=1 then periostatusULLRall=3;

	/*UL and LL*/
	nteethipxla6mmULLLmb=nteethipxla6mmULmb+nteethipxla6mmLLmb;
	nteethipxla6mmULLLml=nteethipxla6mmULml+nteethipxla6mmLLml;
	nteethipxla6mmULLLdb=nteethipxla6mmULdb+nteethipxla6mmLLdb;
	nteethipxla6mmULLLdl=nteethipxla6mmULdl+nteethipxla6mmLLdl;
	nteethipxla6mmULLLmbml=nteethipxla6mmULmbml+nteethipxla6mmLLmbml;
	nteethipxla6mmULLLdbdl=nteethipxla6mmULdbdl+nteethipxla6mmLLdbdl;
	nteethipxla6mmULLLmbdb=nteethipxla6mmULmbdb+nteethipxla6mmLLmbdb;
	nteethipxla6mmULLLmldl=nteethipxla6mmULmldl+nteethipxla6mmLLmldl;
	nteethipxla6mmULLLmbdl=nteethipxla6mmULmbdl+nteethipxla6mmLLmbdl;
	nteethipxla6mmULLLmldb=nteethipxla6mmULmldb+nteethipxla6mmLLmldb;
	nteethipxla6mmULLLall=nteethipxla6mmULall+nteethipxla6mmLLall;

	nteethipxpc5mmULLLmb=nteethipxpc5mmULmb+nteethipxpc5mmLLmb;
	nteethipxpc5mmULLLml=nteethipxpc5mmULml+nteethipxpc5mmLLml;
	nteethipxpc5mmULLLdb=nteethipxpc5mmULdb+nteethipxpc5mmLLdb;
	nteethipxpc5mmULLLdl=nteethipxpc5mmULdl+nteethipxpc5mmLLdl;
	nteethipxpc5mmULLLmbml=nteethipxpc5mmULmbml+nteethipxpc5mmLLmbml;
	nteethipxpc5mmULLLdbdl=nteethipxpc5mmULdbdl+nteethipxpc5mmLLdbdl;
	nteethipxpc5mmULLLmbdb=nteethipxpc5mmULmbdb+nteethipxpc5mmLLmbdb;
	nteethipxpc5mmULLLmldl=nteethipxpc5mmULmldl+nteethipxpc5mmLLmldl;
	nteethipxpc5mmULLLmbdl=nteethipxpc5mmULmbdl+nteethipxpc5mmLLmbdl;
	nteethipxpc5mmULLLmldb=nteethipxpc5mmULmldb+nteethipxpc5mmLLmldb;
	nteethipxpc5mmULLLall=nteethipxpc5mmULall+nteethipxpc5mmLLall;

	if nteethipxla6mmULLLmb>=2 AND nteethipxpc5mmULLLmb>=1 then periostatusULLLmb=3;
	if nteethipxla6mmULLLml>=2 AND nteethipxpc5mmULLLml>=1 then periostatusULLLml=3;
	if nteethipxla6mmULLLdb>=2 AND nteethipxpc5mmULLLdb>=1 then periostatusULLLdb=3;
	if nteethipxla6mmULLLdl>=2 AND nteethipxpc5mmULLLdl>=1 then periostatusULLLdl=3;
	if nteethipxla6mmULLLmbml>=2 AND nteethipxpc5mmULLLmbml>=1 then periostatusULLLmbml=3;
	if nteethipxla6mmULLLdbdl>=2 AND nteethipxpc5mmULLLdbdl>=1 then periostatusULLLdbdl=3;
	if nteethipxla6mmULLLmbdb>=2 AND nteethipxpc5mmULLLmbdb>=1 then periostatusULLLmbdb=3;
	if nteethipxla6mmULLLmldl>=2 AND nteethipxpc5mmULLLmldl>=1 then periostatusULLLmldl=3;
	if nteethipxla6mmULLLmbdl>=2 AND nteethipxpc5mmULLLmbdl>=1 then periostatusULLLmbdl=3;
	if nteethipxla6mmULLLmldb>=2 AND nteethipxpc5mmULLLmldb>=1 then periostatusULLLmldb=3;
	if nteethipxla6mmULLLall>=2 AND nteethipxpc5mmULLLall>=1 then periostatusULLLall=3;

	/*LL and LR*/
	nteethipxla6mmLLLRmb=nteethipxla6mmLLmb+nteethipxla6mmLRmb;
	nteethipxla6mmLLLRml=nteethipxla6mmLLml+nteethipxla6mmLRml;
	nteethipxla6mmLLLRdb=nteethipxla6mmLLdb+nteethipxla6mmLRdb;
	nteethipxla6mmLLLRdl=nteethipxla6mmLLdl+nteethipxla6mmLRdl;
	nteethipxla6mmLLLRmbml=nteethipxla6mmLLmbml+nteethipxla6mmLRmbml;
	nteethipxla6mmLLLRdbdl=nteethipxla6mmLLdbdl+nteethipxla6mmLRdbdl;
	nteethipxla6mmLLLRmbdb=nteethipxla6mmLLmbdb+nteethipxla6mmLRmbdb;
	nteethipxla6mmLLLRmldl=nteethipxla6mmLLmldl+nteethipxla6mmLRmldl;
	nteethipxla6mmLLLRmbdl=nteethipxla6mmLLmbdl+nteethipxla6mmLRmbdl;
	nteethipxla6mmLLLRmldb=nteethipxla6mmLLmldb+nteethipxla6mmLRmldb;
	nteethipxla6mmLLLRall=nteethipxla6mmLLall+nteethipxla6mmLRall;

	nteethipxpc5mmLLLRmb=nteethipxpc5mmLLmb+nteethipxpc5mmLRmb;
	nteethipxpc5mmLLLRml=nteethipxpc5mmLLml+nteethipxpc5mmLRml;
	nteethipxpc5mmLLLRdb=nteethipxpc5mmLLdb+nteethipxpc5mmLRdb;
	nteethipxpc5mmLLLRdl=nteethipxpc5mmLLdl+nteethipxpc5mmLRdl;
	nteethipxpc5mmLLLRmbml=nteethipxpc5mmLLmbml+nteethipxpc5mmLRmbml;
	nteethipxpc5mmLLLRdbdl=nteethipxpc5mmLLdbdl+nteethipxpc5mmLRdbdl;
	nteethipxpc5mmLLLRmbdb=nteethipxpc5mmLLmbdb+nteethipxpc5mmLRmbdb;
	nteethipxpc5mmLLLRmldl=nteethipxpc5mmLLmldl+nteethipxpc5mmLRmldl;
	nteethipxpc5mmLLLRmbdl=nteethipxpc5mmLLmbdl+nteethipxpc5mmLRmbdl;
	nteethipxpc5mmLLLRmldb=nteethipxpc5mmLLmldb+nteethipxpc5mmLRmldb;
	nteethipxpc5mmLLLRall=nteethipxpc5mmLLall+nteethipxpc5mmLRall;

	if nteethipxla6mmLLLRmb>=2 AND nteethipxpc5mmLLLRmb>=1 then periostatusLLLRmb=3;
	if nteethipxla6mmLLLRml>=2 AND nteethipxpc5mmLLLRml>=1 then periostatusLLLRml=3;
	if nteethipxla6mmLLLRdb>=2 AND nteethipxpc5mmLLLRdb>=1 then periostatusLLLRdb=3;
	if nteethipxla6mmLLLRdl>=2 AND nteethipxpc5mmLLLRdl>=1 then periostatusLLLRdl=3;
	if nteethipxla6mmLLLRmbml>=2 AND nteethipxpc5mmLLLRmbml>=1 then periostatusLLLRmbml=3;
	if nteethipxla6mmLLLRdbdl>=2 AND nteethipxpc5mmLLLRdbdl>=1 then periostatusLLLRdbdl=3;
	if nteethipxla6mmLLLRmbdb>=2 AND nteethipxpc5mmLLLRmbdb>=1 then periostatusLLLRmbdb=3;
	if nteethipxla6mmLLLRmldl>=2 AND nteethipxpc5mmLLLRmldl>=1 then periostatusLLLRmldl=3;
	if nteethipxla6mmLLLRmbdl>=2 AND nteethipxpc5mmLLLRmbdl>=1 then periostatusLLLRmbdl=3;
	if nteethipxla6mmLLLRmldb>=2 AND nteethipxpc5mmLLLRmldb>=1 then periostatusLLLRmldb=3;
	if nteethipxla6mmLLLRall>=2 AND nteethipxpc5mmLLLRall>=1 then periostatusLLLRall=3;

	/*All*/
	nteethipxla6mmallmb=nteethipxla6mmURmb+nteethipxla6mmULmb+nteethipxla6mmLLmb+nteethipxla6mmLRmb;
	nteethipxla6mmallml=nteethipxla6mmURml+nteethipxla6mmULml+nteethipxla6mmLLml+nteethipxla6mmLRml;
	nteethipxla6mmalldb=nteethipxla6mmURdb+nteethipxla6mmULdb+nteethipxla6mmLLdb+nteethipxla6mmLRdb;
	nteethipxla6mmalldl=nteethipxla6mmURdl+nteethipxla6mmULdl+nteethipxla6mmLLdl+nteethipxla6mmLRdl;
	nteethipxla6mmallmbml=nteethipxla6mmURmbml+nteethipxla6mmULmbml+nteethipxla6mmLLmbml+nteethipxla6mmLRmbml;
	nteethipxla6mmalldbdl=nteethipxla6mmURdbdl+nteethipxla6mmULdbdl+nteethipxla6mmLLdbdl+nteethipxla6mmLRdbdl;
	nteethipxla6mmallmbdb=nteethipxla6mmURmbdb+nteethipxla6mmULmbdb+nteethipxla6mmLLmbdb+nteethipxla6mmLRmbdb;
	nteethipxla6mmallmldl=nteethipxla6mmURmldl+nteethipxla6mmULmldl+nteethipxla6mmLLmldl+nteethipxla6mmLRmldl;
	nteethipxla6mmallmbdl=nteethipxla6mmURmbdl+nteethipxla6mmULmbdl+nteethipxla6mmLLmbdl+nteethipxla6mmLRmbdl;
	nteethipxla6mmallmldb=nteethipxla6mmURmldb+nteethipxla6mmULmldb+nteethipxla6mmLLmldb+nteethipxla6mmLRmldb;
	nteethipxla6mmallall=nteethipxla6mmURall+nteethipxla6mmULall+nteethipxla6mmLLall+nteethipxla6mmLRall;

	nteethipxpc5mmallmb=nteethipxpc5mmURmb+nteethipxpc5mmULmb+nteethipxpc5mmLLmb+nteethipxpc5mmLRmb;
	nteethipxpc5mmallml=nteethipxpc5mmURml+nteethipxpc5mmULml+nteethipxpc5mmLLml+nteethipxpc5mmLRml;
	nteethipxpc5mmalldb=nteethipxpc5mmURdb+nteethipxpc5mmULdb+nteethipxpc5mmLLdb+nteethipxpc5mmLRdb;
	nteethipxpc5mmalldl=nteethipxpc5mmURdl+nteethipxpc5mmULdl+nteethipxpc5mmLLdl+nteethipxpc5mmLRdl;
	nteethipxpc5mmallmbml=nteethipxpc5mmURmbml+nteethipxpc5mmULmbml+nteethipxpc5mmLLmbml+nteethipxpc5mmLRmbml;
	nteethipxpc5mmalldbdl=nteethipxpc5mmURdbdl+nteethipxpc5mmULdbdl+nteethipxpc5mmLLdbdl+nteethipxpc5mmLRdbdl;
	nteethipxpc5mmallmbdb=nteethipxpc5mmURmbdb+nteethipxpc5mmULmbdb+nteethipxpc5mmLLmbdb+nteethipxpc5mmLRmbdb;
	nteethipxpc5mmallmldl=nteethipxpc5mmURmldl+nteethipxpc5mmULmldl+nteethipxpc5mmLLmldl+nteethipxpc5mmLRmldl;
	nteethipxpc5mmallmbdl=nteethipxpc5mmURmbdl+nteethipxpc5mmULmbdl+nteethipxpc5mmLLmbdl+nteethipxpc5mmLRmbdl;
	nteethipxpc5mmallmldb=nteethipxpc5mmURmldb+nteethipxpc5mmULmldb+nteethipxpc5mmLLmldb+nteethipxpc5mmLRmldb;
	nteethipxpc5mmallall=nteethipxpc5mmURall+nteethipxpc5mmULall+nteethipxpc5mmLLall+nteethipxpc5mmLRall;

	if nteethipxla6mmallmb>=2 AND nteethipxpc5mmallmb>=1 then periostatusallmb=3;
	if nteethipxla6mmallml>=2 AND nteethipxpc5mmallml>=1 then periostatusallml=3;
	if nteethipxla6mmalldb>=2 AND nteethipxpc5mmalldb>=1 then periostatusalldb=3;
	if nteethipxla6mmalldl>=2 AND nteethipxpc5mmalldl>=1 then periostatusalldl=3;
	if nteethipxla6mmallmbml>=2 AND nteethipxpc5mmallmbml>=1 then periostatusallmbml=3;
	if nteethipxla6mmalldbdl>=2 AND nteethipxpc5mmalldbdl>=1 then periostatusalldbdl=3;
	if nteethipxla6mmallmbdb>=2 AND nteethipxpc5mmallmbdb>=1 then periostatusallmbdb=3;
	if nteethipxla6mmallmldl>=2 AND nteethipxpc5mmallmldl>=1 then periostatusallmldl=3;
	if nteethipxla6mmallmbdl>=2 AND nteethipxpc5mmallmbdl>=1 then periostatusallmbdl=3;
	if nteethipxla6mmallmldb>=2 AND nteethipxpc5mmallmldb>=1 then periostatusallmldb=3;
	if nteethipxla6mmallall>=2 AND nteethipxpc5mmallall>=1 then periostatusallall=3;
	run;

/*Checking if coding of nteeth with CAL>=6mm or PD>=5mm were correctly coded for different combinations of quadrants
and sites*/
/*UR and LL*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmURmb nteethipxla6mmLLmb nteethipxla6mmURLLmb
		 	nteethipxpc5mmURmb nteethipxpc5mmLLmb nteethipxpc5mmURLLmb periostatusURLLmb
			nteethipxla6mmURml nteethipxla6mmLLml nteethipxla6mmURLLml
		 	nteethipxpc5mmURml nteethipxpc5mmLLml nteethipxpc5mmURLLml periostatusURLLml
			nteethipxla6mmURdb nteethipxla6mmLLdb nteethipxla6mmURLLdb
		 	nteethipxpc5mmURdb nteethipxpc5mmLLdb nteethipxpc5mmURLLdb periostatusURLLdb
			nteethipxla6mmURdl nteethipxla6mmLLdl nteethipxla6mmURLLdl
		 	nteethipxpc5mmURdl nteethipxpc5mmLLdl nteethipxpc5mmURLLdl periostatusURLLdl
			nteethipxla6mmURmbml nteethipxla6mmLLmbml nteethipxla6mmURLLmbml
		 	nteethipxpc5mmURmbml nteethipxpc5mmLLmbml nteethipxpc5mmURLLmbml periostatusURLLmbml
			nteethipxla6mmURdbdl nteethipxla6mmLLdbdl nteethipxla6mmURLLdbdl
		 	nteethipxpc5mmURdbdl nteethipxpc5mmLLdbdl nteethipxpc5mmURLLdbdl periostatusURLLdbdl
			nteethipxla6mmURmbdb nteethipxla6mmLLmbdb nteethipxla6mmURLLmbdb
		 	nteethipxpc5mmURmbdb nteethipxpc5mmLLmbdb nteethipxpc5mmURLLmbdb periostatusURLLmbdb
			nteethipxla6mmURmldl nteethipxla6mmLLmldl nteethipxla6mmURLLmldl
		 	nteethipxpc5mmURmldl nteethipxpc5mmLLmldl nteethipxpc5mmURLLmldl periostatusURLLmldl
			nteethipxla6mmURmbdl nteethipxla6mmLLmbdl nteethipxla6mmURLLmbdl
		 	nteethipxpc5mmURmbdl nteethipxpc5mmLLmbdl nteethipxpc5mmURLLmbdl periostatusURLLmbdl
			nteethipxla6mmURmldb nteethipxla6mmLLmldb nteethipxla6mmURLLmldb
		 	nteethipxpc5mmURmldb nteethipxpc5mmLLmldb nteethipxpc5mmURLLmldb periostatusURLLmldb
			nteethipxla6mmURall nteethipxla6mmLLall nteethipxla6mmURLLall
		 	nteethipxpc5mmURall nteethipxpc5mmLLall nteethipxpc5mmURLLall periostatusURLLall;
			run;

/*UR and LR*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmURmb nteethipxla6mmLRmb nteethipxla6mmURLRmb
		 	nteethipxpc5mmURmb nteethipxpc5mmLRmb nteethipxpc5mmURLRmb periostatusURLRmb
			nteethipxla6mmURml nteethipxla6mmLRml nteethipxla6mmURLRml
		 	nteethipxpc5mmURml nteethipxpc5mmLRml nteethipxpc5mmURLRml periostatusURLRml
			nteethipxla6mmURdb nteethipxla6mmLRdb nteethipxla6mmURLRdb
		 	nteethipxpc5mmURdb nteethipxpc5mmLRdb nteethipxpc5mmURLRdb periostatusURLRdb
			nteethipxla6mmURdl nteethipxla6mmLRdl nteethipxla6mmURLRdl
		 	nteethipxpc5mmURdl nteethipxpc5mmLRdl nteethipxpc5mmURLRdl periostatusURLRdl
			nteethipxla6mmURmbml nteethipxla6mmLRmbml nteethipxla6mmURLRmbml
		 	nteethipxpc5mmURmbml nteethipxpc5mmLRmbml nteethipxpc5mmURLRmbml periostatusURLRmbml
			nteethipxla6mmURdbdl nteethipxla6mmLRdbdl nteethipxla6mmURLRdbdl
		 	nteethipxpc5mmURdbdl nteethipxpc5mmLRdbdl nteethipxpc5mmURLRdbdl periostatusURLRdbdl
			nteethipxla6mmURmbdb nteethipxla6mmLRmbdb nteethipxla6mmURLRmbdb
		 	nteethipxpc5mmURmbdb nteethipxpc5mmLRmbdb nteethipxpc5mmURLRmbdb periostatusURLRmbdb
			nteethipxla6mmURmldl nteethipxla6mmLRmldl nteethipxla6mmURLRmldl
		 	nteethipxpc5mmURmldl nteethipxpc5mmLRmldl nteethipxpc5mmURLRmldl periostatusURLRmldl
			nteethipxla6mmURmbdl nteethipxla6mmLRmbdl nteethipxla6mmURLRmbdl
		 	nteethipxpc5mmURmbdl nteethipxpc5mmLRmbdl nteethipxpc5mmURLRmbdl periostatusURLRmbdl
			nteethipxla6mmURmldb nteethipxla6mmLRmldb nteethipxla6mmURLRmldb
		 	nteethipxpc5mmURmldb nteethipxpc5mmLRmldb nteethipxpc5mmURLRmldb periostatusURLRmldb
			nteethipxla6mmURall nteethipxla6mmLRall nteethipxla6mmURLRall
		 	nteethipxpc5mmURall nteethipxpc5mmLRall nteethipxpc5mmURLRall periostatusURLRall;
			run;

/*UR and UL*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmURmb nteethipxla6mmULmb nteethipxla6mmURULmb
		 	nteethipxpc5mmURmb nteethipxpc5mmULmb nteethipxpc5mmURULmb periostatusURULmb
			nteethipxla6mmURml nteethipxla6mmULml nteethipxla6mmURULml
		 	nteethipxpc5mmURml nteethipxpc5mmULml nteethipxpc5mmURULml periostatusURULml
			nteethipxla6mmURdb nteethipxla6mmULdb nteethipxla6mmURULdb
		 	nteethipxpc5mmURdb nteethipxpc5mmULdb nteethipxpc5mmURULdb periostatusURULdb
			nteethipxla6mmURdl nteethipxla6mmULdl nteethipxla6mmURULdl
		 	nteethipxpc5mmURdl nteethipxpc5mmULdl nteethipxpc5mmURULdl periostatusURULdl
			nteethipxla6mmURmbml nteethipxla6mmULmbml nteethipxla6mmURULmbml
		 	nteethipxpc5mmURmbml nteethipxpc5mmULmbml nteethipxpc5mmURULmbml periostatusURULmbml
			nteethipxla6mmURdbdl nteethipxla6mmULdbdl nteethipxla6mmURULdbdl
		 	nteethipxpc5mmURdbdl nteethipxpc5mmULdbdl nteethipxpc5mmURULdbdl periostatusURULdbdl
			nteethipxla6mmURmbdb nteethipxla6mmULmbdb nteethipxla6mmURULmbdb
		 	nteethipxpc5mmURmbdb nteethipxpc5mmULmbdb nteethipxpc5mmURULmbdb periostatusURULmbdb
			nteethipxla6mmURmldl nteethipxla6mmULmldl nteethipxla6mmURULmldl
		 	nteethipxpc5mmURmldl nteethipxpc5mmULmldl nteethipxpc5mmURULmldl periostatusURULmldl
			nteethipxla6mmURmbdl nteethipxla6mmULmbdl nteethipxla6mmURULmbdl
		 	nteethipxpc5mmURmbdl nteethipxpc5mmULmbdl nteethipxpc5mmURULmbdl periostatusURULmbdl
			nteethipxla6mmURmldb nteethipxla6mmULmldb nteethipxla6mmURULmldb
		 	nteethipxpc5mmURmldb nteethipxpc5mmULmldb nteethipxpc5mmURULmldb periostatusURULmldb
			nteethipxla6mmURall nteethipxla6mmULall nteethipxla6mmURULall
		 	nteethipxpc5mmURall nteethipxpc5mmULall nteethipxpc5mmURULall periostatusURULall;
			run;

/*UL and LR*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmULmb nteethipxla6mmLRmb nteethipxla6mmULLRmb
		 	nteethipxpc5mmULmb nteethipxpc5mmLRmb nteethipxpc5mmULLRmb periostatusULLRmb
			nteethipxla6mmULml nteethipxla6mmLRml nteethipxla6mmULLRml
		 	nteethipxpc5mmULml nteethipxpc5mmLRml nteethipxpc5mmULLRml periostatusULLRml
			nteethipxla6mmULdb nteethipxla6mmLRdb nteethipxla6mmULLRdb
		 	nteethipxpc5mmULdb nteethipxpc5mmLRdb nteethipxpc5mmULLRdb periostatusULLRdb
			nteethipxla6mmULdl nteethipxla6mmLRdl nteethipxla6mmULLRdl
		 	nteethipxpc5mmULdl nteethipxpc5mmLRdl nteethipxpc5mmULLRdl periostatusULLRdl
			nteethipxla6mmULmbml nteethipxla6mmLRmbml nteethipxla6mmULLRmbml
		 	nteethipxpc5mmULmbml nteethipxpc5mmLRmbml nteethipxpc5mmULLRmbml periostatusULLRmbml
			nteethipxla6mmULdbdl nteethipxla6mmLRdbdl nteethipxla6mmULLRdbdl
		 	nteethipxpc5mmULdbdl nteethipxpc5mmLRdbdl nteethipxpc5mmULLRdbdl periostatusULLRdbdl
			nteethipxla6mmULmbdb nteethipxla6mmLRmbdb nteethipxla6mmULLRmbdb
		 	nteethipxpc5mmULmbdb nteethipxpc5mmLRmbdb nteethipxpc5mmULLRmbdb periostatusULLRmbdb
			nteethipxla6mmULmldl nteethipxla6mmLRmldl nteethipxla6mmULLRmldl
		 	nteethipxpc5mmULmldl nteethipxpc5mmLRmldl nteethipxpc5mmULLRmldl periostatusULLRmldl
			nteethipxla6mmULmbdl nteethipxla6mmLRmbdl nteethipxla6mmULLRmbdl
		 	nteethipxpc5mmULmbdl nteethipxpc5mmLRmbdl nteethipxpc5mmULLRmbdl periostatusULLRmbdl
			nteethipxla6mmULmldb nteethipxla6mmLRmldb nteethipxla6mmULLRmldb
		 	nteethipxpc5mmULmldb nteethipxpc5mmLRmldb nteethipxpc5mmULLRmldb periostatusULLRmldb
			nteethipxla6mmULall nteethipxla6mmLRall nteethipxla6mmULLRall
		 	nteethipxpc5mmULall nteethipxpc5mmLRall nteethipxpc5mmULLRall periostatusULLRall;
			run;

/*UL and LL*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmULmb nteethipxla6mmLLmb nteethipxla6mmULLLmb
		 	nteethipxpc5mmULmb nteethipxpc5mmLLmb nteethipxpc5mmULLLmb periostatusULLLmb
			nteethipxla6mmULml nteethipxla6mmLLml nteethipxla6mmULLLml
		 	nteethipxpc5mmULml nteethipxpc5mmLLml nteethipxpc5mmULLLml periostatusULLLml
			nteethipxla6mmULdb nteethipxla6mmLLdb nteethipxla6mmULLLdb
		 	nteethipxpc5mmULdb nteethipxpc5mmLLdb nteethipxpc5mmULLLdb periostatusULLLdb
			nteethipxla6mmULdl nteethipxla6mmLLdl nteethipxla6mmULLLdl
		 	nteethipxpc5mmULdl nteethipxpc5mmLLdl nteethipxpc5mmULLLdl periostatusULLLdl
			nteethipxla6mmULmbml nteethipxla6mmLLmbml nteethipxla6mmULLLmbml
		 	nteethipxpc5mmULmbml nteethipxpc5mmLLmbml nteethipxpc5mmULLLmbml periostatusULLLmbml
			nteethipxla6mmULdbdl nteethipxla6mmLLdbdl nteethipxla6mmULLLdbdl
		 	nteethipxpc5mmULdbdl nteethipxpc5mmLLdbdl nteethipxpc5mmULLLdbdl periostatusULLLdbdl
			nteethipxla6mmULmbdb nteethipxla6mmLLmbdb nteethipxla6mmULLLmbdb
		 	nteethipxpc5mmULmbdb nteethipxpc5mmLLmbdb nteethipxpc5mmULLLmbdb periostatusULLLmbdb
			nteethipxla6mmULmldl nteethipxla6mmLLmldl nteethipxla6mmULLLmldl
		 	nteethipxpc5mmULmldl nteethipxpc5mmLLmldl nteethipxpc5mmULLLmldl periostatusULLLmldl
			nteethipxla6mmULmbdl nteethipxla6mmLLmbdl nteethipxla6mmULLLmbdl
		 	nteethipxpc5mmULmbdl nteethipxpc5mmLLmbdl nteethipxpc5mmULLLmbdl periostatusULLLmbdl
			nteethipxla6mmULmldb nteethipxla6mmLLmldb nteethipxla6mmULLLmldb
		 	nteethipxpc5mmULmldb nteethipxpc5mmLLmldb nteethipxpc5mmULLLmldb periostatusULLLmldb
			nteethipxla6mmULall nteethipxla6mmLLall nteethipxla6mmULLLall
		 	nteethipxpc5mmULall nteethipxpc5mmLLall nteethipxpc5mmULLLall periostatusULLLall;
			run;

/*LL and LR*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmLLmb nteethipxla6mmLRmb nteethipxla6mmLLLRmb
		 	nteethipxpc5mmLLmb nteethipxpc5mmLRmb nteethipxpc5mmLLLRmb periostatusLLLRmb
			nteethipxla6mmLLml nteethipxla6mmLRml nteethipxla6mmLLLRml
		 	nteethipxpc5mmLLml nteethipxpc5mmLRml nteethipxpc5mmLLLRml periostatusLLLRml
			nteethipxla6mmLLdb nteethipxla6mmLRdb nteethipxla6mmLLLRdb
		 	nteethipxpc5mmLLdb nteethipxpc5mmLRdb nteethipxpc5mmLLLRdb periostatusLLLRdb
			nteethipxla6mmLLdl nteethipxla6mmLRdl nteethipxla6mmLLLRdl
		 	nteethipxpc5mmLLdl nteethipxpc5mmLRdl nteethipxpc5mmLLLRdl periostatusLLLRdl
			nteethipxla6mmLLmbml nteethipxla6mmLRmbml nteethipxla6mmLLLRmbml
		 	nteethipxpc5mmLLmbml nteethipxpc5mmLRmbml nteethipxpc5mmLLLRmbml periostatusLLLRmbml
			nteethipxla6mmLLdbdl nteethipxla6mmLRdbdl nteethipxla6mmLLLRdbdl
		 	nteethipxpc5mmLLdbdl nteethipxpc5mmLRdbdl nteethipxpc5mmLLLRdbdl periostatusLLLRdbdl
			nteethipxla6mmLLmbdb nteethipxla6mmLRmbdb nteethipxla6mmLLLRmbdb
		 	nteethipxpc5mmLLmbdb nteethipxpc5mmLRmbdb nteethipxpc5mmLLLRmbdb periostatusLLLRmbdb
			nteethipxla6mmLLmldl nteethipxla6mmLRmldl nteethipxla6mmLLLRmldl
		 	nteethipxpc5mmLLmldl nteethipxpc5mmLRmldl nteethipxpc5mmLLLRmldl periostatusLLLRmldl
			nteethipxla6mmLLmbdl nteethipxla6mmLRmbdl nteethipxla6mmLLLRmbdl
		 	nteethipxpc5mmLLmbdl nteethipxpc5mmLRmbdl nteethipxpc5mmLLLRmbdl periostatusLLLRmbdl
			nteethipxla6mmLLmldb nteethipxla6mmLRmldb nteethipxla6mmLLLRmldb
		 	nteethipxpc5mmLLmldb nteethipxpc5mmLRmldb nteethipxpc5mmLLLRmldb periostatusLLLRmldb
			nteethipxla6mmLLall nteethipxla6mmLRall nteethipxla6mmLLLRall
		 	nteethipxpc5mmLLall nteethipxpc5mmLRall nteethipxpc5mmLLLRall periostatusLLLRall;
			run;

/*All*/
proc print data=combquad (obs=100);
var SEQN	nteethipxla6mmURmb nteethipxla6mmULmb nteethipxla6mmLLmb nteethipxla6mmLRmb nteethipxla6mmallmb
		 	nteethipxpc5mmURmb nteethipxpc5mmULmb nteethipxpc5mmLLmb nteethipxpc5mmLRmb nteethipxpc5mmallmb
			periostatusallmb
			nteethipxla6mmURml nteethipxla6mmULml nteethipxla6mmLLml nteethipxla6mmLRml nteethipxla6mmallml
		 	nteethipxpc5mmURml nteethipxpc5mmULml nteethipxpc5mmLLml nteethipxpc5mmLRml nteethipxpc5mmallml 
			periostatusallml
			nteethipxla6mmURdb nteethipxla6mmULdb nteethipxla6mmLLdb nteethipxla6mmLRdb nteethipxla6mmalldb
		 	nteethipxpc5mmURdb nteethipxpc5mmULdb nteethipxpc5mmLLdb nteethipxpc5mmLRdb nteethipxpc5mmalldb 
			periostatusalldb
			nteethipxla6mmURdl nteethipxla6mmULdl nteethipxla6mmLLdl nteethipxla6mmLRdl nteethipxla6mmalldl
		 	nteethipxpc5mmURdl nteethipxpc5mmULdl nteethipxpc5mmLLdl nteethipxpc5mmLRdl nteethipxpc5mmalldl 
			periostatusalldl
			nteethipxla6mmURmbml nteethipxla6mmULmbml nteethipxla6mmLLmbml nteethipxla6mmLRmbml nteethipxla6mmallmbml
		 	nteethipxpc5mmURmbml nteethipxpc5mmULmbml nteethipxpc5mmLLmbml nteethipxpc5mmLRmbml nteethipxpc5mmallmbml 
			periostatusallmbml
			nteethipxla6mmURdbdl nteethipxla6mmULdbdl nteethipxla6mmLLdbdl nteethipxla6mmLRdbdl nteethipxla6mmalldbdl
		 	nteethipxpc5mmURdbdl nteethipxpc5mmULdbdl nteethipxpc5mmLLdbdl nteethipxpc5mmLRdbdl nteethipxpc5mmalldbdl 
			periostatusalldbdl
			nteethipxla6mmURmbdb nteethipxla6mmULmbdb nteethipxla6mmLLmbdb nteethipxla6mmLRmbdb nteethipxla6mmallmbdb
		 	nteethipxpc5mmURmbdb nteethipxpc5mmULmbdb nteethipxpc5mmLLmbdb nteethipxpc5mmLRmbdb nteethipxpc5mmallmbdb 
			periostatusallmbdb
			nteethipxla6mmURmldl nteethipxla6mmULmldl nteethipxla6mmLLmldl nteethipxla6mmLRmldl nteethipxla6mmallmldl
		 	nteethipxpc5mmURmldl nteethipxpc5mmULmldl nteethipxpc5mmLLmldl nteethipxpc5mmLRmldl nteethipxpc5mmallmldl 
			periostatusallmldl
			nteethipxla6mmURmbdl nteethipxla6mmULmbdl nteethipxla6mmLLmbdl nteethipxla6mmLRmbdl nteethipxla6mmallmbdl
		 	nteethipxpc5mmURmbdl nteethipxpc5mmULmbdl nteethipxpc5mmLLmbdl nteethipxpc5mmLRmbdl nteethipxpc5mmallmbdl 
			periostatusallmbdl
			nteethipxla6mmURmldb nteethipxla6mmULmldb nteethipxla6mmLLmldb nteethipxla6mmLRmldb nteethipxla6mmallmldb
		 	nteethipxpc5mmURmldb nteethipxpc5mmULmldb nteethipxpc5mmLLmldb nteethipxpc5mmLRmldb nteethipxpc5mmallmldb 
			periostatusallmldb
			nteethipxla6mmURall nteethipxla6mmULall nteethipxla6mmLLall nteethipxla6mmLRall nteethipxla6mmallall
		 	nteethipxpc5mmURall nteethipxpc5mmULall nteethipxpc5mmLLall nteethipxpc5mmLRall nteethipxpc5mmallall 
			periostatusallall;
			run;

/*Getting sensitivity estimates for detecting severe periodontitis according to Eke et al defintion*/
/*UR and LL sensitivity estimates*/
proc freq data=combquad;
tables (periostatusURLLmb periostatusURLLml periostatusURLLdb periostatusURLLdl
		periostatusURLLmbml periostatusURLLdbdl periostatusURLLmbdb periostatusURLLmldl periostatusURLLmbdl
		periostatusURLLmldb periostatusURLLall)*periostatus/missing nopercent norow;
run;

/*UR and LR sensitivity estimates*/
proc freq data=combquad;
tables (periostatusURLRmb periostatusURLRml periostatusURLRdb periostatusURLRdl
		periostatusURLRmbml periostatusURLRdbdl periostatusURLRmbdb periostatusURLRmldl periostatusURLRmbdl
		periostatusURLRmldb periostatusURLRall)*periostatus/missing nopercent norow;
run;

/*UR and UL sensitivity estimates*/
proc freq data=combquad;
tables (periostatusURULmb periostatusURULml periostatusURULdb periostatusURULdl
		periostatusURULmbml periostatusURULdbdl periostatusURULmbdb periostatusURULmldl periostatusURULmbdl
		periostatusURULmldb periostatusURULall)*periostatus/missing nopercent norow;
run;

/*UL and LR sensitivity estimates*/
proc freq data=combquad;
tables (periostatusULLRmb periostatusULLRml periostatusULLRdb periostatusULLRdl
		periostatusULLRmbml periostatusULLRdbdl periostatusULLRmbdb periostatusULLRmldl periostatusULLRmbdl
		periostatusULLRmldb periostatusULLRall)*periostatus/missing nopercent norow;
run;

/*UL and LL sensitivity estimates*/
proc freq data=combquad;
tables (periostatusULLLmb periostatusULLLml periostatusULLLdb periostatusULLLdl
		periostatusULLLmbml periostatusULLLdbdl periostatusULLLmbdb periostatusULLLmldl periostatusULLLmbdl
		periostatusULLLmldb periostatusULLLall)*periostatus/missing nopercent norow;
run;

/*LL and LR sensitivity estimates*/
proc freq data=combquad;
tables (periostatusLLLRmb periostatusLLLRml periostatusLLLRdb periostatusLLLRdl
		periostatusLLLRmbml periostatusLLLRdbdl periostatusLLLRmbdb periostatusLLLRmldl periostatusLLLRmbdl
		periostatusLLLRmldb periostatusLLLRall)*periostatus/missing nopercent norow;
run;

/*All quadrants sensitivity estimates*/
proc freq data=combquad;
tables (periostatusallmb periostatusallml periostatusalldb periostatusalldl
		periostatusallmbml periostatusalldbdl periostatusallmbdb periostatusallmldl periostatusallmbdl
		periostatusallmldb periostatusallall)*periostatus/missing nopercent norow;
run;

/*Saving the combquad as a permanent dataset to produce a figure in another code (Figure S1)*/
data part.combquad;
	set combquad;
	run;

/**************************************************************************************************************/
/* Code Section 7 - Reproducing Table 3. Mean of mean numbers of teeth with specified clinical severity
according to concordance of disease determinations from partial-mouth protocols and full-mouth protocols
with 1000 iterations of random assignment to half-mouth*/ 
/**************************************************************************************************************/

/*Printing the log into a notepad document called text to avoid having to have uninterrupted run of the siumlation
as apposed to having to clean the log everytime it is full*/
proc printto log=text;run;

/*A macro for assigning indivudals to either upper right and lower left quadrants or to upper left and lower right
quadrants*/
%macro randomMRML_MLMR(data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11);
data concdisc;
	set one;
	/*Assignment to either upper right and lower left or upper left and lower right
	  If Benrnoulli var is 1 then URLL
	  if Benrnoulli var is 0 then ULLR*/
	assign=ranbin(-1,1,0.5);
	/*Upper right and lower left*/
	/*Tooth count*/
	array toothURLL	(14)	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
							OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC;
	toothcountURLL=0;
	do i=1 to 14;
	if toothURLL(i)=2 then toothcountURLL=toothcountURLL+1;
	end;
	drop i;
	/*CDC/AAP*/
	array lasURLLall (14)		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las
								ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array laaURLLall (14) 		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa
								ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array ladURLLall (14)		ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
								ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array lapURLLall (14)		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap
								ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array laxURLLall (14) 		ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
								ohx07maxlaURLLall ohx08maxlaURLLall
								ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall ohx21maxlaURLLall ohx22maxlaURLLall
							ohx23maxlaURLLall ohx24maxlaURLLall;
	do count=1 to 14; laxURLLall(count)=max(of lasURLLall(count),laaURLLall(count), ladURLLall(count),lapURLLall(count));
	end;
	drop count;
	array pcsURLLall (14)		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
								ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;
	array pcaURLLall (14) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
								ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;
	array pcdURLLall (14)		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
								ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;
	array pcpURLLall (14)		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
								ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;
	array pcxURLLall (14) 		ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
								ohx07maxpcURLLall ohx08maxpcURLLall
								ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall ohx21maxpcURLLall ohx22maxpcURLLall
							ohx23maxpcURLLall ohx24maxpcURLLall;
	do count=1 to 14; pcxURLLall(count)=max(of pcsURLLall(count),pcaURLLall(count), pcdURLLall(count),pcpURLLall(count));
	end;
	drop count;
	/* Define periodontal disease using Eke 2012 definition*/
	/* set Periostatus to 0*/
	periostatusURLLall=0;
	/* Severe periodontitis: >=2 interproximal sites with LOA >=6 mm (not on same tooth) and >=1 interproximal
	site with PD >=5 mm*/
	/* Set tooth counts=0*/
	nteethipxla6mmURLLall=0;
	nteethipxpc5mmURLLall=0;
	do count=1 to 14; 
	if laxURLLall(count) ge 6 then nteethipxla6mmURLLall=nteethipxla6mmURLLall+1;
	if pcxURLLall(count) ge 5 then nteethipxpc5mmURLLall=nteethipxpc5mmURLLall+1;
	end; 
	if nteethipxla6mmURLLall>=2 AND nteethipxpc5mmURLLall>=1 then periostatusURLLall=3; /*Severe perio*/
	/* Moderate periodontitis: >=2 interproximal sites with LOA >=4 mm (not on same tooth), or >=2 interproximal
	sites with PD>=5 mm
	(not on same tooth)*/
	IF PERIOSTATUSURLLall=0 THEN  DO;
	nteethipxla4mmURLLall=0;
	do count=1 to 14; if laxURLLall(count) ge 4 then nteethipxla4mmURLLall=nteethipxla4mmURLLall+1; end;
	if nteethipxla4mmURLLall>=2 OR nteethipxpc5mmURLLall>=2 then periostatusURLLall=2; /*Moderate perio*/
	END;
	/* Mild periodontitis: >=2 interproximal sites with LOA >=3 mm, and >=2 interproximal sites with PD >=4 mm
	(not on same tooth) or one site with PD >=5 mm*/
	IF PERIOSTATUSURLLall=0 THEN  DO;
	nsitesipxloa3mmURLLall=0;
	nteethipxpc4mmURLLall=0;
	do count=1 to 14; if ladURLLall(count) ge 3 then nsitesipxloa3mmURLLall=nsitesipxloa3mmURLLall+1; 
	if lasURLLall(count) ge 3 then nsitesipxloa3mmURLLall=nsitesipxloa3mmURLLall+1; 
		 if lapURLLall(count) ge 3 then nsitesipxloa3mmURLLall=nsitesipxloa3mmURLLall+1; 
		if laaURLLall(count) ge 3 then nsitesipxloa3mmURLLall=nsitesipxloa3mmURLLall+1; end;
	do count=1 to 14; if pcxURLLall(count) ge 4 then nteethipxpc4mmURLLall=nteethipxpc4mmURLLall+1; end;
	if nsitesipxloa3mmURLLall>=2 AND (nteethipxpc4mmURLLall>=2 OR nteethipxpc5mmURLLall=1) then periostatusURLLall=1;
	/*Mild perio*/
	END;
	/*Calculating mean CAL and mean PD in each protocol*/
	meancalURLL=mean (of 	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad 
							ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 			
							ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las
							ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
							ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap  
							ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
							ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
							ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa);
	meanpdURLL=mean(of 		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
							ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 
							ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
							ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 
							ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp 
							ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
							ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca  
							ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca);
	/*Upper left and lower right*/
	/*Tooth count*/
	array toothULLR	(14)	OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
							OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;
	toothcountULLR=0;
	do i=1 to 14;
	if toothULLR(i)=2 then toothcountULLR=toothcountULLR+1;
	end;
	drop i;
	/*CDC/AAP*/
	array lasULLRall (14)		ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las
								ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array laaULLRall (14) 		ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa
								ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array ladULLRall (14)		ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad
								ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array lapULLRall (14)		ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap
								ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array laxULLRall (14) ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
						ohx14maxlaULLRall ohx15maxlaULLRall
							ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall ohx28maxlaULLRall ohx29maxlaULLRall
						ohx30maxlaULLRall ohx31maxlaULLRall;
	do count=1 to 14; laxULLRall(count)=max(of lasULLRall(count),laaULLRall(count), ladULLRall(count),lapULLRall(count));
	end;
	drop count;
	array pcsULLRall (14)		ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs
								ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;
	array pcaULLRall (14) 		ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca
								ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
	array pcdULLRall (14)		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd
								ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;
	array pcpULLRall (14)		ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp
								ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;
	array pcxULLRall (14) ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
						ohx14maxpcULLRall ohx15maxpcULLRall
							ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall ohx28maxpcULLRall ohx29maxpcULLRall
						ohx30maxpcULLRall ohx31maxpcULLRall;
	do count=1 to 14; pcxULLRall(count)=max(of pcsULLRall(count),pcaULLRall(count), pcdULLRall(count),pcpULLRall(count));
	end;
	drop count;
	/* Define periodontal disease using Eke 2012 definition*/
	/* set Periostatus to 0*/
	periostatusULLRall=0;
	/* Severe periodontitis: >=2 interproximal sites with LOA >=6 mm (not on same tooth) and >=1 interproximal
	site with PD >=5 mm*/
	/* Set tooth counts=0*/
	nteethipxla6mmULLRall=0;
	nteethipxpc5mmULLRall=0;
	do count=1 to 14; 
	if laxULLRall(count) ge 6 then nteethipxla6mmULLRall=nteethipxla6mmULLRall+1;
	if pcxULLRall(count) ge 5 then nteethipxpc5mmULLRall=nteethipxpc5mmULLRall+1;
	end; 
	if nteethipxla6mmULLRall>=2 AND nteethipxpc5mmULLRall>=1 then periostatusULLRall=3; /*Severe perio*/
	/* Moderate periodontitis: >=2 interproximal sites with LOA >=4 mm (not on same tooth), or >=2 interproximal
	sites with PD>=5 mm
	(not on same tooth)*/
	IF PERIOSTATUSULLRall=0 THEN  DO;
	nteethipxla4mmULLRall=0;
	do count=1 to 14; if laxULLRall(count) ge 4 then nteethipxla4mmULLRall=nteethipxla4mmULLRall+1; end;
	if nteethipxla4mmULLRall>=2 OR nteethipxpc5mmULLRall>=2 then periostatusULLRall=2; /*Moderate perio*/
	END;
	/* Mild periodontitis: >=2 interproximal sites with LOA >=3 mm, and >=2 interproximal sites with PD >=4 mm
	(not on same tooth) or one site with PD >=5 mm*/
	IF PERIOSTATUSULLRall=0 THEN  DO;
	nsitesipxloa3mmULLRall=0;
	nteethipxpc4mmULLRall=0;
	do count=1 to 14; if ladULLRall(count) ge 3 then nsitesipxloa3mmULLRall=nsitesipxloa3mmULLRall+1; 
	if lasULLRall(count) ge 3 then nsitesipxloa3mmULLRall=nsitesipxloa3mmULLRall+1; 
		 if lapULLRall(count) ge 3 then nsitesipxloa3mmULLRall=nsitesipxloa3mmULLRall+1; 
		if laaULLRall(count) ge 3 then nsitesipxloa3mmULLRall=nsitesipxloa3mmULLRall+1; end;
	do count=1 to 14; if pcxULLRall(count) ge 4 then nteethipxpc4mmULLRall=nteethipxpc4mmULLRall+1; end;
	if nsitesipxloa3mmULLRall>=2 AND (nteethipxpc4mmULLRall>=2 OR nteethipxpc5mmULLRall=1) then periostatusULLRall=1;
	/*Mild perio*/
	END;
	/*Calculating mean CAL and mean PD in each protocol*/
	meancalULLR=mean (of	ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
							ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
							ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
							ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
							ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
							ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
							ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
							ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa);
	meanpdULLR=mean(of 		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
							ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd
							ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
							ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs
							ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
							ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp
							ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca 
							ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca);
	nteeth3cal=0;
	nteeth4cal=0;
	nteeth5cal=0;
	nteeth6cal=0;
	nteeth7cal=0;
	nteeth3pd=0;
	nteeth4pd=0;
	nteeth5pd=0;
	nteeth6pd=0;
	nteeth7pd=0;
	if assign=1 then do;
	periostatusRHM=periostatusURLLall;
	toothcountRHM=toothcountURLL;
	meancalRHM=meancalURLL;
	meanpdRHM=meanpdURLL;
	do count=1 to 14;
	if laxURLLall(count) ge 3 then nteeth3cal=nteeth3cal+1;
	if laxURLLall(count) ge 4 then nteeth4cal=nteeth4cal+1;
	if laxURLLall(count) ge 5 then nteeth5cal=nteeth5cal+1;
	if laxURLLall(count) ge 6 then nteeth6cal=nteeth6cal+1;
	if laxURLLall(count) ge 7 then nteeth7cal=nteeth7cal+1;
	if pcxURLLall(count) ge 3 then nteeth3pd=nteeth3pd+1;
	if pcxURLLall(count) ge 4 then nteeth4pd=nteeth4pd+1;
	if pcxURLLall(count) ge 5 then nteeth5pd=nteeth5pd+1;
	if pcxURLLall(count) ge 6 then nteeth6pd=nteeth6pd+1;
	if pcxURLLall(count) ge 7 then nteeth7pd=nteeth7pd+1;
	end;
	end;
	if assign=0 then do;
	periostatusRHM=periostatusULLRall;
	toothcountRHM=toothcountULLR;
	meancalRHM=meancalULLR;
	meanpdRHM=meanpdULLR;
	do count=1 to 14;
	if laxULLRall(count) ge 3 then nteeth3cal=nteeth3cal+1;
	if laxULLRall(count) ge 4 then nteeth4cal=nteeth4cal+1;
	if laxULLRall(count) ge 5 then nteeth5cal=nteeth5cal+1;
	if laxULLRall(count) ge 6 then nteeth6cal=nteeth6cal+1;
	if laxULLRall(count) ge 7 then nteeth7cal=nteeth7cal+1;
	if pcxULLRall(count) ge 3 then nteeth3pd=nteeth3pd+1;
	if pcxULLRall(count) ge 4 then nteeth4pd=nteeth4pd+1;
	if pcxULLRall(count) ge 5 then nteeth5pd=nteeth5pd+1;
	if pcxULLRall(count) ge 6 then nteeth6pd=nteeth6pd+1;
	if pcxULLRall(count) ge 7 then nteeth7pd=nteeth7pd+1;
	end;
	end;
	/* Calculating concordant and discorant pairs between random half-mouth protocol and full-mouth
	for 2012 CDC/AAP*/
	if periostatus ne . then do;
	if periostatus=3 and periostatusRHM=3 then conc_disc_severe='conc severe';
	if periostatus=3 and periostatusRHM lt 3 then conc_disc_severe='disc severe';
	if periostatus lt 3 and periostatusRHM lt 3 then conc_disc_severe='conc non-severe';
	if periostatus=2 and periostatusRHM=2 then conc_disc_moderate='conc moderate';
	if periostatus=2 and periostatusRHM lt 2 then conc_disc_moderate='disc moderate';
	if periostatus lt 2 and periostatusRHM lt 2 then conc_disc_moderate='conc mild/no perio';
	if periostatus=1 and periostatusRHM=1 then conc_disc_mild='conc mild';
	if periostatus=1 and periostatusRHM lt 1 then conc_disc_mild='disc mild';
	if periostatus lt 1 and periostatusRHM lt 1 then conc_disc_mild='conc no perio';
	end;
	format periostatusRHM Perioc.;
	run;
	ods select none;
/*CDC/AAP*/
	proc freq data=concdisc;
	where periostatus ne .;
	tables periostatusRHM*periostatus/missing out=est1;
	run;
proc transpose data=est1 out=est1;run;
data &data1;
	set est1;
	if _name_='COUNT';
	conc_severe=COL10;
	disc_severe=COL4+COL7+COL9;
	conc_non_severe=COL1+COL2+COL3+COL5+COL6+COL8;
	conc_moderate=COL8;
	disc_moderate=COL3+COL6;
	conc_mild_no_perio=COL1+COL2+COL5;
	conc_mild=COL5;
	disc_mild=COL2;
	conc_no_perio=COL1;
	keep 	conc_severe disc_severe conc_non_severe conc_moderate
			disc_moderate conc_mild_no_perio conc_mild disc_mild conc_no_perio;
	run;
proc means data=concdisc n nmiss mean;
where periostatus ne .;
class conc_disc_severe;
var nteeth3cal nteeth4cal nteeth5cal nteeth6cal nteeth7cal meancalRHM
	nteeth3pd nteeth4pd nteeth5pd nteeth6pd nteeth7pd meanpdRHM;
	output out=est2;
run;
data est2;
	set est2;
	if _STAT_='MEAN';
	if _type_=1;
	drop _type_ _freq_ _stat_;
	run;
data &data2;
	set est2;
	if conc_disc_severe='conc non-se';
	run;
data &data3;
	set est2;
	if conc_disc_severe='conc severe';
	run;
data &data4;
	set est2;
	if conc_disc_severe='disc severe';
	run;
proc means data=concdisc n nmiss mean;
where periostatus ne .;
class conc_disc_moderate;
var nteeth3cal nteeth4cal nteeth5cal nteeth6cal nteeth7cal meancalRHM
	nteeth3pd nteeth4pd nteeth5pd nteeth6pd nteeth7pd meanpdRHM;
	output out=est3;
run;
data est3;
	set est3;
	if _STAT_='MEAN';
	if _type_=1;
	drop _type_ _freq_ _stat_;
	run;
data &data5;
	set est3;
	if conc_disc_moderate='conc mild/no';
	run;
data &data6;
	set est3;
	if conc_disc_moderate='conc moderate';
	run;
data &data7;
	set est3;
	if conc_disc_moderate='disc moderate';
	run;
proc means data=concdisc n nmiss mean;
where periostatus ne .;
class conc_disc_mild;
var nteeth3cal nteeth4cal nteeth5cal nteeth6cal nteeth7cal meancalRHM
	nteeth3pd nteeth4pd nteeth5pd nteeth6pd nteeth7pd meanpdRHM;
	output out=est4;
run;
data est4;
	set est4;
	if _STAT_='MEAN';
	if _type_=1;
	drop _type_ _freq_ _stat_;
	run;
data &data8;
	set est4;
	if conc_disc_mild='conc no p';
	run;
data &data9;
	set est4;
	if conc_disc_mild='conc mild';
	run;
data &data10;
	set est4;
	if conc_disc_mild='disc mild';
	run;
proc means data=concdisc n nmiss mean noprint;
var toothcountRHM meancalRHM meanpdRHM nteeth3cal nteeth4cal nteeth5cal nteeth6cal nteeth7cal
	nteeth3pd nteeth4pd nteeth5pd nteeth6pd nteeth7pd;
	output out=est5;
run;
data &data11;
	set est5;
	if _n_=4;
	drop _TYPE_ _FREQ_ _STAT_;
	run;
%mend randomMRML_MLMR;

/*Checking if coding of the variables in the above datastep (concdisc) were correctly done
All you need to do to check this is to put an asterisk before the word macro in line 6740 and run the datasetep*/
/*Checking frequency of the assignment to make surte that about 50% were randomly assigned to either half-mouth 
protocols*/
proc freq data=concdisc;
tables assign/missing;
run;

/*Checking if number of permanent teeth using UR and LL was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
			OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC toothcountURLL;
			run;

/*Checking if coding of maximum CAL per tooth was correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN	ohx02las ohx02laa ohx02lad ohx02lap ohx02maxlaURLLall
			ohx03las ohx03laa ohx03lad ohx03lap ohx03maxlaURLLall 
			ohx04las ohx04laa ohx04lad ohx04lap ohx04maxlaURLLall
			ohx05las ohx05laa ohx05lad ohx05lap ohx05maxlaURLLall
			ohx06las ohx06laa ohx06lad ohx06lap ohx06maxlaURLLall
			ohx07las ohx07laa ohx07lad ohx07lap ohx07maxlaURLLall
			ohx08las ohx08laa ohx08lad ohx08lap ohx08maxlaURLLall
			ohx18las ohx18laa ohx18lad ohx18lap ohx18maxlaURLLall
			ohx19las ohx19laa ohx19lad ohx19lap ohx19maxlaURLLall
			ohx20las ohx20laa ohx20lad ohx20lap ohx20maxlaURLLall
			ohx21las ohx21laa ohx21lad ohx21lap ohx21maxlaURLLall
			ohx22las ohx22laa ohx22lad ohx22lap ohx22maxlaURLLall
			ohx23las ohx23laa ohx23lad ohx23lap ohx23maxlaURLLall
			ohx24las ohx24laa ohx24lad ohx24lap ohx24maxlaURLLall;
			run;
			
/*Checking if number of teeth with CAL>=6 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN	ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
			ohx07maxlaURLLall ohx08maxlaURLLall ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall
			ohx21maxlaURLLall ohx22maxlaURLLall ohx23maxlaURLLall ohx24maxlaURLLall nteethipxla6mmURLLall;
			run;

/*Checking if coding of maximum PD per tooth was correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN	ohx02pcs ohx02pca ohx02pcd ohx02pcp ohx02maxpcURLLall
			ohx03pcs ohx03pca ohx03pcd ohx03pcp ohx03maxpcURLLall 
			ohx04pcs ohx04pca ohx04pcd ohx04pcp ohx04maxpcURLLall
			ohx05pcs ohx05pca ohx05pcd ohx05pcp ohx05maxpcURLLall
			ohx06pcs ohx06pca ohx06pcd ohx06pcp ohx06maxpcURLLall
			ohx07pcs ohx07pca ohx07pcd ohx07pcp ohx07maxpcURLLall
			ohx08pcs ohx08pca ohx08pcd ohx08pcp ohx08maxpcURLLall
			ohx18pcs ohx18pca ohx18pcd ohx18pcp ohx18maxpcURLLall
			ohx19pcs ohx19pca ohx19pcd ohx19pcp ohx19maxpcURLLall
			ohx20pcs ohx20pca ohx20pcd ohx20pcp ohx20maxpcURLLall
			ohx21pcs ohx21pca ohx21pcd ohx21pcp ohx21maxpcURLLall
			ohx22pcs ohx22pca ohx22pcd ohx22pcp ohx22maxpcURLLall
			ohx23pcs ohx23pca ohx23pcd ohx23pcp ohx23maxpcURLLall
			ohx24pcs ohx24pca ohx24pcd ohx24pcp ohx24maxpcURLLall;
			run;

/*Checking if number of teeth with PD>=5 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN	ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
			ohx07maxpcURLLall ohx08maxpcURLLall ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall
			ohx21maxpcURLLall ohx22maxpcURLLall ohx23maxpcURLLall ohx24maxpcURLLall nteethipxpc5mmURLLall;
			run;

/*Checking if periostatus for UR and LL was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	nteethipxla6mmURLLall nteethipxpc5mmURLLall periostatusURLLall
			nteethipxla4mmURLLall nteethipxpc5mmURLLall periostatusURLLall
			nsitesipxloa3mmURLLall nteethipxpc4mmURLLall periostatusURLLall;
			run;

/*Checking if mean CAL of UR and LL teeth was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad 
			ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 			
			ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las
			ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
			ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap  
			ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
			ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
			ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa meancalURLL;
			run;

/*Checking if mean PD of UR and LL teeth was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
			ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 
			ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
			ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 
			ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp 
			ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
			ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca  
			ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca meanpdURLL;
			run;

/*Checking if number of permanent teeth using UL and LR was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
			OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC toothcountULLR;
			run;

/*Checking if coding of maximum CAL per tooth was correctly coded for UL and LR*/
proc print data=concdisc (obs=100);
var SEQN	ohx09las ohx09laa ohx09lad ohx09lap ohx09maxlaULLRall
			ohx10las ohx10laa ohx10lad ohx10lap ohx10maxlaULLRall 
			ohx11las ohx11laa ohx11lad ohx11lap ohx11maxlaULLRall
			ohx12las ohx12laa ohx12lad ohx12lap ohx12maxlaULLRall
			ohx13las ohx13laa ohx13lad ohx13lap ohx13maxlaULLRall
			ohx14las ohx14laa ohx14lad ohx14lap ohx14maxlaULLRall
			ohx15las ohx15laa ohx15lad ohx15lap ohx15maxlaULLRall
			ohx25las ohx25laa ohx25lad ohx25lap ohx25maxlaULLRall
			ohx26las ohx26laa ohx26lad ohx26lap ohx26maxlaULLRall
			ohx27las ohx27laa ohx27lad ohx27lap ohx27maxlaULLRall
			ohx28las ohx28laa ohx28lad ohx28lap ohx28maxlaULLRall
			ohx29las ohx29laa ohx29lad ohx29lap ohx29maxlaULLRall
			ohx30las ohx30laa ohx30lad ohx30lap ohx30maxlaULLRall
			ohx31las ohx31laa ohx31lad ohx31lap ohx31maxlaULLRall;
			run;
			
/*Checking if number of teeth with CAL>=6 mm were correctly coded for UL and LR*/
proc print data=concdisc (obs=100);
var SEQN	ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
			ohx14maxlaULLRall ohx15maxlaULLRall ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall
			ohx28maxlaULLRall ohx29maxlaULLRall ohx30maxlaULLRall ohx31maxlaULLRall nteethipxla6mmULLRall;
			run;

/*Checking if coding of maximum PD per tooth was correctly coded for UL and LR*/
proc print data=concdisc (obs=100);
var SEQN	ohx09pcs ohx09pca ohx09pcd ohx09pcp ohx09maxpcULLRall
			ohx10pcs ohx10pca ohx10pcd ohx10pcp ohx10maxpcULLRall 
			ohx11pcs ohx11pca ohx11pcd ohx11pcp ohx11maxpcULLRall
			ohx12pcs ohx12pca ohx12pcd ohx12pcp ohx12maxpcULLRall
			ohx13pcs ohx13pca ohx13pcd ohx13pcp ohx13maxpcULLRall
			ohx14pcs ohx14pca ohx14pcd ohx14pcp ohx14maxpcULLRall
			ohx15pcs ohx15pca ohx15pcd ohx15pcp ohx15maxpcULLRall
			ohx25pcs ohx25pca ohx25pcd ohx25pcp ohx25maxpcULLRall
			ohx26pcs ohx26pca ohx26pcd ohx26pcp ohx26maxpcULLRall
			ohx27pcs ohx27pca ohx27pcd ohx27pcp ohx27maxpcULLRall
			ohx28pcs ohx28pca ohx28pcd ohx28pcp ohx28maxpcULLRall
			ohx29pcs ohx29pca ohx29pcd ohx29pcp ohx29maxpcULLRall
			ohx30pcs ohx30pca ohx30pcd ohx30pcp ohx30maxpcULLRall
			ohx31pcs ohx31pca ohx31pcd ohx31pcp ohx31maxpcULLRall;
			run;

/*Checking if number of teeth with PD>=5 mm were correctly coded for UL and LR*/
proc print data=concdisc (obs=100);
var SEQN	ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
			ohx14maxpcULLRall ohx15maxpcULLRall ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall
			ohx28maxpcULLRall ohx29maxpcULLRall ohx30maxpcULLRall ohx31maxpcULLRall nteethipxpc5mmULLRall;
			run;

/*Checking if periostatus for UL and LR was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	nteethipxla6mmULLRall nteethipxpc5mmULLRall periostatusULLRall
			nteethipxla4mmULLRall nteethipxpc5mmULLRall periostatusULLRall
			nsitesipxloa3mmULLRall nteethipxpc4mmULLRall periostatusULLRall;
			run;

/*Checking if mean CAL of UL and LR teeth was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
			ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad 			
			ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las
			ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las 
			ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap  
			ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap 
			ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
			ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa meancalULLR;
			run;

/*Checking if mean PD of UL and LR teeth was correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd
			ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd 
			ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
			ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs 
			ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
			ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp 
			ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca  
			ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca meanpdULLR;
			run;

/*Checking if those with assign=1 have values for UR and LL for toothcount, periostatus, meanCAL, meanPD,
and nteeth with different thresholds of CAL or PD*/
proc print data=concdisc (obs=100);
var SEQN assign	toothcountRHM toothcountURLL toothcountULLR
				periostatusRHM periostatusURLLall periostatusULLRall
				meancalRHM meancalURLL meancalULLR 
				meanpdRHM meanpdURLL meanpdULLR;
				run;

/*Checking if number of teeth with CAL>=3 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
				ohx07maxlaURLLall ohx08maxlaURLLall ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall
				ohx21maxlaURLLall ohx22maxlaURLLall ohx23maxlaURLLall ohx24maxlaURLLall nteeth3cal
				ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
				ohx14maxlaULLRall ohx15maxlaULLRall ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall
				ohx28maxlaULLRall ohx29maxlaULLRall ohx30maxlaULLRall ohx31maxlaULLRall nteeth3cal;
				run;

/*Checking if number of teeth with CAL>=4 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
				ohx07maxlaURLLall ohx08maxlaURLLall ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall
				ohx21maxlaURLLall ohx22maxlaURLLall ohx23maxlaURLLall ohx24maxlaURLLall nteeth4cal
				ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
				ohx14maxlaULLRall ohx15maxlaULLRall ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall
				ohx28maxlaULLRall ohx29maxlaULLRall ohx30maxlaULLRall ohx31maxlaULLRall nteeth4cal;
				run;

/*Checking if number of teeth with CAL>=5 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
				ohx07maxlaURLLall ohx08maxlaURLLall ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall
				ohx21maxlaURLLall ohx22maxlaURLLall ohx23maxlaURLLall ohx24maxlaURLLall nteeth5cal
				ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
				ohx14maxlaULLRall ohx15maxlaULLRall ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall
				ohx28maxlaULLRall ohx29maxlaULLRall ohx30maxlaULLRall ohx31maxlaULLRall nteeth5cal;
				run;

/*Checking if number of teeth with CAL>=6 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
				ohx07maxlaURLLall ohx08maxlaURLLall ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall
				ohx21maxlaURLLall ohx22maxlaURLLall ohx23maxlaURLLall ohx24maxlaURLLall nteeth6cal
				ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
				ohx14maxlaULLRall ohx15maxlaULLRall ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall
				ohx28maxlaULLRall ohx29maxlaULLRall ohx30maxlaULLRall ohx31maxlaULLRall nteeth6cal;
				run;

/*Checking if number of teeth with CAL>=7 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
				ohx07maxlaURLLall ohx08maxlaURLLall ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall
				ohx21maxlaURLLall ohx22maxlaURLLall ohx23maxlaURLLall ohx24maxlaURLLall nteeth7cal
				ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
				ohx14maxlaULLRall ohx15maxlaULLRall ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall
				ohx28maxlaULLRall ohx29maxlaULLRall ohx30maxlaULLRall ohx31maxlaULLRall nteeth7cal;
				run;

/*Checking if number of teeth with PD>=3 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
				ohx07maxpcURLLall ohx08maxpcURLLall ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall
				ohx21maxpcURLLall ohx22maxpcURLLall ohx23maxpcURLLall ohx24maxpcURLLall nteeth3pd
				ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
				ohx14maxpcULLRall ohx15maxpcULLRall ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall
				ohx28maxpcULLRall ohx29maxpcULLRall ohx30maxpcULLRall ohx31maxpcULLRall nteeth3pd;
				run;

/*Checking if number of teeth with PD>=4 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
				ohx07maxpcURLLall ohx08maxpcURLLall ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall
				ohx21maxpcURLLall ohx22maxpcURLLall ohx23maxpcURLLall ohx24maxpcURLLall nteeth4pd
				ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
				ohx14maxpcULLRall ohx15maxpcULLRall ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall
				ohx28maxpcULLRall ohx29maxpcULLRall ohx30maxpcULLRall ohx31maxpcULLRall nteeth4pd;
				run;

/*Checking if number of teeth with PD>=5 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
				ohx07maxpcURLLall ohx08maxpcURLLall ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall
				ohx21maxpcURLLall ohx22maxpcURLLall ohx23maxpcURLLall ohx24maxpcURLLall nteeth5pd
				ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
				ohx14maxpcULLRall ohx15maxpcULLRall ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall
				ohx28maxpcULLRall ohx29maxpcULLRall ohx30maxpcULLRall ohx31maxpcULLRall nteeth5pd;
				run;

/*Checking if number of teeth with PD>=6 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
				ohx07maxpcURLLall ohx08maxpcURLLall ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall
				ohx21maxpcURLLall ohx22maxpcURLLall ohx23maxpcURLLall ohx24maxpcURLLall nteeth6pd
				ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
				ohx14maxpcULLRall ohx15maxpcULLRall ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall
				ohx28maxpcULLRall ohx29maxpcULLRall ohx30maxpcULLRall ohx31maxpcULLRall nteeth6pd;
				run;

/*Checking if number of teeth with PD>=7 mm were correctly coded for UR and LL*/
proc print data=concdisc (obs=100);
var SEQN assign	ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
				ohx07maxpcURLLall ohx08maxpcURLLall ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall
				ohx21maxpcURLLall ohx22maxpcURLLall ohx23maxpcURLLall ohx24maxpcURLLall nteeth7pd
				ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
				ohx14maxpcULLRall ohx15maxpcULLRall ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall
				ohx28maxpcULLRall ohx29maxpcULLRall ohx30maxpcULLRall ohx31maxpcULLRall nteeth7pd;
				run;

/*Checking if concordance or discordnace for each category were correctly coded*/
proc print data=concdisc (obs=100);
var SEQN	periostatus periostatusRHM conc_disc_severe
			periostatus periostatusRHM conc_disc_moderate
			periostatus periostatusRHM conc_disc_mild;
			run;

/*Checking how many were missing concordance/discordance for each periodontiis FM category*/
proc freq data=concdisc;
tables conc_disc_severe conc_disc_moderate conc_disc_mild/missing;
run;

/*Note: If you want to run the simulation macro, remove the asterisk before the word macro in line 6740*/

/*The macro above only does one iteration of random assignment to either UR and LL or to UL and LR half-mouth.
We need to do this over 1,000 iterations to account for the random error using a nested macro (macro within a macro)*/
%macro sim(cstart, cend, one, two, three, four, five, six, seven, eight, nine, ten, eleven);
%do i=&cstart %to &cend;
%randomMRML_MLMR(one&i, two&i, three&i, four&i, five&i, six&i, seven&i, eight&i, nine&i, ten&i, eleven&i);
%end;
%mend sim;

/*The line below acutally runs the 10,000 iterations of random assignment*/
%sim(1,1000, one, two, three, four, five, six, seven, eight, nine, ten, eleven)

ods select all;

/* Stacking the seperate datasets for each regression output from each iteration*/
data part.cdcaapcount;
	set one1-one1000;
		run;

proc means data=part.cdcaapcount;run;

data part.concnonsevere;
	set two1-two1000;
		run;

proc means data=part.concnonsevere;run;

data part.concsevere;
	set three1-three1000;
		run;

proc means data=part.concsevere;run;

data part.discsevere;
	set four1-four1000;
		run;

proc means data=part.discsevere;run;

data part.concnonmoderate;
	set five1-five1000;
		run;

proc means data=part.concnonmoderate;run;

data part.concmoderate;
	set six1-six1000;
		run;

proc means data=part.concmoderate;run;

data part.discmoderate;
	set seven1-seven1000;
		run;

proc means data=part.discmoderate;run;

data part.concnonmild;
	set eight1-eight1000;
		run;

proc means data=part.concnonmild;run;

data part.concmild;
	set nine1-nine1000;
		run;

proc means data=part.concmild;run;

data part.discmild;
	set ten1-ten1000;
		run;

proc means data=part.discmild;run;

data part.allmeans;
	set eleven1-eleven1000;
		run;

/**********************************************************************************************/
/* Code Section 8 - Reproducing Table 4. Comparisons of clinical severity across PMR protocols*/ 
/**********************************************************************************************/

data means;
	set one;

	/* Calculating mean number of teeth in each protocol*/
	array tooth	(28)	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
						OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
						OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC
						OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;
	toothcount=0;
	do i=1 to 28;
	if tooth(i)=2 then toothcount=toothcount+1;
	end;
	drop i;

	array toothURLL	(14)	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
							OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC;
	toothcountURLL=0;
	do i=1 to 14;
	if toothURLL(i)=2 then toothcountURLL=toothcountURLL+1;
	end;
	drop i;

	array toothULLR	(14)	OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
							OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC;
	toothcountULLR=0;
	do i=1 to 14;
	if toothULLR(i)=2 then toothcountULLR=toothcountULLR+1;
	end;
	drop i;

	array toothCPITN (10)	OHX02TC OHX03TC  								OHX08TC
																	OHX14TC OHX15TC
							OHX18TC OHX19TC 								OHX24TC
																	OHX30TC OHX31TC;
	toothcountCPITN=0;
	do i=1 to 10;
	if toothCPITN(i)=2 then toothcountCPITN=toothcountCPITN+1;
	end;
	drop i;

	array toothramf	(6)	        OHX03TC 
						OHX09TC 				OHX12TC 
								OHX19TC 
						OHX25TC 				OHX28TC;
	toothcountramf=0;
	do i=1 to 6;
	if toothramf(i)=2 then toothcountramf=toothcountramf+1;
	end;
	drop i;

	/*Calculating mean CAL and mean PD in each protocol*/
	meancal=mean (of 	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
						ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
						ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
						ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
						ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
						ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
						ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
						ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa);

	meanpd=mean(of 		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
						ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd
						ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
						ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs
						ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp 
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
						ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp
						ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca 
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca 
						ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca 
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca);

	meancalURLL=mean (of 	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad 
							ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
							ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las
							ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las
							ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap  
							ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
							ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
							ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa);

	meanpdURLL=mean(of 		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
							ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 
							ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
							ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 
							ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp 
							ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
							ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca  
							ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca);

	meancalULLR=mean (of	ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
							ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
							ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
							ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
							ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
							ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
							ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
							ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa);

	meanpdULLR=mean(of 		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
							ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd
							ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
							ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs
							ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
							ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp
							ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca 
							ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca);

	meancalCPITN=mean (of 	ohx02lad ohx03lad 									  ohx08lad
																		 ohx14lad ohx15lad 
							ohx18lad ohx19lad 									  ohx24lad 
																		 ohx30lad ohx31lad
							ohx02las ohx03las 									  ohx08las
																		 ohx14las ohx15las 
							ohx18las ohx19las 									  ohx24las 
																		 ohx30las ohx31las
							ohx02laa ohx03laa 									  ohx08laa
																		 ohx14laa ohx15laa 
							ohx18laa ohx19laa 									  ohx24laa 
																		 ohx30laa ohx31laa
							ohx02lap ohx03lap 									  ohx08lap
																		 ohx14lap ohx15lap 
							ohx18lap ohx19lap 									  ohx24lap 
																		 ohx30lap ohx31lap);

	meanpdCPITN=mean(of 	ohx02pcd ohx03pcd 									  ohx08pcd
																		 ohx14pcd ohx15pcd 
							ohx18pcd ohx19pcd 									  ohx24pcd 
																		 ohx30pcd ohx31pcd
							ohx02pcs ohx03pcs 									  ohx08pcs
																		 ohx14pcs ohx15pcs 
							ohx18pcs ohx19pcs 									  ohx24pcs 
																		 ohx30pcs ohx31pcs
							ohx02pca ohx03pca 									  ohx08pca
																		 ohx14pca ohx15pca 
							ohx18pca ohx19pca 									  ohx24pca 
																		 ohx30pca ohx31pca
							ohx02pcp ohx03pcp 									  ohx08pcp
																		 ohx14pcp ohx15pcp 
							ohx18pcp ohx19pcp 									  ohx24pcp 
																		 ohx30pcp ohx31pcp);

	meancalramf=mean (of 		 ohx03lad 
						ohx09lad 				   ohx12lad  
								 ohx19lad 
						ohx25lad 				   ohx28lad 
								 ohx03las 
						ohx09las 				   ohx12las  
								 ohx19las 
						ohx25las 				   ohx28las 
								 ohx03laa 
						ohx09laa 				   ohx12laa  
								 ohx19laa 
						ohx25laa 				   ohx28laa 
								 ohx03lap 
						ohx09lap 				   ohx12lap  
								 ohx19lap 
						ohx25lap 				   ohx28lap);

	meanpdramf=mean(of 			 ohx03pcd 
						ohx09pcd 				   ohx12pcd  
								 ohx19pcd 
						ohx25pcd 				   ohx28pcd 
								 ohx03pcs 
						ohx09pcs 				   ohx12pcs  
								 ohx19pcs 
						ohx25pcs 				   ohx28pcs 
								 ohx03pca 
						ohx09pca 				   ohx12pca  
								 ohx19pca 
						ohx25pca 				   ohx28pca 
								 ohx03pcp 
						ohx09pcp 				   ohx12pcp  
								 ohx19pcp 
						ohx25pcp 				   ohx28pcp);

	/*Calculating mean number of teeth with 3,4,5,6, and 7 mm of CAL or PD in each protocol*/
	array lax (28) 		ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla
						ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla 
						ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla 
						ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla;

	array pcx (28) 		ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc
						ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc
						ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc
						ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc;

	nteeth3cal=0;
	nteeth4cal=0;
	nteeth5cal=0;
	nteeth6cal=0;
	nteeth7cal=0;
	nteeth3pd=0;
	nteeth4pd=0;
	nteeth5pd=0;
	nteeth6pd=0;
	nteeth7pd=0;
	do count=1 to 28;
	if lax(count) ge 3 then nteeth3cal=nteeth3cal+1;
	if lax(count) ge 4 then nteeth4cal=nteeth4cal+1;
	if lax(count) ge 5 then nteeth5cal=nteeth5cal+1;
	if lax(count) ge 6 then nteeth6cal=nteeth6cal+1;
	if lax(count) ge 7 then nteeth7cal=nteeth7cal+1;
	if pcx(count) ge 3 then nteeth3pd=nteeth3pd+1;
	if pcx(count) ge 4 then nteeth4pd=nteeth4pd+1;
	if pcx(count) ge 5 then nteeth5pd=nteeth5pd+1;
	if pcx(count) ge 6 then nteeth6pd=nteeth6pd+1;
	if pcx(count) ge 7 then nteeth7pd=nteeth7pd+1;
	end;

	/*Upper right and lower left*/
	array lasURLLall (14)		ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las
								ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las;
	array laaURLLall (14) 		ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa
								ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa;
	array ladURLLall (14)		ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
								ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad;
	array lapURLLall (14)		ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap
								ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap;
	array laxURLLall (14) 		ohx02maxlaURLLall ohx03maxlaURLLall ohx04maxlaURLLall ohx05maxlaURLLall ohx06maxlaURLLall
								ohx07maxlaURLLall ohx08maxlaURLLall
								ohx18maxlaURLLall ohx19maxlaURLLall ohx20maxlaURLLall ohx21maxlaURLLall ohx22maxlaURLLall
								ohx23maxlaURLLall ohx24maxlaURLLall;

	array pcsURLLall (14)		ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
								ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs;
	array pcaURLLall (14) 		ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
								ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca;
	array pcdURLLall (14)		ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
								ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd;
	array pcpURLLall (14)		ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
								ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp;
	array pcxURLLall (14) 		ohx02maxpcURLLall ohx03maxpcURLLall ohx04maxpcURLLall ohx05maxpcURLLall ohx06maxpcURLLall
								ohx07maxpcURLLall ohx08maxpcURLLall
								ohx18maxpcURLLall ohx19maxpcURLLall ohx20maxpcURLLall ohx21maxpcURLLall ohx22maxpcURLLall
								ohx23maxpcURLLall ohx24maxpcURLLall;

	do i=1 to 14;
	laxURLLall(i)=max (of lasURLLall(i), laaURLLall(i), ladURLLall(i), lapURLLall(i));
	pcxURLLall(i)=max (of pcsURLLall(i), pcaURLLall(i), pcdURLLall(i), pcpURLLall(i));
	end;
	drop i;

	nteeth3calURLL=0;
	nteeth4calURLL=0;
	nteeth5calURLL=0;
	nteeth6calURLL=0;
	nteeth7calURLL=0;
	nteeth3pdURLL=0;
	nteeth4pdURLL=0;
	nteeth5pdURLL=0;
	nteeth6pdURLL=0;
	nteeth7pdURLL=0;
	do count=1 to 14;
	if laxURLLall(count) ge 3 then nteeth3calURLL=nteeth3calURLL+1;
	if laxURLLall(count) ge 4 then nteeth4calURLL=nteeth4calURLL+1;
	if laxURLLall(count) ge 5 then nteeth5calURLL=nteeth5calURLL+1;
	if laxURLLall(count) ge 6 then nteeth6calURLL=nteeth6calURLL+1;
	if laxURLLall(count) ge 7 then nteeth7calURLL=nteeth7calURLL+1;
	if pcxURLLall(count) ge 3 then nteeth3pdURLL=nteeth3pdURLL+1;
	if pcxURLLall(count) ge 4 then nteeth4pdURLL=nteeth4pdURLL+1;
	if pcxURLLall(count) ge 5 then nteeth5pdURLL=nteeth5pdURLL+1;
	if pcxURLLall(count) ge 6 then nteeth6pdURLL=nteeth6pdURLL+1;
	if pcxURLLall(count) ge 7 then nteeth7pdURLL=nteeth7pdURLL+1;
	end;

	/* Upper left and lower right*/
	array lasULLRall (14)		ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las
								ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las;
	array laaULLRall (14) 		ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa
								ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa;
	array ladULLRall (14)		ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad
								ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad;
	array lapULLRall (14)		ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap
								ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap;
	array laxULLRall (14) 		ohx09maxlaULLRall ohx10maxlaULLRall ohx11maxlaULLRall ohx12maxlaULLRall ohx13maxlaULLRall
								ohx14maxlaULLRall ohx15maxlaULLRall
								ohx25maxlaULLRall ohx26maxlaULLRall ohx27maxlaULLRall ohx28maxlaULLRall ohx29maxlaULLRall
								ohx30maxlaULLRall ohx31maxlaULLRall;

	array pcsULLRall (14)		ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs
								ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs;
	array pcaULLRall (14) 		ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca
								ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca;
	array pcdULLRall (14)		ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd
								ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd;
	array pcpULLRall (14)		ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp
								ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp;
	array pcxULLRall (14) 		ohx09maxpcULLRall ohx10maxpcULLRall ohx11maxpcULLRall ohx12maxpcULLRall ohx13maxpcULLRall
								ohx14maxpcULLRall ohx15maxpcULLRall
								ohx25maxpcULLRall ohx26maxpcULLRall ohx27maxpcULLRall ohx28maxpcULLRall ohx29maxpcULLRall
								ohx30maxpcULLRall ohx31maxpcULLRall;

	do i=1 to 14;
	laxULLRall(i)=max (of lasULLRall(i), laaULLRall(i), ladULLRall(i), lapULLRall(i));
	pcxULLRall(i)=max (of pcsULLRall(i), pcaULLRall(i), pcdULLRall(i), pcpULLRall(i));
	end;
	drop i;

	nteeth3calULLR=0;
	nteeth4calULLR=0;
	nteeth5calULLR=0;
	nteeth6calULLR=0;
	nteeth7calULLR=0;
	nteeth3pdULLR=0;
	nteeth4pdULLR=0;
	nteeth5pdULLR=0;
	nteeth6pdULLR=0;
	nteeth7pdULLR=0;
	do count=1 to 14;
	if laxULLRall(count) ge 3 then nteeth3calULLR=nteeth3calULLR+1;
	if laxULLRall(count) ge 4 then nteeth4calULLR=nteeth4calULLR+1;
	if laxULLRall(count) ge 5 then nteeth5calULLR=nteeth5calULLR+1;
	if laxULLRall(count) ge 6 then nteeth6calULLR=nteeth6calULLR+1;
	if laxULLRall(count) ge 7 then nteeth7calULLR=nteeth7calULLR+1;
	if pcxULLRall(count) ge 3 then nteeth3pdULLR=nteeth3pdULLR+1;
	if pcxULLRall(count) ge 4 then nteeth4pdULLR=nteeth4pdULLR+1;
	if pcxULLRall(count) ge 5 then nteeth5pdULLR=nteeth5pdULLR+1;
	if pcxULLRall(count) ge 6 then nteeth6pdULLR=nteeth6pdULLR+1;
	if pcxULLRall(count) ge 7 then nteeth7pdULLR=nteeth7pdULLR+1;
	end;

	/*CPITN*/
	array ladCPITN (10)		ohx02lad ohx03lad 									  ohx08lad
																		 ohx14lad ohx15lad 
							ohx18lad ohx19lad 									  ohx24lad 
																		 ohx30lad ohx31lad;

	array lasCPITN (10)		ohx02las ohx03las 									  ohx08las
																		 ohx14las ohx15las 
							ohx18las ohx19las 									  ohx24las 
																		 ohx30las ohx31las;

	array laaCPITN (10)		ohx02laa ohx03laa 									  ohx08laa
																		 ohx14laa ohx15laa 
							ohx18laa ohx19laa 									  ohx24laa 
																		 ohx30laa ohx31laa;

	array lapCPITN (10)		ohx02lap ohx03lap 									  ohx08lap
																		 ohx14lap ohx15lap 
							ohx18lap ohx19lap 									  ohx24lap 
																		 ohx30lap ohx31lap;

	array laxCPITN (10) 	ohx02maxlaCPITN ohx03maxlaCPITN  						  ohx08maxlaCPITN
																	  ohx14maxlaCPITN ohx15maxlaCPITN 
							ohx18maxlaCPITN ohx19maxlaCPITN  						  ohx24maxlaCPITN 
																	  ohx30maxlaCPITN ohx31maxlaCPITN;

	array pcdCPITN (10)		ohx02pcd ohx03pcd 									  ohx08pcd
																		 ohx14pcd ohx15pcd 
							ohx18pcd ohx19pcd 									  ohx24pcd 
																		 ohx30pcd ohx31pcd;

	array pcsCPITN (10)		ohx02pcs ohx03pcs 									  ohx08pcs
																		 ohx14pcs ohx15pcs 
							ohx18pcs ohx19pcs 									  ohx24pcs 
																		 ohx30pcs ohx31pcs;

	array pcaCPITN (10)		ohx02pca ohx03pca 									  ohx08pca
																		 ohx14pca ohx15pca 
							ohx18pca ohx19pca 									  ohx24pca 
																		 ohx30pca ohx31pca;

	array pcpCPITN (10)		ohx02pcp ohx03pcp 									  ohx08pcp
																		 ohx14pcp ohx15pcp 
							ohx18pcp ohx19pcp 									  ohx24pcp 
																		 ohx30pcp ohx31pcp;

	array pcxCPITN (10) 	ohx02maxpcCPITN ohx03maxpcCPITN  						  ohx08maxpcCPITN
																	  ohx14maxpcCPITN ohx15maxpcCPITN 
							ohx18maxpcCPITN ohx19maxpcCPITN  						  ohx24maxpcCPITN 
																	  ohx30maxpcCPITN ohx31maxpcCPITN;

	do i=1 to 10;
	laxCPITN(i)=max (of lasCPITN(i), laaCPITN(i), ladCPITN(i), lapCPITN(i));
	pcxCPITN(i)=max (of pcsCPITN(i), pcaCPITN(i), pcdCPITN(i), pcpCPITN(i));
	end;
	drop i;

	/*CDC/AAP*/
	/* Define periodontal disease using Eke 2012 definition*/
	
	/* set PeriostatusCPITN to 0*/

	periostatusCPITN=0;

	/* Severe periodontitis: >=2 interproximal sites with LOA >=6 mm (not on same tooth) and >=1 interproximal
	site with PD >=5 mm*/
	/* Set tooth counts=0*/

	nteethipxla6mmCPITN=0;
	nteethipxpc5mmCPITN=0;
	do count=1 to 10; 
	if laxCPITN(count) ge 6 then nteethipxla6mmCPITN=nteethipxla6mmCPITN+1;
	if pcxCPITN(count) ge 5 then nteethipxpc5mmCPITN=nteethipxpc5mmCPITN+1;
	end; 
	if nteethipxla6mmCPITN>=2 AND nteethipxpc5mmCPITN>=1 then periostatusCPITN=3; /*Severe perio*/


	/* Moderate periodontitis: >=2 interproximal sites with LOA >=4 mm (not on same tooth), or >=2 interproximal
	sites with PD>=5 mm (not on same tooth)*/

	IF PERIOSTATUSCPITN=0 THEN  DO;
	nteethipxla4mmCPITN=0;
	do count=1 to 10; if laxCPITN(count) ge 4 then nteethipxla4mmCPITN=nteethipxla4mmCPITN+1; end;
	if nteethipxla4mmCPITN>=2 OR nteethipxpc5mmCPITN>=2 then periostatusCPITN=2; /*Moderate perio*/

	END;

	/* Mild periodontitis: >=2 interproximal sites with LOA >=3 mm, and >=2 interproximal sites with PD >=4 mm
	(not on same tooth) or one site with PD >=5 mm*/

	IF PERIOSTATUSCPITN=0 THEN  DO;
	nsitesipxloa3mmCPITN=0;
	nteethipxpc4mmCPITN=0;
	do count=1 to 10; if ladCPITN(count) ge 3 then nsitesipxloa3mmCPITN=nsitesipxloa3mmCPITN+1; 
	if lasCPITN(count) ge 3 then nsitesipxloa3mmCPITN=nsitesipxloa3mmCPITN+1; 
		 if lapCPITN(count) ge 3 then nsitesipxloa3mmCPITN=nsitesipxloa3mmCPITN+1; 
		if laaCPITN(count) ge 3 then nsitesipxloa3mmCPITN=nsitesipxloa3mmCPITN+1; end;
	do count=1 to 10; if pcxCPITN(count) ge 4 then nteethipxpc4mmCPITN=nteethipxpc4mmCPITN+1; end;
	if nsitesipxloa3mmCPITN>=2 AND (nteethipxpc4mmCPITN>=2 OR nteethipxpc5mmCPITN=1) then periostatusCPITN=1;
	/*Mild perio*/
	END;

	nteeth3calCPITN=0;
	nteeth4calCPITN=0;
	nteeth5calCPITN=0;
	nteeth6calCPITN=0;
	nteeth7calCPITN=0;
	nteeth3pdCPITN=0;
	nteeth4pdCPITN=0;
	nteeth5pdCPITN=0;
	nteeth6pdCPITN=0;
	nteeth7pdCPITN=0;
	do count=1 to 10;
	if laxCPITN(count) ge 3 then nteeth3calCPITN=nteeth3calCPITN+1;
	if laxCPITN(count) ge 4 then nteeth4calCPITN=nteeth4calCPITN+1;
	if laxCPITN(count) ge 5 then nteeth5calCPITN=nteeth5calCPITN+1;
	if laxCPITN(count) ge 6 then nteeth6calCPITN=nteeth6calCPITN+1;
	if laxCPITN(count) ge 7 then nteeth7calCPITN=nteeth7calCPITN+1;

	if pcxCPITN(count) ge 3 then nteeth3pdCPITN=nteeth3pdCPITN+1;
	if pcxCPITN(count) ge 4 then nteeth4pdCPITN=nteeth4pdCPITN+1;
	if pcxCPITN(count) ge 5 then nteeth5pdCPITN=nteeth5pdCPITN+1;
	if pcxCPITN(count) ge 6 then nteeth6pdCPITN=nteeth6pdCPITN+1;
	if pcxCPITN(count) ge 7 then nteeth7pdCPITN=nteeth7pdCPITN+1;
	end;

	/*Ramfjord teeth*/
	array ladramf (6)	 		 ohx03lad 
						ohx09lad 				   ohx12lad  
								 ohx19lad 
						ohx25lad 				   ohx28lad;

	array lasramf (6)			 ohx03las 
						ohx09las 				   ohx12las  
								 ohx19las 
						ohx25las 				   ohx28las; 

	array laaramf (6)			 ohx03laa 
						ohx09laa 				   ohx12laa  
								 ohx19laa 
						ohx25laa 				   ohx28laa;

	array lapramf (6)			 ohx03lap 
						ohx09lap 				   ohx12lap  
								 ohx19lap 
						ohx25lap 				   ohx28lap;
	
	array laxramf (6) 					ohx03maxlaramf 
						ohx09maxlaramf  						  ohx12maxlaramf
										ohx19maxlaramf 
						ohx25maxlaramf 						  ohx28maxlaramf;



	array pcdramf (6)	 		 ohx03pcd 
						ohx09pcd 				   ohx12pcd  
								 ohx19pcd 
						ohx25pcd 				   ohx28pcd;

	array pcsramf (6)			 ohx03pcs 
						ohx09pcs 				   ohx12pcs  
								 ohx19pcs 
						ohx25pcs 				   ohx28pcs; 

	array pcaramf (6)			 ohx03pca 
						ohx09pca 				   ohx12pca  
								 ohx19pca 
						ohx25pca 				   ohx28pca;

	array pcpramf (6)			 ohx03pcp 
						ohx09pcp 				   ohx12pcp  
								 ohx19pcp 
						ohx25pcp 				   ohx28pcp;
	
	array pcxramf (6) 					ohx03maxpcramf 
						ohx09maxpcramf  						  ohx12maxpcramf
										ohx19maxpcramf 
						ohx25maxpcramf 						  ohx28maxpcramf;
	
	do i=1 to 6;
	laxramf(i)=max (of lasramf(i), laaramf(i), ladramf(i), lapramf(i));
	pcxramf(i)=max (of pcsramf(i), pcaramf(i), pcdramf(i), pcpramf(i));
	end;
	drop i;

	/*CDC/AAP*/
	/* Define periodontal disease using Eke 2012 definition*/
	
	/* set Periostatusramf to 0*/

	periostatusramf=0;

	/* Severe periodontitis: >=2 interproximal sites with LOA >=6 mm (not on same tooth) and >=1 interproximal
	site with PD >=5 mm*/
	/* Set tooth counts=0*/

	nteethipxla6mmramf=0;
	nteethipxpc5mmramf=0;
	do count=1 to 6; 
	if laxramf(count) ge 6 then nteethipxla6mmramf=nteethipxla6mmramf+1;
	if pcxramf(count) ge 5 then nteethipxpc5mmramf=nteethipxpc5mmramf+1;
	end; 
	if nteethipxla6mmramf>=2 AND nteethipxpc5mmramf>=1 then periostatusramf=3; /*Severe perio*/


	/* Moderate periodontitis: >=2 interproximal sites with LOA >=4 mm (not on same tooth), or >=2 interproximal
	sites with PD>=5 mm (not on same tooth)*/

	IF PERIOSTATUSramf=0 THEN  DO;
	nteethipxla4mmramf=0;
	do count=1 to 6; if laxramf(count) ge 4 then nteethipxla4mmramf=nteethipxla4mmramf+1; end;
	if nteethipxla4mmramf>=2 OR nteethipxpc5mmramf>=2 then periostatusramf=2; /*Moderate perio*/

	END;

	/* Mild periodontitis: >=2 interproximal sites with LOA >=3 mm, and >=2 interproximal sites with PD >=4 mm 
	(not on same tooth) or one site with PD >=5 mm*/

	IF PERIOSTATUSramf=0 THEN  DO;
	nsitesipxloa3mmramf=0;
	nteethipxpc4mmramf=0;
	do count=1 to 6; if ladramf(count) ge 3 then nsitesipxloa3mmramf=nsitesipxloa3mmramf+1; 
	if lasramf(count) ge 3 then nsitesipxloa3mmramf=nsitesipxloa3mmramf+1; 
		 if lapramf(count) ge 3 then nsitesipxloa3mmramf=nsitesipxloa3mmramf+1; 
		if laaramf(count) ge 3 then nsitesipxloa3mmramf=nsitesipxloa3mmramf+1; end;
	do count=1 to 6; if pcxramf(count) ge 4 then nteethipxpc4mmramf=nteethipxpc4mmramf+1; end;
	if nsitesipxloa3mmramf>=2 AND (nteethipxpc4mmramf>=2 OR nteethipxpc5mmramf=1) then periostatusramf=1;
	/*Mild perio*/
	END;

	nteeth3calramf=0;
	nteeth4calramf=0;
	nteeth5calramf=0;
	nteeth6calramf=0;
	nteeth7calramf=0;

	nteeth3pdramf=0;
	nteeth4pdramf=0;
	nteeth5pdramf=0;
	nteeth6pdramf=0;
	nteeth7pdramf=0;
	do count=1 to 6;
	if laxramf(count) ge 3 then nteeth3calramf=nteeth3calramf+1;
	if laxramf(count) ge 4 then nteeth4calramf=nteeth4calramf+1;
	if laxramf(count) ge 5 then nteeth5calramf=nteeth5calramf+1;
	if laxramf(count) ge 6 then nteeth6calramf=nteeth6calramf+1;
	if laxramf(count) ge 7 then nteeth7calramf=nteeth7calramf+1;
	if pcxramf(count) ge 3 then nteeth3pdramf=nteeth3pdramf+1;
	if pcxramf(count) ge 4 then nteeth4pdramf=nteeth4pdramf+1;
	if pcxramf(count) ge 5 then nteeth5pdramf=nteeth5pdramf+1;
	if pcxramf(count) ge 6 then nteeth6pdramf=nteeth6pdramf+1;
	if pcxramf(count) ge 7 then nteeth7pdramf=nteeth7pdramf+1;
	end;
	run;

/*Checking if number of teeth in each protocol was calculated correctly*/
/*UR and LL*/
proc print data=means (obs=100);
var SEQN	OHX02TC OHX03TC OHX04TC OHX05TC OHX06TC OHX07TC OHX08TC
			OHX18TC OHX19TC OHX20TC OHX21TC OHX22TC OHX23TC OHX24TC toothcountURLL;
			run;

/*UL and LR*/
proc print data=means (obs=100);
var SEQN	OHX09TC OHX10TC OHX11TC OHX12TC OHX13TC OHX14TC OHX15TC
			OHX25TC OHX26TC OHX27TC OHX28TC OHX29TC OHX30TC OHX31TC toothcountULLR;
			run;

/*CPITN*/
proc print data=means (obs=100);
var SEQN	OHX02TC OHX03TC  								OHX08TC
																	OHX14TC OHX15TC
							OHX18TC OHX19TC 								OHX24TC
																	OHX30TC OHX31TC toothcountCPITN;
			run;

/*Ramfjord*/
proc print data=means (obs=100);
var SEQN	OHX03TC 
						OHX09TC 				OHX12TC 
								OHX19TC 
						OHX25TC 				OHX28TC toothcountramf;
			run;

/*Checking if mean CAL and PD were correctly coded for each protocol*/
/*FM*/
proc print data=means (obs=100);
var SEQN	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
			ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
			ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
			ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
			ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
			ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
			ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
			ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
			ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
			ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
			ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
			ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
			ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
			ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
			ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
			ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa meancal;
			run;

proc print data=means (obs=100);
var SEQN	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
			ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
			ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 
			ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd
			ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
			ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
			ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 
			ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs
			ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp 
			ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
			ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
			ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp
			ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca 
			ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca 
			ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca 
			ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca meanpd;
			run;

/*UR and LL*/
proc print data=means (obs=100);
var SEQN	ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad 
			ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 		
			ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las
			ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
			ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap  
			ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 				
			ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
			ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa meancalURLL;
			run;

proc print data=means (obs=100);
var SEQN	ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
			ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd 			
			ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs 
			ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs 	
			ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp 
			ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp 
			ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca  
			ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca meanpdURLL;
			run;

/*UL and LR*/
proc print data=means (obs=100);
var SEQN	ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad 
			ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad
			ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las 
			ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las
			ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap 
			ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap
			ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa 
			ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa meancal meancalULLR;
			run;

proc print data=means (obs=100);
var SEQN	ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd 
			ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd
			ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs 
			ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs
			ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp 
			ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp
			ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca 
			ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca meanpdULLR;
			run;

/*CPITN*/
proc print data=means (obs=100);
var SEQN	ohx02lad ohx03lad 									  ohx08lad
														 ohx14lad ohx15lad 
			ohx18lad ohx19lad 									  ohx24lad 
														 ohx30lad ohx31lad
			ohx02las ohx03las 									  ohx08las
														 ohx14las ohx15las 
			ohx18las ohx19las 									  ohx24las 
														 ohx30las ohx31las
			ohx02laa ohx03laa 									  ohx08laa
														 ohx14laa ohx15laa 
			ohx18laa ohx19laa 									  ohx24laa 
														 ohx30laa ohx31laa
			ohx02lap ohx03lap 									  ohx08lap
														 ohx14lap ohx15lap 
			ohx18lap ohx19lap 									  ohx24lap 
														 ohx30lap ohx31lap meancalCPITN;
			run;

proc print data=means (obs=100);
var SEQN	ohx02pcd ohx03pcd 									  ohx08pcd
														 ohx14pcd ohx15pcd 
			ohx18pcd ohx19pcd 									  ohx24pcd 
														 ohx30pcd ohx31pcd
			ohx02pcs ohx03pcs 									  ohx08pcs
														 ohx14pcs ohx15pcs 
			ohx18pcs ohx19pcs 									  ohx24pcs 
														 ohx30pcs ohx31pcs
			ohx02pca ohx03pca 									  ohx08pca
														 ohx14pca ohx15pca 
			ohx18pca ohx19pca 									  ohx24pca 
														 ohx30pca ohx31pca
			ohx02pcp ohx03pcp 									  ohx08pcp
													     ohx14pcp ohx15pcp 
			ohx18pcp ohx19pcp 									  ohx24pcp 
														 ohx30pcp ohx31pcp meanpdCPITN;
			run;

/*Ramfjord*/
proc print data=means (obs=100);
var SEQN				ohx03lad 
			ohx09lad 				   ohx12lad  
						ohx19lad 
			ohx25lad 				   ohx28lad 
						ohx03las 
			ohx09las 				   ohx12las  
						ohx19las 
			ohx25las 				   ohx28las 
						ohx03laa 
			ohx09laa 				   ohx12laa  
						ohx19laa 
			ohx25laa 				   ohx28laa 
						ohx03lap 
			ohx09lap 				   ohx12lap  
						ohx19lap 
			ohx25lap 				   ohx28lap meancalramf;
			run;

proc print data=means (obs=100);
var SEQN				ohx03pcd 
			ohx09pcd 				   ohx12pcd  
						ohx19pcd 
			ohx25pcd 				   ohx28pcd 
						ohx03pcs 
			ohx09pcs 				   ohx12pcs  
						ohx19pcs 
			ohx25pcs 				   ohx28pcs 
						ohx03pca 
			ohx09pca 				   ohx12pca  
						ohx19pca 
			ohx25pca 				   ohx28pca 
						ohx03pcp 
			ohx09pcp 				   ohx12pcp  
						ohx19pcp 
			ohx25pcp 				   ohx28pcp meanpdramf;
			run;

/*Checking if the maximum interprximal CAL or PD per tooth was correctly coded for each protocol*/
/*UR and LL*/
proc print data=means (obs=100);
var SEQN	ohx02las ohx02laa ohx02lad ohx02lap ohx02maxlaURLLall
			ohx03las ohx03laa ohx03lad ohx03lap ohx03maxlaURLLall
			ohx04las ohx04laa ohx04lad ohx04lap ohx04maxlaURLLall
			ohx05las ohx05laa ohx05lad ohx05lap ohx05maxlaURLLall
			ohx06las ohx06laa ohx06lad ohx06lap ohx06maxlaURLLall
			ohx07las ohx07laa ohx07lad ohx07lap ohx07maxlaURLLall
			ohx08las ohx08laa ohx08lad ohx08lap ohx08maxlaURLLall
			ohx18las ohx18laa ohx18lad ohx18lap ohx18maxlaURLLall
			ohx19las ohx19laa ohx19lad ohx19lap ohx19maxlaURLLall
			ohx20las ohx20laa ohx20lad ohx20lap ohx20maxlaURLLall
			ohx21las ohx21laa ohx21lad ohx21lap ohx21maxlaURLLall
			ohx22las ohx22laa ohx22lad ohx22lap ohx22maxlaURLLall
			ohx23las ohx23laa ohx23lad ohx23lap ohx23maxlaURLLall
			ohx24las ohx24laa ohx24lad ohx24lap ohx24maxlaURLLall;
			run;

proc print data=means (obs=100);
var SEQN	ohx02pcs ohx02pca ohx02pcd ohx02pcp ohx02maxpcURLLall
			ohx03pcs ohx03pca ohx03pcd ohx03pcp ohx03maxpcURLLall
			ohx04pcs ohx04pca ohx04pcd ohx04pcp ohx04maxpcURLLall
			ohx05pcs ohx05pca ohx05pcd ohx05pcp ohx05maxpcURLLall
			ohx06pcs ohx06pca ohx06pcd ohx06pcp ohx06maxpcURLLall
			ohx07pcs ohx07pca ohx07pcd ohx07pcp ohx07maxpcURLLall
			ohx08pcs ohx08pca ohx08pcd ohx08pcp ohx08maxpcURLLall
			ohx18pcs ohx18pca ohx18pcd ohx18pcp ohx18maxpcURLLall
			ohx19pcs ohx19pca ohx19pcd ohx19pcp ohx19maxpcURLLall
			ohx20pcs ohx20pca ohx20pcd ohx20pcp ohx20maxpcURLLall
			ohx21pcs ohx21pca ohx21pcd ohx21pcp ohx21maxpcURLLall
			ohx22pcs ohx22pca ohx22pcd ohx22pcp ohx22maxpcURLLall
			ohx23pcs ohx23pca ohx23pcd ohx23pcp ohx23maxpcURLLall
			ohx24pcs ohx24pca ohx24pcd ohx24pcp ohx24maxpcURLLall;
			run;

/*UL and LR*/
proc print data=means (obs=100);
var SEQN	ohx09las ohx09laa ohx09lad ohx09lap ohx09maxlaULLRall
			ohx10las ohx10laa ohx10lad ohx10lap ohx10maxlaULLRall
			ohx11las ohx11laa ohx11lad ohx11lap ohx11maxlaULLRall
			ohx12las ohx12laa ohx12lad ohx12lap ohx12maxlaULLRall
			ohx13las ohx13laa ohx13lad ohx13lap ohx13maxlaULLRall
			ohx14las ohx14laa ohx14lad ohx14lap ohx14maxlaULLRall
			ohx15las ohx15laa ohx15lad ohx15lap ohx15maxlaULLRall
			ohx25las ohx25laa ohx25lad ohx25lap ohx25maxlaULLRall
			ohx26las ohx26laa ohx26lad ohx26lap ohx26maxlaULLRall
			ohx27las ohx27laa ohx27lad ohx27lap ohx27maxlaULLRall
			ohx28las ohx28laa ohx28lad ohx28lap ohx28maxlaULLRall
			ohx29las ohx29laa ohx29lad ohx29lap ohx29maxlaULLRall
			ohx30las ohx30laa ohx30lad ohx30lap ohx30maxlaULLRall
			ohx31las ohx31laa ohx31lad ohx31lap ohx31maxlaULLRall;
			run;

proc print data=means (obs=100);
var SEQN	ohx09pcs ohx09pca ohx09pcd ohx09pcp ohx09maxpcULLRall
			ohx10pcs ohx10pca ohx10pcd ohx10pcp ohx10maxpcULLRall
			ohx11pcs ohx11pca ohx11pcd ohx11pcp ohx11maxpcULLRall
			ohx12pcs ohx12pca ohx12pcd ohx12pcp ohx12maxpcULLRall
			ohx13pcs ohx13pca ohx13pcd ohx13pcp ohx13maxpcULLRall
			ohx14pcs ohx14pca ohx14pcd ohx14pcp ohx14maxpcULLRall
			ohx15pcs ohx15pca ohx15pcd ohx15pcp ohx15maxpcULLRall
			ohx25pcs ohx25pca ohx25pcd ohx25pcp ohx25maxpcULLRall
			ohx26pcs ohx26pca ohx26pcd ohx26pcp ohx26maxpcULLRall
			ohx27pcs ohx27pca ohx27pcd ohx27pcp ohx27maxpcULLRall
			ohx28pcs ohx28pca ohx28pcd ohx28pcp ohx28maxpcULLRall
			ohx29pcs ohx29pca ohx29pcd ohx29pcp ohx29maxpcULLRall
			ohx30pcs ohx30pca ohx30pcd ohx30pcp ohx30maxpcULLRall
			ohx31pcs ohx31pca ohx31pcd ohx31pcp ohx31maxpcULLRall;
			run;

/*CPITN*/
proc print data=means (obs=100);
var SEQN	ohx02las ohx02laa ohx02lad ohx02lap ohx02maxlaCPITN
			ohx03las ohx03laa ohx03lad ohx03lap ohx03maxlaCPITN
			ohx08las ohx08laa ohx08lad ohx08lap ohx08maxlaCPITN
			ohx14las ohx14laa ohx14lad ohx14lap ohx14maxlaCPITN
			ohx15las ohx15laa ohx15lad ohx15lap ohx15maxlaCPITN
			ohx18las ohx18laa ohx18lad ohx18lap ohx18maxlaCPITN
			ohx19las ohx19laa ohx19lad ohx19lap ohx19maxlaCPITN
			ohx24las ohx24laa ohx24lad ohx24lap ohx24maxlaCPITN
			ohx30las ohx30laa ohx30lad ohx30lap ohx30maxlaCPITN
			ohx31las ohx31laa ohx31lad ohx31lap ohx31maxlaCPITN;
			run;

proc print data=means (obs=100);
var SEQN	ohx02pcs ohx02pca ohx02pcd ohx02pcp ohx02maxpcCPITN
			ohx03pcs ohx03pca ohx03pcd ohx03pcp ohx03maxpcCPITN
			ohx08pcs ohx08pca ohx08pcd ohx08pcp ohx08maxpcCPITN
			ohx14pcs ohx14pca ohx14pcd ohx14pcp ohx14maxpcCPITN
			ohx15pcs ohx15pca ohx15pcd ohx15pcp ohx15maxpcCPITN
			ohx18pcs ohx18pca ohx18pcd ohx18pcp ohx18maxpcCPITN
			ohx19pcs ohx19pca ohx19pcd ohx19pcp ohx19maxpcCPITN
			ohx24pcs ohx24pca ohx24pcd ohx24pcp ohx24maxpcCPITN
			ohx30pcs ohx30pca ohx30pcd ohx30pcp ohx30maxpcCPITN
			ohx31pcs ohx31pca ohx31pcd ohx31pcp ohx31maxpcCPITN;
			run;

/*Ramfjord*/
proc print data=means (obs=100);
var SEQN	ohx03las ohx03laa ohx03lad ohx03lap ohx03maxlaramf
			ohx09las ohx09laa ohx09lad ohx09lap ohx09maxlaramf
			ohx12las ohx12laa ohx12lad ohx12lap ohx12maxlaramf
			ohx19las ohx19laa ohx19lad ohx19lap ohx19maxlaramf
			ohx25las ohx25laa ohx25lad ohx25lap ohx25maxlaramf
			ohx28las ohx28laa ohx28lad ohx28lap ohx28maxlaramf;
			run;

proc print data=means (obs=100);
var SEQN	ohx03pcs ohx03pca ohx03pcd ohx03pcp ohx03maxpcramf
			ohx09pcs ohx09pca ohx09pcd ohx09pcp ohx09maxpcramf
			ohx12pcs ohx12pca ohx12pcd ohx12pcp ohx12maxpcramf
			ohx19pcs ohx19pca ohx19pcd ohx19pcp ohx19maxpcramf
			ohx25pcs ohx25pca ohx25pcd ohx25pcp ohx25maxpcramf
			ohx28pcs ohx28pca ohx28pcd ohx28pcp ohx28maxpcramf;
			run;

/*Checking if number of teeth with thresholds of CAL/PD and periostatus were correctly coded for each protocol*/
/*FM*/
proc print data=means (obs=100);
var SEQN	ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla
			ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla 
			ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla 
			ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla
			nteeth3cal nteeth4cal nteeth5cal nteeth6cal nteeth7cal;
			run;

proc print data=means (obs=100);
var SEQN	ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc
			ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc
			ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc
			ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc
			nteeth3pd nteeth4pd nteeth5pd nteeth6pd nteeth7pd;
			run;

/*UR and LL*/
proc print data=means (obs=100);
var SEQN	ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla
			ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla 
			nteeth3calURLL nteeth4calURLL nteeth5calURLL nteeth6calURLL nteeth7calURLL;
			run;

proc print data=means (obs=100);
var SEQN	ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc
			ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc
			nteeth3pdURLL nteeth4pdURLL nteeth5pdURLL nteeth6pdURLL nteeth7pdURLL;
			run;

/*UL and LR*/
proc print data=means (obs=100);
var SEQN	ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla 
			ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla
			nteeth3calULLR nteeth4calULLR nteeth5calULLR nteeth6calULLR nteeth7calULLR;
			run;

proc print data=means (obs=100);
var SEQN	ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc
			ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc
			nteeth3pdULLR nteeth4pdULLR nteeth5pdULLR nteeth6pdULLR nteeth7pdULLR;
			run;

/*CPITN*/
proc print data=means (obs=100);
var SEQN	ohx02maxlaCPITN ohx03maxlaCPITN  						  ohx08maxlaCPITN
													  ohx14maxlaCPITN ohx15maxlaCPITN 
			ohx18maxlaCPITN ohx19maxlaCPITN  						  ohx24maxlaCPITN 
			ohx30maxlaCPITN ohx31maxlaCPITN
			nteeth3calCPITN nteeth4calCPITN nteeth5calCPITN nteeth6calCPITN nteeth7calCPITN;
			run;

proc print data=means (obs=100);
var SEQN	ohx02maxpcCPITN ohx03maxpcCPITN  						  ohx08maxpcCPITN
													  ohx14maxpcCPITN ohx15maxpcCPITN 
			ohx18maxpcCPITN ohx19maxpcCPITN  						  ohx24maxpcCPITN 
			ohx30maxpcCPITN ohx31maxpcCPITN
			nteeth3pdCPITN nteeth4pdCPITN nteeth5pdCPITN nteeth6pdCPITN nteeth7pdCPITN;
			run;

proc print data=means (obs=100);
var SEQN	nteethipxla6mmCPITN nteethipxpc5mmCPITN periostatusCPITN
			nteethipxla4mmCPITN nteethipxpc5mmCPITN periostatusCPITN
			nsitesipxloa3mmCPITN nteethipxpc4mmCPITN periostatusCPITN;
			run;

/*Ramfjord*/
proc print data=means (obs=100);
var SEQN	ohx03maxlaramf 
			ohx09maxlaramf  						  ohx12maxlaramf
										ohx19maxlaramf 
			ohx25maxlaramf 						  ohx28maxlaramf
			nteeth3calramf nteeth4calramf nteeth5calramf nteeth6calramf nteeth7calramf;
			run;

proc print data=means (obs=100);
var SEQN	ohx03maxpcramf 
			ohx09maxpcramf  						  ohx12maxpcramf
										ohx19maxpcramf 
			ohx25maxpcramf 						  ohx28maxpcramf
			nteeth3pdramf nteeth4pdramf nteeth5pdramf nteeth6pdramf nteeth7pdramf;
			run;

proc print data=means (obs=100);
var SEQN	nteethipxla6mmramf nteethipxpc5mmramf periostatusramf
			nteethipxla4mmramf nteethipxpc5mmramf periostatusramf
			nsitesipxloa3mmramf nteethipxpc4mmramf periostatusramf;
			run;

/*Getting the estimates for Table 5*/
proc means data=means n nmiss mean;
var toothcount toothcountURLL toothcountULLR toothcountCPITN toothcountramf;
run;

proc means data=means n nmiss mean;
var meancal meancalURLL meancalULLR meancalCPITN meancalramf;
run;

proc means data=means n nmiss mean;
var meanpd meanpdURLL meanpdULLR meanpdCPITN meanpdramf;
run;

proc means data=means n nmiss mean;
var nteeth3cal nteeth3calURLL nteeth3calULLR nteeth3calCPITN nteeth3calramf;
run;

proc means data=means n nmiss mean;
var nteeth4cal nteeth4calURLL nteeth4calULLR nteeth4calCPITN nteeth4calramf;
run;

proc means data=means n nmiss mean;
var nteeth5cal nteeth5calURLL nteeth5calULLR nteeth5calCPITN nteeth5calramf;
run;

proc means data=means n nmiss mean;
var nteeth6cal nteeth6calURLL nteeth6calULLR nteeth6calCPITN nteeth6calramf;
run;

proc means data=means n nmiss mean;
var nteeth7cal nteeth7calURLL nteeth7calULLR nteeth7calCPITN nteeth7calramf;
run;

proc means data=means n nmiss mean;
var nteeth3pd nteeth3pdURLL nteeth3pdULLR nteeth3pdCPITN nteeth3pdramf;
run;

proc means data=means n nmiss mean;
var nteeth4pd nteeth4pdURLL nteeth4pdULLR nteeth4pdCPITN nteeth4pdramf;
run;

proc means data=means n nmiss mean;
var nteeth5pd nteeth5pdURLL nteeth5pdULLR nteeth5pdCPITN nteeth5pdramf;
run;

proc means data=means n nmiss mean;
var nteeth6pd nteeth6pdURLL nteeth6pdULLR nteeth6pdCPITN nteeth6pdramf;
run;

proc means data=means n nmiss mean;
var nteeth7pd nteeth7pdURLL nteeth7pdULLR nteeth7pdCPITN nteeth7pdramf;
run;

/*Getting average estimates of the random half-mouth protocol over 1,000 iterations of random assignment from the macro
in section 7 after saving the outputted in permanent dataset (allmeans) in the library*/
proc means data=part.allmeans;
run;

/*Getting the sensitivity estimates for Figure S2 for the CPITN and Ramfjord protocols*/
/*Sensitivity for the random half-mouth was taken from the macro in section 7 (Table 3)*/ 
proc freq data=means;
tables periostatusCPITN*periostatus/missing;
tables periostatusramf*periostatus/missing;
run;
