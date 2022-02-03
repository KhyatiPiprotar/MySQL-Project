-- Total profit after Amazon fees

SELECT SUM(`Total (USD)`) AS Total_profit_in_3_Months
FROM sales_and_fees;

-- Find Search terms with impressions and arrange by impressions high to low
-- Nov21
SELECT searchterm_nov21.`Customer Search Term` AS keywords_november, searchterm_nov21.Impressions AS impressions_november
FROM searchterm_nov21
GROUP BY keywords_november
ORDER BY impressions_november DESC;

-- Dec21
SELECT searchterm_dec21.`Customer Search Term` AS keywords_december, searchterm_dec21.Impressions AS impressions_december
FROM searchterm_dec21
GROUP BY keywords_december
ORDER BY impressions_december DESC;

-- Jan22
SELECT searchterm_jan22.`Customer Search Term` AS keywords_january, searchterm_jan22.Impressions AS impressions_january
FROM searchterm_jan22
GROUP BY keywords_january
ORDER BY impressions_january DESC;

-- From above analysis, We can easily find the keywords which has more impressions and can target them to get more sales. But, clicks are also important as clicks can be converted into sales
-- Find out the keywords' clicks where impressions are more than 30 

CREATE TABLE nov_21summary(
SELECT nov.Targeting AS nov_targeting, nov.`Customer Search Term` AS nov_searchterm, nov.Impressions AS nov_impressions, nov.Clicks AS nov_clicks,nov.`Cost Per Click (CPC)` AS nov_cpc,nov.Spend AS nov_spend, nov.`Total Advertising Cost of Sales (ACoS)` AS nov_acos
FROM searchterm_nov21 AS nov
GROUP BY nov_searchterm
HAVING nov_impressions >= 50
ORDER BY nov_impressions DESC);
SELECT *
FROM nov_21summary;

CREATE TABLE dec_21summary(
SELECT de.Targeting AS de_targeting, de.`Customer Search Term` AS de_searchterm, de.Impressions AS de_impressions, de.Clicks AS de_clicks,de.`Cost Per Click (CPC)` AS de_cpc,de.Spend AS de_spend, de.`Total Advertising Cost of Sales (ACoS)` AS de_acos
FROM searchterm_dec21 AS de
GROUP BY de_searchterm
HAVING de_impressions >= 50
ORDER BY de_impressions DESC);
SELECT *
FROM dec_21summary;


CREATE TABLE jan_22summary(
SELECT jan.Targeting AS jan_targeting, jan.`Customer Search Term` AS jan_searchterm, jan.Impressions AS jan_impressions, jan.Clicks AS jan_clicks,jan.`Cost Per Click (CPC)` AS jan_cpc,jan.Spend AS jan_spend, jan.`Total Advertising Cost of Sales (ACoS)` AS jan_acos
FROM searchterm_jan22 AS jan
GROUP BY jan_searchterm
HAVING jan_impressions >= 50
ORDER BY jan_impressions DESC); 
SELECT *
FROM jan_22summary;

-- Some common keywords which were searched by shoppers during these 3 months
-- These search terms has many impressions but not much clicks so work on listing optimization, compare your listing with your competitors' 

SELECT *
FROM nov_21summary
JOIN dec_21summary
ON nov_searchterm = de_searchterm

JOIN jan_22summary
ON jan_searchterm = de_searchterm;

-- Let's see if these clicks are coverted into sales

SELECT nov_searchterm, nov_acos, nov_spend
FROM nov_21summary
WHERE nov_acos;
-- Only one keyword got sales in month of november. Other words are not getting sales so can reduce he bids so we can stop spending more on the terms which are not converted in sales
SELECT de_searchterm, de_acos 
FROM dec_21summary
WHERE de_acos;
-- These 3 terms are returning sales so can probably bid more on those to get more clicks and more sales
SELECT jan_searchterm, jan_acos 
FROM jan_22summary
WHERE jan_acos;
-- Two keywords need more attension 

-- We need the search term which has more than 30% acos
SELECT nov_searchterm, nov_acos, nov_spend
FROM nov_21summary
WHERE nov_acos >= 30;
-- There is none so everything is good

SELECT de_searchterm, de_acos 
FROM dec_21summary
WHERE de_acos >= 30;
-- poly mailers keyword is very popular but it's advertising cost is too high compare to sales. Either is not relevent or you have something wrong with the description or prices, so shoppers opening it and leaving the page without buying

SELECT jan_searchterm, jan_acos
FROM jan_22summary
WHERE jan_acos >= 30;
-- Same keyword polymailers. Trying to add more specific word like biodegradable polymailers

-- Find out total amount spent on advertizing in 3 months
-- Using subquery

CREATE TABLE Spent
SELECT SUM(spend) AS total_spent
FROM 
(
SELECT `Customer Search Term`,substring(spend,2) AS spend
FROM searchterm_nov21
UNION ALL
SELECT `Customer Search Term`, substring(spend,2) AS spend
FROM searchterm_dec21
UNION ALL
SELECT `Customer Search Term`,substring(spend,2) AS spend
FROM searchterm_jan22
)t;


CREATE TABLE Profit
(SELECT SUM(`Total (USD)`) AS Total_profit
FROM sales_and_fees);

SELECT(Total_profit - total_spent)
FROM Spent, Profit
