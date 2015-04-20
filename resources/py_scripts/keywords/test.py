
from nltk.corpus import movie_reviews
import keyword_extractor


for fileid in movie_reviews.fileids():
  words =movie_reviews.words(fileid)
  print words
