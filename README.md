
# ArchExtract  <a href="url"><img src="http://www.goines.net/Poster_art8/220_bancroft_library_lg.jpg" align="right" height="120" width="90" ></a>

## An Information Extraction and Text Exploration Tool for Digital Collections

ArchExtract is web application that enables archivists and researchers to perform topic modeling, keyword and named entity extraction on a text collection. The web application automates and packages a number of
existing natural language processes and algorithms for the researcher or archivist.
Using automated text analysis as the starting point, ArchExtract illuminates the scope and content of a digital text collection and provides
an web-based interface for text exploration.

***

### Prerequisites:

#### Python libraries
  * Scipy, numpy, nltk, la (larry), bottleneck, mysql-connector-python, pyner
  * For nltk, you will also need to download the nltk data => nltk.download()

#### Java Dependencies
  * you need to have java installed on the server, java 7 or above; java 8 is preferable

#### Installing Mallet
  * Mallet is open source software used for topic modeling
  * [Download](http://mallet.cs.umass.edu/download.php) mallet and unzip it on your system.
  * Put `%MALLET_HOME%` in your path =>  needs to point to where ever bin/mallet is on your system.

#### Installing the Stanford Ner toolkit for Named Entities
  * Download and unzip the [Stanford NER](http://nlp.stanford.edu/software/CRF-NER.shtml#Download)
    into the `/resources/py_scripts/ner_extract` directory package.
  * You will need to start the Stanford NER server on separate port from where this web app is run.
  * [PyNer](https://github.com/dat/pyner) is a python interface to the Stanford Named Entity Recognizer.
  * Here's an example of how to start the Named Entity Recognizer server:

  ```java -mx1000m -cp /your/path/to/archextract/resources/py_scripts/ner_extract/stanford-ner-2015-04-20/stanford-ner.jar edu.stanford.nlp.ie.NERServer -loadClassifier /your/path/to/archextract/resources/py_scripts/ner_extract/stanford-ner-2015-04-20/classifiers/english.muc.7class.distsim.crf.ser.gz -port 9000 -outputFormat inlineXML```

#### Email Server
  * This app sends out emails to notify users when certain processing jobs are done
  * As a result, you will need hook this app to an email server
  * If run locally, you can use the (mailcatcher gem)cp to handle email [http://mailcatcher.me]
  * Or, if you're running this on a web server, use gmail, posfix, whatever floats your boat.

****

### Contributing to ArchExtract
  * Fork, fix, then send me a pull request.

***

### Credits
  * ArchExtract was created as an experimental research tool for UC Berkeley's Bancroft Library.
  * Many thanks to Bancroft Library staff and the UC Berkeley School of Information for
    feedback, support and advise to make this project a reality.
