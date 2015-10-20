import csv
import sys

def getVariousApplications(file_name, kw):

	all_data = []
	f = open(file_name, "rU")
	next(f)

	for row in csv.reader(f):
		del row[-1]
		keyword_list = []
		descrip_string = row[2]
		for word in kw:
			find_index = descrip_string.find(word)
			if find_index != -1:
				keyword_list.append(word)
		if len(keyword_list) > 4:
			row.insert(3, True)
		else:
			row.insert(3, False)
		all_data.append(row)

	f.close()
	return all_data

if __name__ == "__main__":

	input_file = sys.argv[1]
	output_file = sys.argv[2]

	keywords = ["Agriculture", "Conservation", "Construction", "Education", "Emergency", "Government", "Infrastructure", "Insurance", "Manufacturer", "Other", "Photo", "Real Estate", "Research", "Scientific", "Utilities"]

	# create new spreadsheet with updated various applications column
	data = getVariousApplications("../" + input_file, keywords)

	csv_w = csv.writer(open("../" + output_file, "w"))

	# write spreadsheet header
	csv_w.writerow(["date", "company", "category", "various_applications", "aircraft", "location", "description"])

	for row in data:
		csv_w.writerow(row)