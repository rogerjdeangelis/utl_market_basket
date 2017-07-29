
*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

/* see readme for source data */

options validvarname=upcase;
libname sd1 "d:/sd1";
libname xel "d:/xls/groceries.xlsx" scan_text=no header=no;
data sd1.have;
  retain id products;
  length products $25;
  set xel.'groceries$'n;
  array fs[32] $25 f1-f32;
  format _all_;
  informat _all_;
  id=_n_;
  do i=1 to 32;
    if fs[i] ne '' then do;
       products=fs[i];
       output;
    end;
  end;
  drop i f1-f32;
run;quit;
libname xel clear;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname sd1 "d:/sd1";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("c:/Program Files/R/R-3.3.2/etc/Rprofile.site",echo=T);
library(arules);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat");
formatdata <- split(have$PRODUCTS, have$ID);
foodlist <- as(formatdata,"transactions");
rules <- apriori(foodlist, parameter = list(supp = 0.001, conf = 0.8));
head(rules);
rules <- apriori(foodlist, parameter = list(supp = 0.001, conf = 0.8,maxlen=3));
subset.matrix <- is.subset(rules, rules);
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA;
redundant <- colSums(subset.matrix, na.rm=T) >= 1;
rules.pruned <- rules[!redundant];
rules<-rules.pruned;
rules<-apriori(data=foodlist, parameter=list(supp=0.001,conf = 0.15,minlen=2),
  appearance = list(default="rhs",lhs="whole milk"),
  control = list(verbose=F));
rules<-sort(rules, decreasing=TRUE,by="confidence");
wantwps<-inspect(rules[1:5])[,-2];
endsubmit;
import r=wantwps data=wrk.wantwps;
run;quit;
');

/*
The WPS System

Absolute minimum support count: 9
set item appearances ...[0 item(s)] done [0.00s].
set transactions ...[169 item(s), 9835 transaction(s)] done [0.00s].
sorting and recoding items ... [157 item(s)] done [0.00s].
creating transaction tree ... done [0.02s].
checking subsets of size 1 2 3 done [0.00s].
writing ... [29 rule(s)] done [0.00s].
creating S4 object  ... done [0.00s].
    lhs             rhs                support    confidence lift
[1] {whole milk} => {other vegetables} 0.07483477 0.2928770  1.513634
[2] {whole milk} => {rolls/buns}       0.05663447 0.2216474  1.205032
[3] {whole milk} => {yogurt}           0.05602440 0.2192598  1.571735
[4] {whole milk} => {root vegetables}  0.04890696 0.1914047  1.756031
[5] {whole milk} => {tropical fruit}   0.04229792 0.1655392  1.577595
NOTE: 39 records were read from the infile "wps_pgm.lst".
*/




