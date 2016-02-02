# Vox Midwest

A reader poll on [which states belong to the Midwest](http://www.vox.com/2016/1/27/10825534/which-states-in-midwest). Shut down after 34,522 submissions.

- `calculated.json` - the API calculated and stored the results of all the submissions in a Redis database, and returned this data
- `submissions.json` - a backup of all the submissions (pre-calculated) in the database as a `json` file. If I could start over, I'd backup a `csv`, too.
- `convert_backup_to_csv.rb` - which is why I wrote this script

What you get from running `ruby convert_backup_to_csv.rb` :
- `data/submissions.csv`
- `states/` - a json file for each valid states that answers the question, If you submitted this state, what were the chances you selected other states? (You can see plenty of trolls here.)
