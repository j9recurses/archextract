# Natural Language Toolkit: code_strings_to_ints
#A more subtle example of a space-time tradeoff involves replacing the #tokens of a corpus with integer identifiers. We create a vocabulary #for the corpus, a list in which each word is stored once, then invert #this list so that we can look up any word to find its identifier. #Each document is preprocessed, so that a list of words becomes a list #of integers. Any language models can now work with integers

def preprocess(tagged_corpus):
    words = set()
    tags = set()
    for sent in tagged_corpus:
        for word, tag in sent:
            words.add(word)
            tags.add(tag)
    wm = dict((w,i) for (i,w) in enumerate(words))
    tm = dict((t,i) for (i,t) in enumerate(tags))
    return [[(wm[w], tm[t]) for (w,t) in sent] for sent in tagged_corpus]
