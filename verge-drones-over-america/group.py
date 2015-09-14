#!/usr/bin/python

import re
import csv
import time
import datetime
from operator import itemgetter
from collections import Counter


def getData():
	dataset = []
	f = open("drones-full.csv", "rU")
	next(f)
	for row in csv.reader(f):
		dataset.append(row);
	f.close()
	return dataset


def sortDates(list_of_dates):
	dates = [datetime.datetime.strptime(ts, "%m/%y") for ts in list_of_dates]
	dates.sort()
	return [datetime.datetime.strftime(ts, "%m/%y") for ts in dates]


# :: does not loop less than one year ::
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

	return month_year_range


def getDateRange(data):
	unique_date_list = []
	for row in data:
		month_year = re.sub(r"/\d{1,2}/", "/", row[0])
		unique_date_list.append(month_year)

	active_months = sortDates([x[0] for x in list(Counter(unique_date_list).items())])
	start_date = active_months[0]
	end_date = active_months[-1]

	all_dates = loopDates(start_date, end_date);

	return all_dates


def groupByMonths(data):
	grouped_data = []
	date_range = getDateRange(data)

	for date in date_range:
		indiv_date = []
		for row in data:
			if date == re.sub(r"/\d{1,2}/", "/", row[0]):
				indiv_date.append(row)
		grouped_data.append(indiv_date)

	return grouped_data


# :: doesn't fill in 0 months, not expecting any anyways ::
# :: hard-coded exception ::
def getDate(data):

	try:
		struct_time = time.strptime(data[0][0], "%m/%d/%y")
		return time.strftime('%b-%y', struct_time)
	except IndexError:
		return "Nov-14"


def getProcessedData():

	d_full = []
	d_num = []
	mystery_counter = 0
	keywords = ["Agriculture", "Conservation", "Construction", "Education", "Emergency", "Government", "Infrastructure", "Insurance", "Manufacturer", "Other", "Photo", "Real Estate", "Research", "Scientific", "Utilities"]

	grouped_by_month = groupByMonths(getData())

	for month in grouped_by_month:

		data_count = []
		not_included = []
		if len(month) > 0:
			for row in month:
				drone_descrip_string = row[2]
				keyword_list = []
				for word in keywords:
					find_index = drone_descrip_string.find(word)
					if find_index != -1:
						keyword_list.append([word, find_index])
				sorted_by_index = sorted(keyword_list, key=itemgetter(1))
				if len(sorted_by_index) > 0:
					data_count.append(sorted_by_index[0][0])
				else:
					mystery_counter += 1
			
			for word in keywords:
				if any(word in x for x in data_count) is False:
					not_included.append(word)

		else:
			not_included = keywords

		c = Counter(data_count)
		this_list = c.items()
		for cats in not_included:
			this_list.append((cats, 0))

		d_full.append([list(x) for x in sorted(this_list, key=itemgetter(0))])

		nums = [x[1] for x in sorted(this_list, key=itemgetter(0))]
		d_num.append(['exemptions', getDate(month), sum(nums)] + nums)

	return {
		"data_full": d_full,
		"data_num": d_num,
		"mystery": mystery_counter
	}


if __name__ == "__main__":
	d = getProcessedData()

	csv_w = csv.writer(open("drones-chart-processed.csv", "w"))

	# only need to run once when creating doc
	csv_w.writerow(["secondary_filter", "bar_categories", "all", "agriculture", "conservation", "construction", "education", "emergency", "government", "infrastructure", "insurance", "manufacturer", "other", "photo", "real estate", "research", "scientific", "utilities"])
	for x in d['data_num']:
		csv_w.writerow(x)