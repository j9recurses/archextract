
# ArchExtract  <img src="http://www.goines.net/Poster_art8/220_bancroft_library_lg.jpg" align="right" height="150" width="120" >

## An Information Extraction and Text Exploration Tool for Digital Collections

ArchExtract is web application that enables archivists and researchers to perform topic modeling, keyword and named entity extraction on a text collection. The web application automates and packages a number of
existing natural language processes and algorithms for the researcher or archivist.
Using automated text analysis as the starting point, ArchExtract illuminates the scope and content of a digital text collection and provides
an web-based interface for text exploration.

## Prerequisites
##### Python libraries
  * Scipy, numpy and la (for matrix manipulation), nltk (for language processing), bottleneck, mysql-connector-python, pyner (for stanford ner), mr.job (for python mapreduce), fuzzy_wuzzy and python-Levenshtein(computing string edit distances and similarities)
  * For nltk, you will also need to download the nltk data => nltk.download()

##### Java Dependencies
  * You need to have java installed on the server, java 7 or above; java 8 is preferable

##### Installing Mallet
  * Mallet is open source software used for topic modeling
  * [Download](http://mallet.cs.umass.edu/download.php) mallet and unzip it on your system.
  * Put `%MALLET_HOME%` in your path =>  needs to point to where ever bin/mallet is on your system.

##### Installing the Stanford Named Entity Recognizer
  * Download and unzip the [Stanford NER](http://nlp.stanford.edu/software/CRF-NER.shtml#Download)
    into the `/resources/py_scripts/ner_extract` directory package.
  * You will need to start the Stanford NER server on separate port from where this web app is run.
  * [PyNer](https://github.com/dat/pyner) is a python interface to the Stanford Named Entity Recognizer.
  * Here's an example of how to start the Named Entity Recognizer server:

  ```java -mx1000m -cp /your/path/to/archextract/resources/py_scripts/ner_extract/stanford-ner-2015-04-20/stanford-ner.jar edu.stanford.nlp.ie.NERServer -loadClassifier /your/path/to/archextract/resources/py_scripts/ner_extract/stanford-ner-2015-04-20/classifiers/english.muc.7class.distsim.crf.ser.gz -port 9000 -outputFormat inlineXML```

##### Background Processing jobs
  * This web app uses the [delayed job library] (https://github.com/collectiveidea/delayed_job)  to execute a number of python and java processes in the background.
  * You can invoke `rake jobs:work` which will start the background jobs.
  * You can cancel the rake task with cntr-c and all all background jobs with the command rake `jobs:clear`
  * Or, you can start multiple worker threads like this:
   ```RAILS_ENV=development bin/delayed_job -n4 start```
    ```The above cmds will start four workers```
  * for more cmd options checkout the [delayed job documentation](https://github.com/collectiveidea/delayed_job/wiki/Delayed-job-command-details)

##### Email Server
  * This app sends out emails to notify users when certain background processing jobs are done
  * As a result, you will need hook this app to an email server
  * If run locally, you can use the [mailcatcher gem] (http://mailcatcher.me) to handle email
  * Or, if you're running this on a web server, use gmail, posfix, whatever floats your boat to send email.



## Contributing to ArchExtract
  * Fork, fix, then send me a pull request.

## Credits
  * ArchExtract was created as an experimental research tool for UC Berkeley's Bancroft Library.
  * Many thanks to Bancroft Library staff and the UC Berkeley School of Information for
    feedback, support and advise to make this project a reality.
