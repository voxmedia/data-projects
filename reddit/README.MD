Some stuff for investigating reddit comment data. You can find the data drop here: [https://www.reddit.com/r/datasets/comments/3bxlg7/i_have_every_publicly_available_reddit_comment/](https://www.reddit.com/r/datasets/comments/3bxlg7/i_have_every_publicly_available_reddit_comment/).


You'll need elastic search installed, first check if it exists:

```
which elasticsearch
```

If not, install it:

```
brew install elasticsearch
```

You will also probably want to install an elastic search GUI:

```
HOSTNAME=`hostname` plugin -install mobz/elasticsearch-head
```

This repo is setup to run a standalone instance for this project:

```
./run.sh
```

Will start elastic search for this project. You should make sure that you're not running another instance of elastic search somewhere else.

You can now visit the elastic search gui: [http://localhost:9200/_plugin/head/](http://localhost:9200/_plugin/head/)

To load the data into elastic search, run:

```
./load.py myjsonfile.json
```
