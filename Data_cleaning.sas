/***********************************************************************************/
* Programmer: Talal Alshihayb
* Date: November 9, 2021
* Purpose: Commented code to replicate "Exploring Periodontitis Misclassification Mechanisms Under Partial-mouth Protocols";
************************************************************************************/

/**************************************************************************************************************/
/* Table of contents*/
*		Code Section 1 - Downloading and cleaning datasets									lines	15-314
* 
*  		Code section 2 - Stacking all three cycles in one dataset
*						 and saving it as a permanent dataset								lines	316-328
/**************************************************************************************************************/

/******************************************************/
/* Code Section 1 - Downloading and cleaning datasets*/ 
/******************************************************/

/* Set working directory to your location*/;
libname raw 'C:\Users\Tshih\OneDrive\Periodontal side differences in NHANES\Raw data';


/*********************************************************************************************************/
/**********************************Downloading raw datasets from the links below**************************/
/*******************************************and open them in SAS******************************************/
/*********************************************************************************************************/

/* Required datasets for cycle 2009-2010*/
/*https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/DEMO_F.XPT
https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/OHXDEN_F.XPT
https://wwwn.cdc.gov/Nchs/Nhanes/2009-2010/OHXPER_F.XPT*/

/* Required datasets for cycle 2011-2012*/
/*https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DEMO_G.XPT
https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/OHXDEN_G.XPT
https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/OHXPER_G.XPT*/

/* Required datasets for cycle 2013-2014*/
/*https://wwwn.cdc.gov/Nchs/Nhanes/2013-2014/DEMO_H.XPT
https://wwwn.cdc.gov/Nchs/Nhanes/2013-2014/OHXDEN_H.XPT
https://wwwn.cdc.gov/Nchs/Nhanes/2013-2014/OHXPER_H.XPT*/

/*********************************************************************************************************/
/**********************************Cleaning datasets******************************************************/
/*********************************************************************************************************/

/* NHANES 2009-2010*/
proc sort data=ohxden_f; by SEQN;run;

proc sort data=ohxper_f; by SEQN;run;

proc sort data=demo_f; by SEQN;run;

data one;
	merge ohxden_f ohxper_f demo_f;
	by SEQN;

	array lad (32)  	ohx01lad ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad ohx16lad 
						ohx17lad ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad ohx32lad;

	array lam (32)		ohx01lam ohx02lam ohx03lam ohx04lam ohx05lam ohx06lam ohx07lam ohx08lam
						ohx09lam ohx10lam ohx11lam ohx12lam ohx13lam ohx14lam ohx15lam ohx16lam 
						ohx17lam ohx18lam ohx19lam ohx20lam ohx21lam ohx22lam ohx23lam ohx24lam 
						ohx25lam ohx26lam ohx27lam ohx28lam ohx29lam ohx30lam ohx31lam ohx32lam;

	array las (32) 		ohx01las ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las ohx16las
						ohx17las ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las ohx32las;

	array lap (32) 		ohx01lap ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap ohx16lap 
						ohx17lap ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap ohx32lap;

	array lal (32) 		ohx01lal ohx02lal ohx03lal ohx04lal ohx05lal ohx06lal ohx07lal ohx08lal 
						ohx09lal ohx10lal ohx11lal ohx12lal ohx13lal ohx14lal ohx15lal ohx16lal
						ohx17lal ohx18lal ohx19lal ohx20lal ohx21lal ohx22lal ohx23lal ohx24lal 
						ohx25lal ohx26lal ohx27lal ohx28lal ohx29lal ohx30lal ohx31lal ohx32lal;

	array laa (32)		ohx01laa ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa ohx16laa
						ohx17laa ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa ohx32laa;

	array pcd (32)  	ohx01pcd ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd ohx16pcd
						ohx17pcd ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd ohx32pcd;

	array pcm (32)  	ohx01pcm ohx02pcm ohx03pcm ohx04pcm ohx05pcm ohx06pcm ohx07pcm ohx08pcm
						ohx09pcm ohx10pcm ohx11pcm ohx12pcm ohx13pcm ohx14pcm ohx15pcm ohx16pcm
						ohx17pcm ohx18pcm ohx19pcm ohx20pcm ohx21pcm ohx22pcm ohx23pcm ohx24pcm
						ohx25pcm ohx26pcm ohx27pcm ohx28pcm ohx29pcm ohx30pcm ohx31pcm ohx32pcm; 

	array pcs (32) 		ohx01pcs ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs ohx16pcs
						ohx17pcs ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs ohx32pcs;

	array pcp (32) 		ohx01pcp ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp ohx16pcp
						ohx17pcp ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp ohx32pcp;

	array pcl (32)  	ohx01pcl ohx02pcl ohx03pcl ohx04pcl ohx05pcl ohx06pcl ohx07pcl ohx08pcl
						ohx09pcl ohx10pcl ohx11pcl ohx12pcl ohx13pcl ohx14pcl ohx15pcl ohx16pcl
						ohx17pcl ohx18pcl ohx19pcl ohx20pcl ohx21pcl ohx22pcl ohx23pcl ohx24pcl
						ohx25pcl ohx26pcl ohx27pcl ohx28pcl ohx29pcl ohx30pcl ohx31pcl ohx32pcl;

	array pca (32) 		ohx01pca ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca ohx16pca
						ohx17pca ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca ohx32pca;

	do count=1 to 32;
	if lad(count)=99 then lad(count)=.;
	if lam(count)=99 then lam(count)=.;
	if las(count)=99 then las(count)=.;
	if lap(count)=99 then lap(count)=.;
	if lal(count)=99 then lal(count)=.;
	if laa(count)=99 then laa(count)=.;

	if pcd(count)=99 then pcd(count)=.;
	if pcm(count)=99 then pcm(count)=.;
	if pcs(count)=99 then pcs(count)=.;
	if pcp(count)=99 then pcp(count)=.;
	if pcl(count)=99 then pcl(count)=.;
	if pca(count)=99 then pca(count)=.;
	end;
	drop count;
	run;


/* NHANES 2011-2012*/
proc sort data=ohxden_g; by SEQN;run;

proc sort data=ohxper_g; by SEQN;run;

proc sort data=demo_g; by SEQN;run;

data one2;
	merge ohxden_g ohxper_g demo_g;
	by SEQN;

	array lad (32)  	ohx01lad ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad ohx16lad 
						ohx17lad ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad ohx32lad;

	array lam (32)		ohx01lam ohx02lam ohx03lam ohx04lam ohx05lam ohx06lam ohx07lam ohx08lam
						ohx09lam ohx10lam ohx11lam ohx12lam ohx13lam ohx14lam ohx15lam ohx16lam 
						ohx17lam ohx18lam ohx19lam ohx20lam ohx21lam ohx22lam ohx23lam ohx24lam 
						ohx25lam ohx26lam ohx27lam ohx28lam ohx29lam ohx30lam ohx31lam ohx32lam;

	array las (32) 		ohx01las ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las ohx16las
						ohx17las ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las ohx32las;

	array lap (32) 		ohx01lap ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap ohx16lap 
						ohx17lap ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap ohx32lap;

	array lal (32) 		ohx01lal ohx02lal ohx03lal ohx04lal ohx05lal ohx06lal ohx07lal ohx08lal 
						ohx09lal ohx10lal ohx11lal ohx12lal ohx13lal ohx14lal ohx15lal ohx16lal
						ohx17lal ohx18lal ohx19lal ohx20lal ohx21lal ohx22lal ohx23lal ohx24lal 
						ohx25lal ohx26lal ohx27lal ohx28lal ohx29lal ohx30lal ohx31lal ohx32lal;

	array laa (32)		ohx01laa ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa ohx16laa
						ohx17laa ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa ohx32laa;

	array pcd (32)  	ohx01pcd ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd ohx16pcd
						ohx17pcd ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd ohx32pcd;

	array pcm (32)  	ohx01pcm ohx02pcm ohx03pcm ohx04pcm ohx05pcm ohx06pcm ohx07pcm ohx08pcm
						ohx09pcm ohx10pcm ohx11pcm ohx12pcm ohx13pcm ohx14pcm ohx15pcm ohx16pcm
						ohx17pcm ohx18pcm ohx19pcm ohx20pcm ohx21pcm ohx22pcm ohx23pcm ohx24pcm
						ohx25pcm ohx26pcm ohx27pcm ohx28pcm ohx29pcm ohx30pcm ohx31pcm ohx32pcm; 

	array pcs (32) 		ohx01pcs ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs ohx16pcs
						ohx17pcs ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs ohx32pcs;

	array pcp (32) 		ohx01pcp ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp ohx16pcp
						ohx17pcp ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp ohx32pcp;

	array pcl (32)  	ohx01pcl ohx02pcl ohx03pcl ohx04pcl ohx05pcl ohx06pcl ohx07pcl ohx08pcl
						ohx09pcl ohx10pcl ohx11pcl ohx12pcl ohx13pcl ohx14pcl ohx15pcl ohx16pcl
						ohx17pcl ohx18pcl ohx19pcl ohx20pcl ohx21pcl ohx22pcl ohx23pcl ohx24pcl
						ohx25pcl ohx26pcl ohx27pcl ohx28pcl ohx29pcl ohx30pcl ohx31pcl ohx32pcl;

	array pca (32) 		ohx01pca ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca ohx16pca
						ohx17pca ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca ohx32pca;

	do count=1 to 32;
	if lad(count)=99 then lad(count)=.;
	if lam(count)=99 then lam(count)=.;
	if las(count)=99 then las(count)=.;
	if lap(count)=99 then lap(count)=.;
	if lal(count)=99 then lal(count)=.;
	if laa(count)=99 then laa(count)=.;

	if pcd(count)=99 then pcd(count)=.;
	if pcm(count)=99 then pcm(count)=.;
	if pcs(count)=99 then pcs(count)=.;
	if pcp(count)=99 then pcp(count)=.;
	if pcl(count)=99 then pcl(count)=.;
	if pca(count)=99 then pca(count)=.;
	end;
	drop count;
	run;


/* NHANES 2013-2014*/
proc sort data=ohxden_h; by SEQN;run;

proc sort data=ohxper_h; by SEQN;run;

proc sort data=demo_h; by SEQN;run;

data one3;
	merge ohxden_h ohxper_h demo_h;
	by SEQN;

	array lad (32)  	ohx01lad ohx02lad ohx03lad ohx04lad ohx05lad ohx06lad ohx07lad ohx08lad
						ohx09lad ohx10lad ohx11lad ohx12lad ohx13lad ohx14lad ohx15lad ohx16lad 
						ohx17lad ohx18lad ohx19lad ohx20lad ohx21lad ohx22lad ohx23lad ohx24lad 
						ohx25lad ohx26lad ohx27lad ohx28lad ohx29lad ohx30lad ohx31lad ohx32lad;

	array lam (32)		ohx01lam ohx02lam ohx03lam ohx04lam ohx05lam ohx06lam ohx07lam ohx08lam
						ohx09lam ohx10lam ohx11lam ohx12lam ohx13lam ohx14lam ohx15lam ohx16lam 
						ohx17lam ohx18lam ohx19lam ohx20lam ohx21lam ohx22lam ohx23lam ohx24lam 
						ohx25lam ohx26lam ohx27lam ohx28lam ohx29lam ohx30lam ohx31lam ohx32lam;

	array las (32) 		ohx01las ohx02las ohx03las ohx04las ohx05las ohx06las ohx07las ohx08las 
						ohx09las ohx10las ohx11las ohx12las ohx13las ohx14las ohx15las ohx16las
						ohx17las ohx18las ohx19las ohx20las ohx21las ohx22las ohx23las ohx24las 
						ohx25las ohx26las ohx27las ohx28las ohx29las ohx30las ohx31las ohx32las;

	array lap (32) 		ohx01lap ohx02lap ohx03lap ohx04lap ohx05lap ohx06lap ohx07lap ohx08lap 
						ohx09lap ohx10lap ohx11lap ohx12lap ohx13lap ohx14lap ohx15lap ohx16lap 
						ohx17lap ohx18lap ohx19lap ohx20lap ohx21lap ohx22lap ohx23lap ohx24lap 
						ohx25lap ohx26lap ohx27lap ohx28lap ohx29lap ohx30lap ohx31lap ohx32lap;

	array lal (32) 		ohx01lal ohx02lal ohx03lal ohx04lal ohx05lal ohx06lal ohx07lal ohx08lal 
						ohx09lal ohx10lal ohx11lal ohx12lal ohx13lal ohx14lal ohx15lal ohx16lal
						ohx17lal ohx18lal ohx19lal ohx20lal ohx21lal ohx22lal ohx23lal ohx24lal 
						ohx25lal ohx26lal ohx27lal ohx28lal ohx29lal ohx30lal ohx31lal ohx32lal;

	array laa (32)		ohx01laa ohx02laa ohx03laa ohx04laa ohx05laa ohx06laa ohx07laa ohx08laa 
						ohx09laa ohx10laa ohx11laa ohx12laa ohx13laa ohx14laa ohx15laa ohx16laa
						ohx17laa ohx18laa ohx19laa ohx20laa ohx21laa ohx22laa ohx23laa ohx24laa 
						ohx25laa ohx26laa ohx27laa ohx28laa ohx29laa ohx30laa ohx31laa ohx32laa;

	array pcd (32)  	ohx01pcd ohx02pcd ohx03pcd ohx04pcd ohx05pcd ohx06pcd ohx07pcd ohx08pcd
						ohx09pcd ohx10pcd ohx11pcd ohx12pcd ohx13pcd ohx14pcd ohx15pcd ohx16pcd
						ohx17pcd ohx18pcd ohx19pcd ohx20pcd ohx21pcd ohx22pcd ohx23pcd ohx24pcd
						ohx25pcd ohx26pcd ohx27pcd ohx28pcd ohx29pcd ohx30pcd ohx31pcd ohx32pcd;

	array pcm (32)  	ohx01pcm ohx02pcm ohx03pcm ohx04pcm ohx05pcm ohx06pcm ohx07pcm ohx08pcm
						ohx09pcm ohx10pcm ohx11pcm ohx12pcm ohx13pcm ohx14pcm ohx15pcm ohx16pcm
						ohx17pcm ohx18pcm ohx19pcm ohx20pcm ohx21pcm ohx22pcm ohx23pcm ohx24pcm
						ohx25pcm ohx26pcm ohx27pcm ohx28pcm ohx29pcm ohx30pcm ohx31pcm ohx32pcm; 

	array pcs (32) 		ohx01pcs ohx02pcs ohx03pcs ohx04pcs ohx05pcs ohx06pcs ohx07pcs ohx08pcs
						ohx09pcs ohx10pcs ohx11pcs ohx12pcs ohx13pcs ohx14pcs ohx15pcs ohx16pcs
						ohx17pcs ohx18pcs ohx19pcs ohx20pcs ohx21pcs ohx22pcs ohx23pcs ohx24pcs
						ohx25pcs ohx26pcs ohx27pcs ohx28pcs ohx29pcs ohx30pcs ohx31pcs ohx32pcs;

	array pcp (32) 		ohx01pcp ohx02pcp ohx03pcp ohx04pcp ohx05pcp ohx06pcp ohx07pcp ohx08pcp
						ohx09pcp ohx10pcp ohx11pcp ohx12pcp ohx13pcp ohx14pcp ohx15pcp ohx16pcp
						ohx17pcp ohx18pcp ohx19pcp ohx20pcp ohx21pcp ohx22pcp ohx23pcp ohx24pcp
						ohx25pcp ohx26pcp ohx27pcp ohx28pcp ohx29pcp ohx30pcp ohx31pcp ohx32pcp;

	array pcl (32)  	ohx01pcl ohx02pcl ohx03pcl ohx04pcl ohx05pcl ohx06pcl ohx07pcl ohx08pcl
						ohx09pcl ohx10pcl ohx11pcl ohx12pcl ohx13pcl ohx14pcl ohx15pcl ohx16pcl
						ohx17pcl ohx18pcl ohx19pcl ohx20pcl ohx21pcl ohx22pcl ohx23pcl ohx24pcl
						ohx25pcl ohx26pcl ohx27pcl ohx28pcl ohx29pcl ohx30pcl ohx31pcl ohx32pcl;

	array pca (32) 		ohx01pca ohx02pca ohx03pca ohx04pca ohx05pca ohx06pca ohx07pca ohx08pca
						ohx09pca ohx10pca ohx11pca ohx12pca ohx13pca ohx14pca ohx15pca ohx16pca
						ohx17pca ohx18pca ohx19pca ohx20pca ohx21pca ohx22pca ohx23pca ohx24pca
						ohx25pca ohx26pca ohx27pca ohx28pca ohx29pca ohx30pca ohx31pca ohx32pca;

	do count=1 to 32;
	if lad(count)=99 then lad(count)=.;
	if lam(count)=99 then lam(count)=.;
	if las(count)=99 then las(count)=.;
	if lap(count)=99 then lap(count)=.;
	if lal(count)=99 then lal(count)=.;
	if laa(count)=99 then laa(count)=.;

	if pcd(count)=99 then pcd(count)=.;
	if pcm(count)=99 then pcm(count)=.;
	if pcs(count)=99 then pcs(count)=.;
	if pcp(count)=99 then pcp(count)=.;
	if pcl(count)=99 then pcl(count)=.;
	if pca(count)=99 then pca(count)=.;
	end;
	drop count;
	run;

/***************************************************************************************************/
/* Code Section 2 - Stacking all three cycles iin one dataset and saving it as a permanent dataset*/ 
/***************************************************************************************************/

/* Setting another library for analytic data in another location than the raw data library*/
libname part 'C:\Users\Tshih\OneDrive\Periodontal side differences in NHANES\Analytic data';

/* Merging all three NHANES cycles in one dataset and saving it in the library (part)*/
data part.perio0914; 
	set work.one
		work.one2
		work.one3;
		run;
