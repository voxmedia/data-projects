import agate
from decimal import Decimal

column_names = ['YEAR','SEX','MARSTAT','RELCURR','RELDLIFE','STAYTOG','HIEDUC']
column_types = [agate.Text(),agate.Text(),agate.Text(),agate.Text(),agate.Text(),agate.Text(),agate.Text()]

def get_total(row):
    columns = ('Disagree','Agree','Other')
    return sum(tuple(row[c] for c in columns))

def get_percent_agree(row):
    return (row[2] / row[4] * 100).quantize(Decimal('0.01'))

def calc_table(in_csv, out_csv):

    table = agate.Table.from_csv(in_csv, column_names=column_names, column_types=column_types)
    table = table.pivot('HIEDUC','STAYTOG')

    table = table.compute([
        ('Total', agate.Formula(agate.Number(), get_total))
    ])
    table = table.compute([
        ('Percent agree', agate.Formula(agate.Number(), get_percent_agree) )
    ])
    table.to_csv(out_csv)

    return table

# could probably loop thru csv dir here
female_2002 = calc_table('../csv/2002_female.csv', 'female_2002_divorce_education.csv')
male_2002 = calc_table('../csv/2002_male.csv', 'male_2002_divorce_education.csv')
female_2006_2010 = calc_table('../csv/2006_2010_female.csv', 'female_2006_2010_divorce_education.csv')
male_2006_2010 = calc_table('../csv/2006_2010_male.csv', 'male_2006_2010_divorce_education.csv')
female_2011_2013 = calc_table('../csv/2011_2013_female.csv', 'female_2011_2013_divorce_education.csv')
male_2011_2013 = calc_table('../csv/2011_2013_male.csv', 'male_2011_2013_divorce_education.csv')
