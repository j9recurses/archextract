#map reduce job to output ners as a json object
from __future__ import division
from mrjob.job import MRJob
import re
import ner
import os
import sys

#need to fire up ner server:
#java -mx1000m -cp /home/j9/Desktop/archextract/resources/py_scripts/ner_extract/stanford-ner-2014-06-16/stanford-ner.jar edu.stanford.nlp.ie.NERServer -loadClassifier /home/j9/Desktop/archextract/resources/py_scripts/ner_extract/stanford-ner-2014-06-16/classifiers/english.muc.7class.distsim.crf.ser.gz -port 9000 -outputFormat inlineXML

WORD_RE = re.compile(r"[\w']+")
class MRGetNer(MRJob):

    #output a line of ners for each line
    def mapper_get_dicts(self, tagger, line):
        # yield each word in the line
        cool = ''
        stuff = line.split("???????")
        tagger = ner.SocketNER(host='localhost', port=9000)
        cool =  tagger.get_entities(stuff[0])
        fname = stuff[1]
        mydict ={}
        for k,v in cool.iteritems():
            for vv in v:
                if k in mydict:
                    existingdict = mydict[k]
                    if vv in  existingdict:
                        existingdictfiles = existingdict[vv]
                        existingdictfiles.append(fname)
                        existingdict[vv] = existingdictfiles
                        mydict[k] =  existingdict
                    else:
                        existingdict[vv] = [fname]
                else:
                    itemdict = {}
                    itemdict[vv] = [fname]
                    mydict[k] = itemdict
        for k,v in mydict.iteritems():
          yield  (k, v)

    def get_words(self):
        self.new_dict = {}

    #get a list of ners by type
    def get_type_dicts(self, k, v):
        new_dict ={}
        ner_stuff = list(v)
        ner_stuff = ner_stuff
        for s in ner_stuff:
            if k in new_dict:
                for z,v in s.iteritems():
                    kdict  = new_dict[k]
                    if z in kdict:
                        vvals = kdict[z]
                        vvals = vvals + v
                        kdict[z] = vvals
                        new_dict[k] = kdict
                    else:
                        kdict[z]= v
                        new_dict[k] = kdict
            else:
                new_dict[k] = s
        for k, v in new_dict.iteritems():
            yield (k, v)

    #get the count for each ner and output the list
    def reducer_total_dict(self,type_t, v):
        nerdict = list(v)
        nerdict = nerdict[0]
        final_dict = {}
        counter = 0
        for kk, vv in nerdict.iteritems():
            vlist = []
            docsize = len(vv)
            vlist.append(vv)
            vlist.append(docsize)
            nerdict[kk] = vlist
            test =  nerdict[kk]
        #sort the list to get most frequent ners first to insert into the db
        sortedners = sorted(nerdict.items(), key=lambda e: e[1][1], reverse=True)
        for s in sortedners:
            slist =  list(s)
            nername = slist[0]
            nerdocs = slist[1][0]
            nerct =  slist[1][1]
            yield  None,  (type_t, nername, nerdocs, nerct)
            #yield None, {type_t : ner}
            #yield None, {type_t : s}


    def steps(self):
        tagger = ner.SocketNER(host='localhost', port=9000)
        return [
                 self.mr(mapper=self.mapper_get_dicts, combiner_init=self.get_words, combiner=self.get_type_dicts, reducer=self.reducer_total_dict )
        ]


if __name__ == '__main__':
   MRGetNer.run()
#python ner_load_to_db.py -i /home/j9/Desktop/stemmertest/nerout.txt -v development -c 10 -n 2
