import rake
import operator
import os

basedir = "/home/j9/Desktop/archextract/public/src_corpora/John_Muir/input"

# EXAMPLE ONE - SIMPLE
stoppath = "SmartStoplist.txt"
# 1. initialize RAKE by providing a path to a stopwords file
# 2. run on RAKE on a given text
#sample_file = open(basedir +"john_muir_papers_txt_kt9z09s3bg.txt", 'r')
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']


textsFull = []
count = 0

for doc in all_files:
  docfile = open(doc, 'r')
  text = docfile.read()
  textsFull.append(text)

alltxt = " ".join(textsFull)
rake = rake.Rake( "SmartStoplist.txt")
keywords = rake.run(alltxt )
print keywords
