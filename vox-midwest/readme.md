# Vox Midwest

A reader poll on [which states belong to the Midwest](http://www.vox.com/2016/1/27/10825534/which-states-in-midwest). Shut down after 34,522 submissions.

- `calculated.json` - the API calculated and stored the results of all the submissions in a Redis database, and returned this data
- `submissions.json` - a backup of all the submissions (pre-calculated) in the database as a `json` file. If I could start over, I'd backup a `csv`, too.
- `convert_backup_to_csv.rb` - which is why I made this.

What you get from running `ruby convert_backup_to_csv.rb` :
- `submissions.csv`
- `by_hour_submissions.csv`






does the midwest database track anything other than votes for states?

also, even if that's the only thing it tracks, i wonder if we can run an algorithm that figure out like: if you picked michigan, you're more likely to have picked illinois and less likely to have picked colorado

Ha yeah, that'd be interesting. Id wanna know about the people who pick one Dakota but not the other

what % of respondents put ohio on the map?

we were thinking of Qs like… if someone chose ohio, what did their midwest look like, or if they didn’t choose the dakotas, or something like that

Iowa is the most Midwestern state.

Oklahoma is the most Midwestern of non-Midwestern states.

North Dakota is the least Midwestern of Midwestern states

What did the Midwest look like if you picked North Dakota but not South Dakota?

What did the Midwest look like if you picked Ohio?

What did the Midwest look like if you picked Missouri? 