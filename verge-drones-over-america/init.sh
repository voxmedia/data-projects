# tail -n +3 master-drone-data.csv > drone-data.csv
cd scripts
python process.py drone-data-09-2015.csv drone-data-processed.csv
python script.py drone-data-09-2015.csv drone-data-full.csv
