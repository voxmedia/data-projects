#!/usr/bin/python

import re
import csv
import time
import datetime
from operator import itemgetter
from collections import Counter


def getData(file_name):
	dataset = []
	f = open(file_name, "rU")
	next(f)
	for row in csv.reader(f):
		dataset.append(row);
	f.close()
	return dataset


def sortDates(list_of_dates):
	dates = [datetime.datetime.strptime(ts, "%m/%y") for ts in list_of_dates]
	dates.sort()
	return [datetime.datetime.strftime(ts, "%m/%y") for ts in dates]


# :: does not loop less than one year in the same year ::
def loopDates(start_d, end_d):
	month_year_range = []
	start_d = start_d.split("/")
	end_d = end_d.split("/")

	for x in range(int(start_d[0]), 12 + 1):
		month_year_range.append(str(x) + "/" + start_d[1])

	for y in range(1, int(end_d[0]) + 1):
		month_year_range.append(str(y) + "/" + end_d[1])

	year_diff = int(end_d[1]) - int(start_d[1])
	if year_diff > 1:
		for year in range(int(start_d[1]) + 1, int(end_d[1])):
			for month in range(1, 12 + 1):
				month_year_range.append(str(month) + "/" + str(year))

	return sortDates(month_year_range)


def getMonthYear(date):
	d = datetime.datetime.strptime(re.sub(r"/\d{1,2}/", "/", date), "%m/%y")
	return datetime.datetime.strftime(d, "%m/%y")


def getDataByMonth(file_name):

	data = getData(file_name);

	dr = [getMonthYear(x[0]) for x in data]
	date_range = loopDates(dr[0], dr[-1])

	grouped_by_month = []

	for date in date_range:
		this_month = []
		for x in data:
			if date == getMonthYear(x[0]):
				this_month.append(x)
		grouped_by_month.append({
			"date": date,
			"data": this_month
		})

	return grouped_by_month


def getDate(date):
	struct_time = time.strptime(date, "%m/%y")
	return time.strftime("%b-%y", struct_time)


def getSortOut(data, date, kw):
	data_counter = []

	for x in data:
		drone_descrip_string = x[2]
		keyword_list = []

		for word in kw:
			find_index = drone_descrip_string.find(word)
			if find_index != -1:
				keyword_list.append([word, find_index])
		sorted_by_index = sorted(keyword_list, key=itemgetter(1))

		if len(sorted_by_index) > 0:
			data_counter.append(sorted_by_index[0][0])

	c = Counter(data_counter)
	monthly_totals = c.items()

	# fill in categorys that have 0 for spreadsheet row
	not_included = []
	for word in kw:
		if any(word in x for x in monthly_totals) is False:
			not_included.append((word, 0))

	return [("title", "exemptions"), ("date", getDate(date)), ("all", len(data))] + sorted(not_included + monthly_totals)


def getCounts(data):

	processed_data = []

	keywords = ["Agriculture", "Conservation", "Construction", "Education", "Emergency", "Government", "Infrastructure", "Insurance", "Manufacturer", "Other", "Photo", "Real Estate", "Research", "Scientific", "Utilities"]

	for d in data:
		counted_data = getSortOut(d['data'], d['date'], keywords)
		processed_data.append(counted_data)

	return processed_data


if __name__ == "__main__":

	all_by_month = getDataByMonth("drones-full-aug-2015.csv")

	tallied_categorized_by_month = getCounts(all_by_month)

	csv_w = csv.writer(open("drones-chart-processed.csv", "w"))

	# write spreadsheet header
	csv_w.writerow(["secondary_filter", "bar_categories", "all", "agriculture", "conservation", "construction", "education", "emergency", "government", "infrastructure", "insurance", "manufacturer", "other", "photo", "real estate", "research", "scientific", "utilities"])

	for row in tallied_categorized_by_month:
		csv_w.writerow([x[1] for x in row])


