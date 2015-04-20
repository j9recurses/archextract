import nltk
import keyword_extractor
from nltk.tokenize.punkt import PunktWordTokenizer
import preprocess_text
import os

candidate_extractor = keyword_extractor.CandidateExtractor()


# First create the texts object to create the tfidf model
# in the CandidateScorer constructor

srcDir = '/home/j9/Desktop/archextract/public/src_corpora/'
collection = 'John_Muir/input/'
#texts = ['john_muir_papers_txt_kt9z09s3f1.txt',  'john_muir_papers_txt_kt9z09s36d.txt']
stopwords = nltk.corpus.stopwords.words('english')

basedir = "/home/j9/Desktop/archextract/public/src_corpora/John_Muir/input"

#grab the files
all_files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(basedir) for f in filenames if os.path.splitext(f)[1] == '.txt']


textsFull = []
count = 0
pt = preprocess_text.PreprocessText()

for doc in all_files:
  with open(doc) as f:
    doc_text = " ".join(line.strip() for line in f)
    #args  = self, text, convertlower=True, nopunk=True, stopwords=True, lemmatize_doc=True, lemmatize_pos=True, stemmed=False)
    words = pt.preprocess_txt(doc_text, True, False, True, True, True, False)
    words = candidate_extractor.run(words)
    textsFull.append(words)

candidate_scorer = keyword_extractor.CandidateScorer(textsFull)

# Then extract keywords from a given review
with open(basedir + "/" + 'john_muir_papers_txt_kt9z09s3f1.txt') as f:
    doc_text = " ".join(line.strip() for line in f)
    doc_words = pt.preprocess_txt(doc_text, False, False, True, True, True, False)

    # 1. Extract candidates
candidates = candidate_extractor.run(doc_words)
    # 2. Rank candidates by TFxIDF
print candidate_scorer.run(candidates)
#print textsFull
