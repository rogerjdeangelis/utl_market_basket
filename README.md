# utl_market_basket

    ```    ```
    ```  T1006760 SAS-L : MarketBasket analysis in SAS/WPS/R  ```
    ```    ```
    ```   We want to answer this question.  ```
    ```    ```
    ```     What are customers likely to buy if they purchase whole milk?  ```
    ```    ```
    ```     WORKING CODE  ```
    ```    ```
    ```          * from SAS/WPS;  ```
    ```          have<-read_sas("d:/sd1/have.sas7bdat");  ```
    ```    ```
    ```          * create market basket data structure;  ```
    ```          formatdata <- split(have$PRODUCTS, have$ID);  ```
    ```          foodlist <- as(formatdata,"transactions");  ```
    ```    ```
    ```          * get available rules and we will pick the first 5;  ```
    ```          rules <- apriori(foodlist, parameter = list(supp = 0.001, conf = 0.8));  ```
    ```          rules<-sort(rules, decreasing=TRUE,by="confidence");  ```
    ```          res<-inspect(rules[1:5]);  ```
    ```    ```
    ```          * column two is a spcial R construct an "=>" and is not needed;  ```
    ```          wantwps<-as.data.frame(res[,-2]);  ```
    ```    ```
    ```          * send to SAS/WPS;  ```
    ```          import r=wantwps data=wrk.wantwps;  ```
    ```    ```
    ```    ```
    ```   see  ```
    ```   http://www.salemmarafi.com/code/market-basket-analysis-with-r/  ```
    ```    ```
    ```  HAVE  MARKET BASKETS  ```
    ```  ====================  ```
    ```    ```
    ```    csv, xlsx, and sas7bdat  (I am using groceries csv file which can be downloaded from many sites)  ```
    ```                             ( also in the arules package)  ```
    ```    ```
    ```    You can pick one of these or surf net for graceries.  ```
    ```    ```
    ```    CSV  ```
    ```    https://www.dropbox.com/s/auqnh93u5f8887j/groceries.csv?dl=0  ```
    ```    ```
    ```    XLSX  ```
    ```    https://www.dropbox.com/s/ug97hxkr0wuuvp3/groceries.xlsx?dl=0  ```
    ```    ```
    ```    have,sas7bdat  ```
    ```    https://www.dropbox.com/s/0egnm9rz14eqhhs/have.zip?dl=0  ```
    ```    ```
    ```    ```
    ```  Up to 40 obs SD1.HAVE total obs=43,367  ```
    ```        Customer  ```
    ```    Obs    ID    PRODUCTS  ```
    ```    ```
    ```      1     1    citrus fruit  ```
    ```      2     1    semi-finished bread  ```
    ```      3     1    margarine  ```
    ```      4     1    ready soups  ```
    ```    ```
    ```      5     2    tropical fruit  ```
    ```      6     2    yogurt  ```
    ```      7     2    coffee  ```
    ```    ```
    ```      8     3    whole milk  ```
    ```    ```
    ```      9     4    pip fruit  ```
    ```     10     4    yogurt  ```
    ```     11     4    cream cheese  ```
    ```     12     4    meat spreads  ```
    ```    ```
    ```    ```
    ```  WANT  ```
    ```  ===  ```
    ```    ```
    ```  Customers who purchase whole milk are 75% more likely to purchase root vegetables  ```
    ```  then the overall likelihood.  ```
    ```    ```
    ```  Up to 40 obs from wantwps total obs=5  ```
    ```    ```
    ```  Obs        LHS         RHS                    SUPPORT    CONFIDENCE      LIFT  ```
    ```    ```
    ```   1     {whole milk}    {root vegetables}     0.048907      0.19140     1.75603  ```
    ```   2     {whole milk}    {tropical fruit}      0.042298      0.16554     1.57759  ```
    ```   3     {whole milk}    {yogurt}              0.056024      0.21926     1.57174  ```
    ```   4     {whole milk}    {other vegetables}    0.074835      0.29288     1.51363  ```
    ```   5     {whole milk}    {rolls/buns}          0.056634      0.22165     1.20503  ```
    ```    ```
