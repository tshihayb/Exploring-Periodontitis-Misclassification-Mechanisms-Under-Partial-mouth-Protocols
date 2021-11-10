/***********************************************************************************/
* Programmer: Talal Alshihayb
* Date: November 9, 2021
* Purpose: Commented code to replicate "Periodontal side differences in NHANES";
************************************************************************************/

/**************************************************************************************************************/
/* Table of contents*/
*		Code Section 1 - Creating variables from permanent dataset in analysis code			lines	15-1340
* 
*  		Code section 2 - Creating figure													lines	1342-1412
/**************************************************************************************************************/

/*******************************************************************************/
/* Code Section 1 - Creating variables from permanent dataset in analysis code*/ 
/*******************************************************************************/
/*Setting some options for display*/;
options nocenter nofmterr;
options linesize=200; 

/*Loading the library that we saved the permanent dataset in we created from data cleaning (perio0914) code*/
libname part 'C:\Users\Tshih\OneDrive\Periodontal side differences in NHANES\Analytic data';

/*UR*/
proc freq data=part.URsens;
tables periostatusURmb*periostatus/missing nopercent norow out=URsen1;
tables periostatusURml*periostatus/missing nopercent norow out=URsen2;
tables periostatusURdb*periostatus/missing nopercent norow out=URsen3;
tables periostatusURdl*periostatus/missing nopercent norow out=URsen4;
tables periostatusURmbml*periostatus/missing nopercent norow out=URsen5;
tables periostatusURdbdl*periostatus/missing nopercent norow out=URsen6;
tables periostatusURmbdb*periostatus/missing nopercent norow out=URsen7;
tables periostatusURmldl*periostatus/missing nopercent norow out=URsen8;
tables periostatusURmbdl*periostatus/missing nopercent norow out=URsen9;
tables periostatusURmldb*periostatus/missing nopercent norow out=URsen10;
tables periostatusURall*periostatus/missing nopercent norow out=URsen11;
run;
	
data URsen1;
	set URsen1;
	if _n_=5;
	site='MB';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen2;
	set URsen2;
	if _n_=5;
	site='ML';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen3;
	set URsen3;
	if _n_=5;
	site='DB';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen4;
	set URsen4;
	if _n_=5;
	site='DL';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen5;
	set URsen5;
	if _n_=5;
	site='MBML';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen6;
	set URsen6;
	if _n_=5;
	site='DBDL';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen7;
	set URsen7;
	if _n_=5;
	site='MBDB';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen8;
	set URsen8;
	if _n_=5;
	site='MLDL';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen9;
	set URsen9;
	if _n_=5;
	site='MBDL';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen10;
	set URsen10;
	if _n_=5;
	site='MLDB';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;

data URsen11;
	set URsen11;
	if _n_=5;
	site='All';
	nteeth=7;
	quad='UR';
	keep count site nteeth quad;
	run;


/*UL*/
proc freq data=part.ULsens;
tables periostatusULmb*periostatus/missing nopercent norow out=ULsen1;
tables periostatusULml*periostatus/missing nopercent norow out=ULsen2;
tables periostatusULdb*periostatus/missing nopercent norow out=ULsen3;
tables periostatusULdl*periostatus/missing nopercent norow out=ULsen4;
tables periostatusULmbml*periostatus/missing nopercent norow out=ULsen5;
tables periostatusULdbdl*periostatus/missing nopercent norow out=ULsen6;
tables periostatusULmbdb*periostatus/missing nopercent norow out=ULsen7;
tables periostatusULmldl*periostatus/missing nopercent norow out=ULsen8;
tables periostatusULmbdl*periostatus/missing nopercent norow out=ULsen9;
tables periostatusULmldb*periostatus/missing nopercent norow out=ULsen10;
tables periostatusULall*periostatus/missing nopercent norow out=ULsen11;
run;
	
data ULsen1;
	set ULsen1;
	if _n_=5;
	site='MB';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen2;
	set ULsen2;
	if _n_=5;
	site='ML';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen3;
	set ULsen3;
	if _n_=5;
	site='DB';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen4;
	set ULsen4;
	if _n_=5;
	site='DL';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen5;
	set ULsen5;
	if _n_=5;
	site='MBML';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen6;
	set ULsen6;
	if _n_=5;
	site='DBDL';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen7;
	set ULsen7;
	if _n_=5;
	site='MBDB';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen8;
	set ULsen8;
	if _n_=5;
	site='MLDL';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen9;
	set ULsen9;
	if _n_=5;
	site='MBDL';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen10;
	set ULsen10;
	if _n_=5;
	site='MLDB';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;

data ULsen11;
	set ULsen11;
	if _n_=5;
	site='All';
	nteeth=7;
	quad='UL';
	keep count site nteeth quad;
	run;


/*LL*/
proc freq data=part.LLsens;
tables periostatusLLmb*periostatus/missing nopercent norow out=LLsen1;
tables periostatusLLml*periostatus/missing nopercent norow out=LLsen2;
tables periostatusLLdb*periostatus/missing nopercent norow out=LLsen3;
tables periostatusLLdl*periostatus/missing nopercent norow out=LLsen4;
tables periostatusLLmbml*periostatus/missing nopercent norow out=LLsen5;
tables periostatusLLdbdl*periostatus/missing nopercent norow out=LLsen6;
tables periostatusLLmbdb*periostatus/missing nopercent norow out=LLsen7;
tables periostatusLLmldl*periostatus/missing nopercent norow out=LLsen8;
tables periostatusLLmbdl*periostatus/missing nopercent norow out=LLsen9;
tables periostatusLLmldb*periostatus/missing nopercent norow out=LLsen10;
tables periostatusLLall*periostatus/missing nopercent norow out=LLsen11;
run;
	
data LLsen1;
	set LLsen1;
	if _n_=5;
	site='MB';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen2;
	set LLsen2;
	if _n_=5;
	site='ML';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen3;
	set LLsen3;
	if _n_=5;
	site='DB';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen4;
	set LLsen4;
	if _n_=5;
	site='DL';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen5;
	set LLsen5;
	if _n_=5;
	site='MBML';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen6;
	set LLsen6;
	if _n_=5;
	site='DBDL';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen7;
	set LLsen7;
	if _n_=5;
	site='MBDB';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen8;
	set LLsen8;
	if _n_=5;
	site='MLDL';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen9;
	set LLsen9;
	if _n_=5;
	site='MBDL';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen10;
	set LLsen10;
	if _n_=5;
	site='MLDB';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;

data LLsen11;
	set LLsen11;
	if _n_=5;
	site='All';
	nteeth=7;
	quad='LL';
	keep count site nteeth quad;
	run;


/*LR*/
proc freq data=part.LRsens;
tables periostatusLRmb*periostatus/missing nopercent norow out=LRsen1;
tables periostatusLRml*periostatus/missing nopercent norow out=LRsen2;
tables periostatusLRdb*periostatus/missing nopercent norow out=LRsen3;
tables periostatusLRdl*periostatus/missing nopercent norow out=LRsen4;
tables periostatusLRmbml*periostatus/missing nopercent norow out=LRsen5;
tables periostatusLRdbdl*periostatus/missing nopercent norow out=LRsen6;
tables periostatusLRmbdb*periostatus/missing nopercent norow out=LRsen7;
tables periostatusLRmldl*periostatus/missing nopercent norow out=LRsen8;
tables periostatusLRmbdl*periostatus/missing nopercent norow out=LRsen9;
tables periostatusLRmldb*periostatus/missing nopercent norow out=LRsen10;
tables periostatusLRall*periostatus/missing nopercent norow out=LRsen11;
run;
	
data LRsen1;
	set LRsen1;
	if _n_=5;
	site='MB';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen2;
	set LRsen2;
	if _n_=5;
	site='ML';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen3;
	set LRsen3;
	if _n_=5;
	site='DB';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen4;
	set LRsen4;
	if _n_=5;
	site='DL';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen5;
	set LRsen5;
	if _n_=5;
	site='MBML';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen6;
	set LRsen6;
	if _n_=5;
	site='DBDL';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen7;
	set LRsen7;
	if _n_=5;
	site='MBDB';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen8;
	set LRsen8;
	if _n_=5;
	site='MLDL';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen9;
	set LRsen9;
	if _n_=5;
	site='MBDL';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen10;
	set LRsen10;
	if _n_=5;
	site='MLDB';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;

data LRsen11;
	set LRsen11;
	if _n_=5;
	site='All';
	nteeth=7;
	quad='LR';
	keep count site nteeth quad;
	run;


/*UR and LL sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusURLLmb*periostatus/missing nopercent norow out=URLLsen1;
tables periostatusURLLml*periostatus/missing nopercent norow out=URLLsen2;
tables periostatusURLLdb*periostatus/missing nopercent norow out=URLLsen3;
tables periostatusURLLdl*periostatus/missing nopercent norow out=URLLsen4;
tables periostatusURLLmbml*periostatus/missing nopercent norow out=URLLsen5;
tables periostatusURLLdbdl*periostatus/missing nopercent norow out=URLLsen6;
tables periostatusURLLmbdb*periostatus/missing nopercent norow out=URLLsen7;
tables periostatusURLLmldl*periostatus/missing nopercent norow out=URLLsen8;
tables periostatusURLLmbdl*periostatus/missing nopercent norow out=URLLsen9;
tables periostatusURLLmldb*periostatus/missing nopercent norow out=URLLsen10;
tables periostatusURLLall*periostatus/missing nopercent norow out=URLLsen11;
run;

data URLLsen1;
	set URLLsen1;
	if _n_=5;
	site='MB';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen2;
	set URLLsen2;
	if _n_=5;
	site='ML';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen3;
	set URLLsen3;
	if _n_=5;
	site='DB';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen4;
	set URLLsen4;
	if _n_=5;
	site='DL';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen5;
	set URLLsen5;
	if _n_=5;
	site='MBML';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen6;
	set URLLsen6;
	if _n_=5;
	site='DBDL';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen7;
	set URLLsen7;
	if _n_=5;
	site='MBDB';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen8;
	set URLLsen8;
	if _n_=5;
	site='MLDL';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen9;
	set URLLsen9;
	if _n_=5;
	site='MBDL';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen10;
	set URLLsen10;
	if _n_=5;
	site='MLDB';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;

data URLLsen11;
	set URLLsen11;
	if _n_=5;
	site='All';
	nteeth=14;
	quad='URLL';
	keep count site nteeth quad;
	run;


/*UR and LR sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusURLRmb*periostatus/missing nopercent norow out=URLRsen1;
tables periostatusURLRml*periostatus/missing nopercent norow out=URLRsen2;
tables periostatusURLRdb*periostatus/missing nopercent norow out=URLRsen3;
tables periostatusURLRdl*periostatus/missing nopercent norow out=URLRsen4;
tables periostatusURLRmbml*periostatus/missing nopercent norow out=URLRsen5;
tables periostatusURLRdbdl*periostatus/missing nopercent norow out=URLRsen6;
tables periostatusURLRmbdb*periostatus/missing nopercent norow out=URLRsen7;
tables periostatusURLRmldl*periostatus/missing nopercent norow out=URLRsen8;
tables periostatusURLRmbdl*periostatus/missing nopercent norow out=URLRsen9;
tables periostatusURLRmldb*periostatus/missing nopercent norow out=URLRsen10;
tables periostatusURLRall*periostatus/missing nopercent norow out=URLRsen11;
run;

data URLRsen1;
	set URLRsen1;
	if _n_=5;
	site='MB';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen2;
	set URLRsen2;
	if _n_=5;
	site='ML';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen3;
	set URLRsen3;
	if _n_=5;
	site='DB';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen4;
	set URLRsen4;
	if _n_=5;
	site='DL';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen5;
	set URLRsen5;
	if _n_=5;
	site='MBML';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen6;
	set URLRsen6;
	if _n_=5;
	site='DBDL';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen7;
	set URLRsen7;
	if _n_=5;
	site='MBDB';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen8;
	set URLRsen8;
	if _n_=5;
	site='MLDL';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen9;
	set URLRsen9;
	if _n_=5;
	site='MBDL';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen10;
	set URLRsen10;
	if _n_=5;
	site='MLDB';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;

data URLRsen11;
	set URLRsen11;
	if _n_=5;
	site='All';
	nteeth=14;
	quad='URLR';
	keep count site nteeth quad;
	run;


/*UR and UL sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusURULmb*periostatus/missing nopercent norow out=URULsen1;
tables periostatusURULml*periostatus/missing nopercent norow out=URULsen2;
tables periostatusURULdb*periostatus/missing nopercent norow out=URULsen3;
tables periostatusURULdl*periostatus/missing nopercent norow out=URULsen4;
tables periostatusURULmbml*periostatus/missing nopercent norow out=URULsen5;
tables periostatusURULdbdl*periostatus/missing nopercent norow out=URULsen6;
tables periostatusURULmbdb*periostatus/missing nopercent norow out=URULsen7;
tables periostatusURULmldl*periostatus/missing nopercent norow out=URULsen8;
tables periostatusURULmbdl*periostatus/missing nopercent norow out=URULsen9;
tables periostatusURULmldb*periostatus/missing nopercent norow out=URULsen10;
tables periostatusURULall*periostatus/missing nopercent norow out=URULsen11;
run;

data URULsen1;
	set URULsen1;
	if _n_=5;
	site='MB';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen2;
	set URULsen2;
	if _n_=5;
	site='ML';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen3;
	set URULsen3;
	if _n_=5;
	site='DB';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen4;
	set URULsen4;
	if _n_=5;
	site='DL';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen5;
	set URULsen5;
	if _n_=5;
	site='MBML';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen6;
	set URULsen6;
	if _n_=5;
	site='DBDL';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen7;
	set URULsen7;
	if _n_=5;
	site='MBDB';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen8;
	set URULsen8;
	if _n_=5;
	site='MLDL';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen9;
	set URULsen9;
	if _n_=5;
	site='MBDL';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen10;
	set URULsen10;
	if _n_=5;
	site='MLDB';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;

data URULsen11;
	set URULsen11;
	if _n_=5;
	site='All';
	nteeth=14;
	quad='URUL';
	keep count site nteeth quad;
	run;


/*UL and LR sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusULLRmb*periostatus/missing nopercent norow out=ULLRsen1;
tables periostatusULLRml*periostatus/missing nopercent norow out=ULLRsen2;
tables periostatusULLRdb*periostatus/missing nopercent norow out=ULLRsen3;
tables periostatusULLRdl*periostatus/missing nopercent norow out=ULLRsen4;
tables periostatusULLRmbml*periostatus/missing nopercent norow out=ULLRsen5;
tables periostatusULLRdbdl*periostatus/missing nopercent norow out=ULLRsen6;
tables periostatusULLRmbdb*periostatus/missing nopercent norow out=ULLRsen7;
tables periostatusULLRmldl*periostatus/missing nopercent norow out=ULLRsen8;
tables periostatusULLRmbdl*periostatus/missing nopercent norow out=ULLRsen9;
tables periostatusULLRmldb*periostatus/missing nopercent norow out=ULLRsen10;
tables periostatusULLRall*periostatus/missing nopercent norow out=ULLRsen11;
run;

data ULLRsen1;
	set ULLRsen1;
	if _n_=5;
	site='MB';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen2;
	set ULLRsen2;
	if _n_=5;
	site='ML';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen3;
	set ULLRsen3;
	if _n_=5;
	site='DB';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen4;
	set ULLRsen4;
	if _n_=5;
	site='DL';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen5;
	set ULLRsen5;
	if _n_=5;
	site='MBML';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen6;
	set ULLRsen6;
	if _n_=5;
	site='DBDL';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen7;
	set ULLRsen7;
	if _n_=5;
	site='MBDB';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen8;
	set ULLRsen8;
	if _n_=5;
	site='MLDL';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen9;
	set ULLRsen9;
	if _n_=5;
	site='MBDL';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen10;
	set ULLRsen10;
	if _n_=5;
	site='MLDB';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;

data ULLRsen11;
	set ULLRsen11;
	if _n_=5;
	site='All';
	nteeth=14;
	quad='ULLR';
	keep count site nteeth quad;
	run;


/*UL and LL sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusULLLmb*periostatus/missing nopercent norow out=ULLLsen1;
tables periostatusULLLml*periostatus/missing nopercent norow out=ULLLsen2;
tables periostatusULLLdb*periostatus/missing nopercent norow out=ULLLsen3;
tables periostatusULLLdl*periostatus/missing nopercent norow out=ULLLsen4;
tables periostatusULLLmbml*periostatus/missing nopercent norow out=ULLLsen5;
tables periostatusULLLdbdl*periostatus/missing nopercent norow out=ULLLsen6;
tables periostatusULLLmbdb*periostatus/missing nopercent norow out=ULLLsen7;
tables periostatusULLLmldl*periostatus/missing nopercent norow out=ULLLsen8;
tables periostatusULLLmbdl*periostatus/missing nopercent norow out=ULLLsen9;
tables periostatusULLLmldb*periostatus/missing nopercent norow out=ULLLsen10;
tables periostatusULLLall*periostatus/missing nopercent norow out=ULLLsen11;
run;

data ULLLsen1;
	set ULLLsen1;
	if _n_=5;
	site='MB';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen2;
	set ULLLsen2;
	if _n_=5;
	site='ML';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen3;
	set ULLLsen3;
	if _n_=5;
	site='DB';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen4;
	set ULLLsen4;
	if _n_=5;
	site='DL';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen5;
	set ULLLsen5;
	if _n_=5;
	site='MBML';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen6;
	set ULLLsen6;
	if _n_=5;
	site='DBDL';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen7;
	set ULLLsen7;
	if _n_=5;
	site='MBDB';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen8;
	set ULLLsen8;
	if _n_=5;
	site='MLDL';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen9;
	set ULLLsen9;
	if _n_=5;
	site='MBDL';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen10;
	set ULLLsen10;
	if _n_=5;
	site='MLDB';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;

data ULLLsen11;
	set ULLLsen11;
	if _n_=5;
	site='All';
	nteeth=14;
	quad='ULLL';
	keep count site nteeth quad;
	run;


/*LL and LR sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusLLLRmb*periostatus/missing nopercent norow out=LLLRsen1;
tables periostatusLLLRml*periostatus/missing nopercent norow out=LLLRsen2;
tables periostatusLLLRdb*periostatus/missing nopercent norow out=LLLRsen3;
tables periostatusLLLRdl*periostatus/missing nopercent norow out=LLLRsen4;
tables periostatusLLLRmbml*periostatus/missing nopercent norow out=LLLRsen5;
tables periostatusLLLRdbdl*periostatus/missing nopercent norow out=LLLRsen6;
tables periostatusLLLRmbdb*periostatus/missing nopercent norow out=LLLRsen7;
tables periostatusLLLRmldl*periostatus/missing nopercent norow out=LLLRsen8;
tables periostatusLLLRmbdl*periostatus/missing nopercent norow out=LLLRsen9;
tables periostatusLLLRmldb*periostatus/missing nopercent norow out=LLLRsen10;
tables periostatusLLLRall*periostatus/missing nopercent norow out=LLLRsen11;
run;

data LLLRsen1;
	set LLLRsen1;
	if _n_=5;
	site='MB';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen2;
	set LLLRsen2;
	if _n_=5;
	site='ML';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen3;
	set LLLRsen3;
	if _n_=5;
	site='DB';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen4;
	set LLLRsen4;
	if _n_=5;
	site='DL';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen5;
	set LLLRsen5;
	if _n_=5;
	site='MBML';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen6;
	set LLLRsen6;
	if _n_=5;
	site='DBDL';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen7;
	set LLLRsen7;
	if _n_=5;
	site='MBDB';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen8;
	set LLLRsen8;
	if _n_=5;
	site='MLDL';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen9;
	set LLLRsen9;
	if _n_=5;
	site='MBDL';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen10;
	set LLLRsen10;
	if _n_=5;
	site='MLDB';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;

data LLLRsen11;
	set LLLRsen11;
	if _n_=5;
	site='All';
	nteeth=14;
	quad='LLLR';
	keep count site nteeth quad;
	run;


/*All quadrants sensitivity estimates*/
proc freq data=part.combquad;
tables periostatusallmb*periostatus/missing nopercent norow out=allsen1;
tables periostatusallml*periostatus/missing nopercent norow out=allsen2;
tables periostatusalldb*periostatus/missing nopercent norow out=allsen3;
tables periostatusalldl*periostatus/missing nopercent norow out=allsen4;
tables periostatusallmbml*periostatus/missing nopercent norow out=allsen5;
tables periostatusalldbdl*periostatus/missing nopercent norow out=allsen6;
tables periostatusallmbdb*periostatus/missing nopercent norow out=allsen7;
tables periostatusallmldl*periostatus/missing nopercent norow out=allsen8;
tables periostatusallmbdl*periostatus/missing nopercent norow out=allsen9;
tables periostatusallmldb*periostatus/missing nopercent norow out=allsen10;
tables periostatusallall*periostatus/missing nopercent norow out=allsen11;
run;

data allsen1;
	set allsen1;
	if _n_=5;
	site='MB';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen2;
	set allsen2;
	if _n_=5;
	site='ML';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen3;
	set allsen3;
	if _n_=5;
	site='DB';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen4;
	set allsen4;
	if _n_=5;
	site='DL';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen5;
	set allsen5;
	if _n_=5;
	site='MBML';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen6;
	set allsen6;
	if _n_=5;
	site='DBDL';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen7;
	set allsen7;
	if _n_=5;
	site='MBDB';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen8;
	set allsen8;
	if _n_=5;
	site='MLDL';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen9;
	set allsen9;
	if _n_=5;
	site='MBDL';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen10;
	set allsen10;
	if _n_=5;
	site='MLDB';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;

data allsen11;
	set allsen11;
	if _n_=4;
	site='All';
	nteeth=28;
	quad='All';
	keep count site nteeth quad;
	run;
proc print data=allsen11;run;

/*Stacking all datasets*/
data all;
	length site $4 quad $4;
	set URsen1 URsen2 URsen3 URsen4 URsen5 URsen6 URsen7 URsen8 URsen9 URsen10 URsen11
		ULsen1 ULsen2 ULsen3 ULsen4 ULsen5 ULsen6 ULsen7 ULsen8 ULsen9 ULsen10 ULsen11
		LLsen1 LLsen2 LLsen3 LLsen4 LLsen5 LLsen6 LLsen7 LLsen8 LLsen9 LLsen10 LLsen11
		LRsen1 LRsen2 LRsen3 LRsen4 LRsen5 LRsen6 LRsen7 LRsen8 LRsen9 LRsen10 LRsen11
		URLLsen1 URLLsen2 URLLsen3 URLLsen4 URLLsen5 URLLsen6 URLLsen7 URLLsen8 URLLsen9 URLLsen10 URLLsen11
		URLRsen1 URLRsen2 URLRsen3 URLRsen4 URLRsen5 URLRsen6 URLRsen7 URLRsen8 URLRsen9 URLRsen10 URLRsen11
		URULsen1 URULsen2 URULsen3 URULsen4 URULsen5 URULsen6 URULsen7 URULsen8 URULsen9 URULsen10 URULsen11
		ULLRsen1 ULLRsen2 ULLRsen3 ULLRsen4 ULLRsen5 ULLRsen6 ULLRsen7 ULLRsen8 ULLRsen9 ULLRsen10 ULLRsen11
		ULLLsen1 ULLLsen2 ULLLsen3 ULLLsen4 ULLLsen5 ULLLsen6 ULLLsen7 ULLLsen8 ULLLsen9 ULLLsen10 ULLLsen11
		LLLRsen1 LLLRsen2 LLLRsen3 LLLRsen4 LLLRsen5 LLLRsen6 LLLRsen7 LLLRsen8 LLLRsen9 LLLRsen10 LLLRsen11
		allsen1 allsen2 allsen3 allsen4 allsen5 allsen6 allsen7 allsen8 allsen9 allsen10 allsen11;
		run;

data all;
	retain count site nteeth quad;
	set all;
	run;

proc print data=all;run;

/*Extracting the total number of severe periodontitis cases under full-mouth*/
data periostatus;
	set allsen11;
	rename count=FM_perio_count;
	keep count;
	do i=1 to 121;
	output;
	end;
	run;

proc print data=periostatus;run;


/*Merging the stacked dataset with the periostatus dataset to calculate the sensitivity for each site/quad
combination*/
data part.fig;
	merge all periostatus;
	sens=round((count/FM_perio_count)*100,0.1);
	run;

proc print data=part.fig;run;


/*Load permanent dataset*/
data fig;
	set part.fig;
	run;

proc print data=fig;run;

/*******************************************************************************/
/* Code Section 2 - Creating figure*/ 
/*******************************************************************************/
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

ods graphics / /*reset=all*/ width=640 height=640 px;

/*Plotting a heatmap of sensitivity by quadrant and site*/ 

ODS GRAPHICS / IMAGEMAP;

proc sgplot data=fig /*noautolegend*/;
heatmap x=site y=quad  /colorresponse=sens  /*X2AXIS*/ /*outline*/ discretex discretey colormodel=(cxfef0d9 cxfdd49e cxfdbb84 cxfc8d59 cxef6548 cxd7301f cx990000) transparency=0;
xaxis /*grid GRIDATTRS=(color=%rgbhex(229,229,229))*/ /*display=(noline)*/ label = "Site" labelattrs=(weight=bold size = 12) valueattrs=(color=black size=12pt) /*VALUESROTATE=diagonal offsetmin=0.1 offsetmax=0.1;*/;
yaxis /*grid GRIDATTRS=(color=%rgbhex(229,229,229))*/ /*display=(noline)*/REVERSE  label = "Quadrant" labelattrs=(weight=bold size = 12) /*minor values=(0 to 100 by 5)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
ODS graphics/noborder width=1200 height=500 px;
title height=16pt 'Heatmap of sensitivity of detecting severe CDC/AAP periodontitis by quadrant and site';
gradlegend/ title='Sensitivity' titleattrs=(weight=bold size=12pt) /*valueattrs=(size=11pt)*/;
run;

/*Plotting a heatmap of sensitivity by quadrant and site*/ 
/*Different color purple*/
ODS GRAPHICS / IMAGEMAP;

proc sgplot data=fig /*noautolegend*/;
heatmap x=site y=quad  /colorresponse=sens  /*X2AXIS*/ /*outline*/ discretex discretey colormodel=(cxedf8fb cxbfd3e6 cx9ebcda cx8c96c6 cx8c6bb1 cx88419d cx6e016b) transparency=0;
xaxis /*grid GRIDATTRS=(color=%rgbhex(229,229,229))*/ /*display=(noline)*/ label = "Site" labelattrs=(weight=bold size = 12) valueattrs=(color=black size=12pt) /*VALUESROTATE=diagonal offsetmin=0.1 offsetmax=0.1;*/;
yaxis /*grid GRIDATTRS=(color=%rgbhex(229,229,229))*/ /*display=(noline)*/REVERSE  label = "Quadrant" labelattrs=(weight=bold size = 12) /*minor values=(0 to 100 by 5)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
ODS graphics/noborder width=1200 height=500 px;
title height=16pt 'Heatmap of sensitivity of detecting severe CDC/AAP periodontitis by quadrant and site';
gradlegend/ title='Sensitivity' titleattrs=(weight=bold size=12pt) /*valueattrs=(size=11pt)*/;
run;

/*Plotting a heatmap of sensitivity by quadrant and site*/ 
/*Different color purple*/
ODS GRAPHICS / IMAGEMAP;

proc sgplot data=fig /*noautolegend*/;
heatmap x=site y=quad  /colorresponse=sens  /*X2AXIS*/ /*outline*/ discretex discretey colormodel=(cxf2f0f7 cxdadaeb cxbcbddc cx9e9ac8 cx807dba cx6a51a3 cx4a1486) transparency=0;
xaxis /*grid GRIDATTRS=(color=%rgbhex(229,229,229))*/ /*display=(noline)*/ label = "Site" labelattrs=(weight=bold size = 12) valueattrs=(color=black size=12pt) /*VALUESROTATE=diagonal offsetmin=0.1 offsetmax=0.1;*/;
yaxis /*grid GRIDATTRS=(color=%rgbhex(229,229,229))*/ /*display=(noline)*/REVERSE  label = "Quadrant" labelattrs=(weight=bold size = 12) /*minor values=(0 to 100 by 5)*/ valueattrs=(color=black size=12pt)/*offsetmin=0.1 offsetmax=0.1*/;
ODS graphics/noborder width=1200 height=500 px;
title height=16pt 'Heatmap of sensitivity of detecting severe CDC/AAP periodontitis by quadrant and site';
gradlegend/ title='Sensitivity' titleattrs=(weight=bold size=12pt) /*valueattrs=(size=11pt)*/;
run;
