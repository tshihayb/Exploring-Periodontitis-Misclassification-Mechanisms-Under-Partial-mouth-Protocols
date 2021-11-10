/***********************************************************************************/
* Programmer: Talal Alshihayb
* Date: November 9, 2021
* Purpose: Commented code to replicate "Exploring Periodontitis Misclassification Mechanisms Under Partial-mouth Protocols";
************************************************************************************/

/**************************************************************************************************************/
/* Table of contents*/
*		Code Section 1 - Creating variables from permanent dataset in analysis code			lines	16-309
* 
*  		Code section 2 - Creating upper left and upper right panels of figure 1				lines	312-528
*
*		Code section 3 - Creating lower left and lower right panels of figure 1				lines	531-748
/**************************************************************************************************************/

/*******************************************************************************/
/* Code Section 1 - Creating variables from permanent dataset in analysis code*/ 
/*******************************************************************************/

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

	array cal (28) 		cal02thresh cal03thresh cal04thresh cal05thresh cal06thresh cal07thresh cal08thresh
						cal09thresh cal10thresh cal11thresh cal12thresh cal13thresh cal14thresh cal15thresh 
						cal18thresh cal19thresh cal20thresh cal21thresh cal22thresh cal23thresh cal24thresh 
						cal25thresh cal26thresh cal27thresh cal28thresh cal29thresh cal30thresh cal31thresh;

	do count=1 to 28; lax(count)=max(of lad(count),las(count),lap(count),laa(count));
	if lax(count) ge 6 then cal(count)=1;else cal(count)=0;
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

	array pd (28) 		pd02thresh pd03thresh pd04thresh pd05thresh pd06thresh pd07thresh pd08thresh
						pd09thresh pd10thresh pd11thresh pd12thresh pd13thresh pd14thresh pd15thresh 
						pd18thresh pd19thresh pd20thresh pd21thresh pd22thresh pd23thresh pd24thresh 
						pd25thresh pd26thresh pd27thresh pd28thresh pd29thresh pd30thresh pd31thresh;

	do count=1 to 28; pcx(count)=max(of pcd(count),pcs(count),pcp(count),pca(count));
	if pcx(count) ge 5 then pd(count)=1;else pd(count)=0;
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

proc print data=one (obs=100);
var SEQN ohx02maxla cal02thresh ohx02maxpc pd02thresh;
run;


/***************************************************************************/
/* Code Section 2 - Creating upper left and upper right panels of figure 1*/ 
/***************************************************************************/
/*Clinical attachment loss*/
proc means data=one mean median min max noprint;
	var ohx02maxla ohx03maxla ohx04maxla ohx05maxla ohx06maxla ohx07maxla ohx08maxla
		ohx09maxla ohx10maxla ohx11maxla ohx12maxla ohx13maxla ohx14maxla ohx15maxla 
		ohx18maxla ohx19maxla ohx20maxla ohx21maxla ohx22maxla ohx23maxla ohx24maxla 
		ohx25maxla ohx26maxla ohx27maxla ohx28maxla ohx29maxla ohx30maxla ohx31maxla;
		output out=two;
		run;

proc print data=two;run;

data two;
	set two;
	if _n_=4;
	drop _TYPE_ _FREQ_;
	run;

proc print data=two;run;

proc transpose data=two out=two;
run;

proc print data=two;run;

data two;
	set two;
	rename COl1=meanmaxcal;
	if _n_=1 then toothnumber=2;
	if _n_=2 then toothnumber=3;
	if _n_=3 then toothnumber=4;
	if _n_=4 then toothnumber=5;
	if _n_=5 then toothnumber=6;
	if _n_=6 then toothnumber=7;
	if _n_=7 then toothnumber=8;
	if _n_=8 then toothnumber=9;
	if _n_=9 then toothnumber=10;
	if _n_=10 then toothnumber=11;
	if _n_=11 then toothnumber=12;
	if _n_=12 then toothnumber=13;
	if _n_=13 then toothnumber=14;
	if _n_=14 then toothnumber=15;
	if _n_=15 then toothnumber=18;
	if _n_=16 then toothnumber=19;
	if _n_=17 then toothnumber=20;
	if _n_=18 then toothnumber=21;
	if _n_=19 then toothnumber=22;
	if _n_=20 then toothnumber=23;
	if _n_=21 then toothnumber=24;
	if _n_=22 then toothnumber=25;
	if _n_=23 then toothnumber=26;
	if _n_=24 then toothnumber=27;
	if _n_=25 then toothnumber=28;
	if _n_=26 then toothnumber=29;
	if _n_=27 then toothnumber=30;
	if _n_=28 then toothnumber=31;
	drop _label_;
	run;

proc print data=two;run;

/*Probing depth*/
proc means data=one mean median min max noprint;
	var ohx02maxpc ohx03maxpc ohx04maxpc ohx05maxpc ohx06maxpc ohx07maxpc ohx08maxpc
		ohx09maxpc ohx10maxpc ohx11maxpc ohx12maxpc ohx13maxpc ohx14maxpc ohx15maxpc
		ohx18maxpc ohx19maxpc ohx20maxpc ohx21maxpc ohx22maxpc ohx23maxpc ohx24maxpc
		ohx25maxpc ohx26maxpc ohx27maxpc ohx28maxpc ohx29maxpc ohx30maxpc ohx31maxpc;
		output out=three;
		run;

proc print data=three;run;

data three;
	set three;
	if _n_=4;
	drop _TYPE_ _FREQ_;
	run;

proc print data=three;run;

proc transpose data=three out=three;
run;

proc print data=three;run;

data three;
	set three;
	rename COl1=meanmaxpd;
	if _n_=1 then toothnumber=2;
	if _n_=2 then toothnumber=3;
	if _n_=3 then toothnumber=4;
	if _n_=4 then toothnumber=5;
	if _n_=5 then toothnumber=6;
	if _n_=6 then toothnumber=7;
	if _n_=7 then toothnumber=8;
	if _n_=8 then toothnumber=9;
	if _n_=9 then toothnumber=10;
	if _n_=10 then toothnumber=11;
	if _n_=11 then toothnumber=12;
	if _n_=12 then toothnumber=13;
	if _n_=13 then toothnumber=14;
	if _n_=14 then toothnumber=15;
	if _n_=15 then toothnumber=18;
	if _n_=16 then toothnumber=19;
	if _n_=17 then toothnumber=20;
	if _n_=18 then toothnumber=21;
	if _n_=19 then toothnumber=22;
	if _n_=20 then toothnumber=23;
	if _n_=21 then toothnumber=24;
	if _n_=22 then toothnumber=25;
	if _n_=23 then toothnumber=26;
	if _n_=24 then toothnumber=27;
	if _n_=25 then toothnumber=28;
	if _n_=26 then toothnumber=29;
	if _n_=27 then toothnumber=30;
	if _n_=28 then toothnumber=31;
	drop _label_;
	run;

proc print data=three;run;

proc sort data=two; by descending meanmaxcal;run;

data two;
	set two;
	rank=_n_;
	value='CAL';
	rename meanmaxcal=meanmax;
	run;

proc print data=two;run;

proc sort data=three; by descending meanmaxpd;run;

data three;
	set three;
	rank=_n_;
	value='PD';
	rename meanmaxpd=meanmax;
	run;

proc print data=three;run;

proc sort data=two;by toothnumber;run;
proc sort data=three;by toothnumber;run;

data four;
	retain toothnumber meanmax rank;
	set two three;
	*by toothnumber;
	*rankmean=mean(of rankCAL,rankPD);
	drop _NAME_;
	run;

proc sort data=four; by value rank;run;

proc print data=four;run;

/*Plotting sensitivities using SG plot*/

/* Set the graphics environment */                                                                                                      
goptions reset=all noborder cback=black CPATTERN=black htitle=12pt htext=10pt;

/* Macro for defining the RBG colors*/
%macro hex2(n);
  %local digits n1 n2;
  %let digits = 0123456789ABCDEF;
  %let n1 = %substr(&digits, &n / 16 + 1, 1);
  %let n2 = %substr(&digits, &n - &n / 16 * 16 + 1, 1);
  &n1&n2
%mend hex2;

/* convert RGB triplet (r,g,b) to SAS color in hexadecimal. 
   The r, g, and b parameters are integers in the range 0--255 */
%macro RGB(r,g,b);
  %compress(CX%hex2(&r)%hex2(&g)%hex2(&b))
%mend RGB;

/*A conversion macro is needed to convert Microsoft decimal numbers to hexadecimal notation that SAS software
understands by Perry Watts*/
%macro RGBHex(rr,gg,bb);
 %sysfunc(compress(CX%sysfunc(putn(&rr,hex2.))
 %sysfunc(putn(&gg,hex2.))
 %sysfunc(putn(&bb,hex2.))))
 %mend RGBHex; 

ods graphics on/ /*reset=all*/ width=640 height=640 px;

/*CAL*/
proc sgplot data=four noautolegend;
where value='CAL';
hbar toothnumber /response=meanmax CATEGORYORDER=RESPDESC FILLATTRS=(color=cx440154) transparency=0 /*group=specialty*/;
xAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Mean of max interproximal CAL" labelattrs=(weight=bold size = 12) values=(0 to 3 by 0.5) valueattrs=(color=black size=12pt) VALUESROTATE=diagonal/*offsetmin=0.1 offsetmax=0.1;*/;
yAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Tooth" labelattrs=(weight=bold size = 12) minor /*values=(1 to 28 by 1)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
styleattrs datacolors=(cxF8766D cx00bfc4);
styleattrs wallcolor=white;
styleattrs datacontrastcolors=(cxF8766D cx00bfc4);
ODS graphics/noborder width=700 height=1000 px;;
title height=16pt 'Mean CAL';
*keylegend / title='Specialty' position=right across=1 noborder noopaque;
run;

/*PD*/
proc sgplot data=four noautolegend;
where value='PD';
hbar toothnumber /response=meanmax CATEGORYORDER=RESPDESC FILLATTRS=(color=cx440154) transparency=0 /*group=specialty*/;
xAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Mean of max interproximal PD" labelattrs=(weight=bold size = 12) values=(0 to 3 by 0.5) valueattrs=(color=black size=12pt) VALUESROTATE=diagonal/*offsetmin=0.1 offsetmax=0.1;*/;
yAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Tooth" labelattrs=(weight=bold size = 12) minor /*values=(1 to 28 by 1)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
styleattrs datacolors=(cxF8766D cx00bfc4);
styleattrs wallcolor=white;
styleattrs datacontrastcolors=(cxF8766D cx00bfc4);
ODS graphics/noborder width=700 height=1000 px;;
title height=16pt 'Mean PD';
*keylegend / title='Specialty' position=right across=1 noborder noopaque;
run;


/***************************************************************************/
/* Code Section 3 - Creating lower left and lower right panels of figure 1*/ 
/***************************************************************************/
proc means data=one mean median min max noprint;
	var cal02thresh cal03thresh cal04thresh cal05thresh cal06thresh cal07thresh cal08thresh
		cal09thresh cal10thresh cal11thresh cal12thresh cal13thresh cal14thresh cal15thresh 
		cal18thresh cal19thresh cal20thresh cal21thresh cal22thresh cal23thresh cal24thresh 
		cal25thresh cal26thresh cal27thresh cal28thresh cal29thresh cal30thresh cal31thresh;
		output out=two;
		run;

proc print data=two;run;

data two;
	set two;
	if _n_=4;
	drop _TYPE_ _FREQ_;
	run;

proc print data=two;run;

proc transpose data=two out=two;
run;

proc print data=two;run;

data two;
	set two;
	rename COl1=prop6cal;
	if _n_=1 then toothnumber=2;
	if _n_=2 then toothnumber=3;
	if _n_=3 then toothnumber=4;
	if _n_=4 then toothnumber=5;
	if _n_=5 then toothnumber=6;
	if _n_=6 then toothnumber=7;
	if _n_=7 then toothnumber=8;
	if _n_=8 then toothnumber=9;
	if _n_=9 then toothnumber=10;
	if _n_=10 then toothnumber=11;
	if _n_=11 then toothnumber=12;
	if _n_=12 then toothnumber=13;
	if _n_=13 then toothnumber=14;
	if _n_=14 then toothnumber=15;
	if _n_=15 then toothnumber=18;
	if _n_=16 then toothnumber=19;
	if _n_=17 then toothnumber=20;
	if _n_=18 then toothnumber=21;
	if _n_=19 then toothnumber=22;
	if _n_=20 then toothnumber=23;
	if _n_=21 then toothnumber=24;
	if _n_=22 then toothnumber=25;
	if _n_=23 then toothnumber=26;
	if _n_=24 then toothnumber=27;
	if _n_=25 then toothnumber=28;
	if _n_=26 then toothnumber=29;
	if _n_=27 then toothnumber=30;
	if _n_=28 then toothnumber=31;
	drop _label_;
	run;

proc print data=two;run;

/*Probing depth*/
proc means data=one mean median min max noprint;
	var pd02thresh pd03thresh pd04thresh pd05thresh pd06thresh pd07thresh pd08thresh
		pd09thresh pd10thresh pd11thresh pd12thresh pd13thresh pd14thresh pd15thresh 
		pd18thresh pd19thresh pd20thresh pd21thresh pd22thresh pd23thresh pd24thresh 
		pd25thresh pd26thresh pd27thresh pd28thresh pd29thresh pd30thresh pd31thresh;
		output out=three;
		run;

proc print data=three;run;

data three;
	set three;
	if _n_=4;
	drop _TYPE_ _FREQ_;
	run;

proc print data=three;run;

proc transpose data=three out=three;
run;

proc print data=three;run;

data three;
	set three;
	rename COl1=prop5pd;
	if _n_=1 then toothnumber=2;
	if _n_=2 then toothnumber=3;
	if _n_=3 then toothnumber=4;
	if _n_=4 then toothnumber=5;
	if _n_=5 then toothnumber=6;
	if _n_=6 then toothnumber=7;
	if _n_=7 then toothnumber=8;
	if _n_=8 then toothnumber=9;
	if _n_=9 then toothnumber=10;
	if _n_=10 then toothnumber=11;
	if _n_=11 then toothnumber=12;
	if _n_=12 then toothnumber=13;
	if _n_=13 then toothnumber=14;
	if _n_=14 then toothnumber=15;
	if _n_=15 then toothnumber=18;
	if _n_=16 then toothnumber=19;
	if _n_=17 then toothnumber=20;
	if _n_=18 then toothnumber=21;
	if _n_=19 then toothnumber=22;
	if _n_=20 then toothnumber=23;
	if _n_=21 then toothnumber=24;
	if _n_=22 then toothnumber=25;
	if _n_=23 then toothnumber=26;
	if _n_=24 then toothnumber=27;
	if _n_=25 then toothnumber=28;
	if _n_=26 then toothnumber=29;
	if _n_=27 then toothnumber=30;
	if _n_=28 then toothnumber=31;
	drop _label_;
	run;

proc print data=three;run;

proc sort data=two; by descending prop6cal;run;

data two;
	set two;
	rank=_n_;
	value='CAL';
	rename prop6cal=prop;
	run;

proc print data=two;run;

proc sort data=three; by descending prop5pd;run;

data three;
	set three;
	rank=_n_;
	value='PD';
	rename prop5pd=prop;
	run;

proc print data=three;run;

proc sort data=two;by toothnumber;run;
proc sort data=three;by toothnumber;run;

data four;
	retain toothnumber prop rank;
	set two three;
	prop=round(prop*100,0.01);
	*by toothnumber;
	*rankmean=mean(of rankCAL,rankPD);
	drop _NAME_;
	prop=prop/100;
	run;

proc sort data=four; by value rank;run;

proc print data=four;run;

/*Plotting sensitivities using SG plot*/

/* Set the graphics environment */                                                                                                      
goptions reset=all noborder cback=black CPATTERN=black htitle=12pt htext=10pt;

/* Macro for defining the RBG colors*/
%macro hex2(n);
  %local digits n1 n2;
  %let digits = 0123456789ABCDEF;
  %let n1 = %substr(&digits, &n / 16 + 1, 1);
  %let n2 = %substr(&digits, &n - &n / 16 * 16 + 1, 1);
  &n1&n2
%mend hex2;

/* convert RGB triplet (r,g,b) to SAS color in hexadecimal. 
   The r, g, and b parameters are integers in the range 0--255 */
%macro RGB(r,g,b);
  %compress(CX%hex2(&r)%hex2(&g)%hex2(&b))
%mend RGB;

/*A conversion macro is needed to convert Microsoft decimal numbers to hexadecimal notation that SAS software
understands by Perry Watts*/
%macro RGBHex(rr,gg,bb);
 %sysfunc(compress(CX%sysfunc(putn(&rr,hex2.))
 %sysfunc(putn(&gg,hex2.))
 %sysfunc(putn(&bb,hex2.))))
 %mend RGBHex; 

ods graphics on/ /*reset=all*/ width=640 height=640 px;

/*CAL*/
proc sgplot data=four noautolegend;
where value='CAL';
hbar toothnumber /response=prop CATEGORYORDER=RESPDESC FILLATTRS=(color=cx440154) transparency=0 /*group=specialty*/;
xAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Proportion with CAL=6 mm or more" labelattrs=(weight=bold size = 12) values=(0 to .07 by .01) valueattrs=(color=black size=12pt) VALUESROTATE=diagonal/*offsetmin=0.1 offsetmax=0.1;*/;
yAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Tooth" labelattrs=(weight=bold size = 12) minor /*values=(1 to 28 by 1)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
styleattrs datacolors=(cxF8766D cx00bfc4);
styleattrs wallcolor=white;
styleattrs datacontrastcolors=(cxF8766D cx00bfc4);
ODS graphics/noborder width=700 height=1000 px;;
title height=16pt 'Proportion with CAL=6 mm or more';
*keylegend / title='Specialty' position=right across=1 noborder noopaque;
run;

/*PD*/
proc sgplot data=four noautolegend;
where value='PD';
hbar toothnumber /response=prop CATEGORYORDER=RESPDESC FILLATTRS=(color=cx440154) transparency=0 /*group=specialty*/;
xAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Proportion with PD=5 mm or more" labelattrs=(weight=bold size = 12) values=(0 to .07 by .01) valueattrs=(color=black size=12pt) VALUESROTATE=diagonal/*offsetmin=0.1 offsetmax=0.1;*/;
yAXIS grid GRIDATTRS=(color=%rgbhex(229,229,229)) display=(noline) label = "Tooth" labelattrs=(weight=bold size = 12) minor /*values=(1 to 28 by 1)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
styleattrs datacolors=(cxF8766D cx00bfc4);
styleattrs wallcolor=white;
styleattrs datacontrastcolors=(cxF8766D cx00bfc4);
ODS graphics/noborder width=700 height=1000 px;;
title height=16pt 'Proportion with PD=5 mm or more';
*keylegend / title='Specialty' position=right across=1 noborder noopaque;
run;
