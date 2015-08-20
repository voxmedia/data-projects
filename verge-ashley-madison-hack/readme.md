# Ashley Madison Hack Data

This folder contains aggregated and anonymous data from the Ashley Madison data hack.

Accompanying data story on [The Verge](http://www.theverge.com/2015/8/19/9179037/ashley-madison-data-hack-name-address-phone-birthday/in/8943006)

## File Descriptions

### am_cc_transactions.csv
Transaction data were released with the hack, with a CSV containing credit card information along with personal information grouped into individual days between March 21, 2008 and June 28, 2015. The number of transactions per day were calculated by running `wc -l *.csv` through the folder containing all 2,643 CSVs to determine the number of transactions per day. Note there were 2,655 days between the two dates.
