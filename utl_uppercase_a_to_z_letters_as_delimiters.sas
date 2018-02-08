Uppercase A to Z letters as delimiters

Same results WPS and SAS

see
https://stackoverflow.com/questions/48689450/how-to-read-file-which-has-no-delimiter-in-sas

user667489 profile
https://stackoverflow.com/users/667489/user667489

INPUT
=====

Algorithm
  Split on uppercase A-Z and extract year

  The key is these three

  regex = prxparse('/[A-Z][a-z]+/');   A-Z followed by 1 or more lowercase chars
  call prxnext('regex,start, stop, ceo, position,length);
  substr(ceo,position,length);

    Iteration 1   substr(ceo,1,9)   Microsoft
    Iteration 2   substr(ceo,10,4)  Bill
    Iteration 3   substr(ceo,14,5)  Gates
    substr(ceo,length(ceo)-3)       1976


WORK.HAVE total obs=5

             CEO              | RULES
                              |
  MicrosoftBillGates1976      |
  AppleSteaveJob1975          |  COMPANY      FIRSTNAME    LASTNAME     YEAR
  GoogleLarryPage2004         |
  FacebookMarkZukerberg2004   |  Microsoft     Bill        Gates        1976
  TwitterBizStone2006         |


PROCES
======

data want;
  set have;
  array c[3] $16. Company Firstname Lastname;
  retain regex;
  if _n_ = 1 then regex = prxparse('/[A-Z][a-z]+/');
  start = 1;
  stop = length(ceo);
  do i = 1 to 3;
     call prxnext(regex,start, stop, ceo, position,length);
     put position @5 length;
     c[i] = substr(ceo,position,length);
  end;
  Year = substr(ceo,length(ceo)-3);
  keep Company Firstname Lastname Year;
run;quit;


OUTPUT
======

 WORK.WANT total obs=5

    COMPANY      FIRSTNAME    LASTNAME     YEAR

    Microsoft     Bill        Gates        1976
    Apple         Steave      Job          1975
    Google        Larry       Page         2004
    Facebook      Mark        Zukerberg    2004
    Twitter       Biz         Stone        2006

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
informat ceo $25.;
input ceo;
cards4;
MicrosoftBillGates1976
AppleSteaveJob1975
GoogleLarryPage2004
FacebookMarkZukerberg2004
TwitterBizStone2006
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

*SAS;
data want;
  set have;
  array c[3] $16. Company Firstname Lastname;
  retain regex;
  if _n_ = 1 then regex = prxparse('/[A-Z][a-z]+/');
  start = 1;
  stop = length(ceo);
  do i = 1 to 3;
     call prxnext(regex,start, stop, ceo, position,length);
     c[i] = substr(ceo,position,length);
  end;
  Year = substr(ceo,length(ceo)-3);
  keep Company Firstname Lastname Year;
run;quit;


*WPS;
%utl_submit_wps64('
libname wrk sas7bdat"%sysfunc(pathname(work))";
data wrk.wantwps;
  set wrk.have;
  array c[3] $16. Company Firstname Lastname;
  retain regex;
  if _n_ = 1 then regex = prxparse("/[A-Z][a-z]+/");
  start = 1;
  stop = length(ceo);
  do i = 1 to 3;
     call prxnext(regex,start, stop, ceo, position,length);
     put position @5 length;
     c[i] = substr(ceo,position,length);
  end;
  Year = substr(ceo,length(ceo)-3);
  keep Company Firstname Lastname Year;
run;quit;
');

