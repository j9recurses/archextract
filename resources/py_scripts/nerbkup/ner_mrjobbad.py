from __future__ import division
from mrjob.job import MRJob
import re
import ner
import os
import sys

WORD_RE = re.compile(r"[\w']+")


class MRGetNer(MRJob):

    def mapper_get_dicts(self, tagger, line):
        # yield each word in the line
        cool = ''
        stuff = line.split("??")
        tagger = ner.SocketNER(host='localhost', port=9000)
        cool =  tagger.get_entities(stuff[0])
        fname = stuff[1]
        mydict ={}
        for k,v in cool.iteritems():
            for vv in v:
                v_tup = (vv, fname)
                mydict[k] = v_tup
        yield None, mydict

    def get_words(self):
        self.new_dict = {}

    def get_type_dicts(self,_, mydict):
        ner_stuff = list(mydict)
        for s in ner_stuff:
            for k,v in s.iteritems():
                if k in self.new_dict:
                    newstuff =self.new_dict[k]
                    newstuff.append(v)
                    self.new_dict[k] = newstuff
                else:
                    self.new_dict[k] = v
        for k, v in self.new_dict.iteritems():
            yield (k,v)

    def reducer_total_dict(self,type_k, v):
        cool = list(v)
        final_dict = {}
        for c in cool:
            for cc in c:
                if cc[0] in final_dict:
                    morestuff = final_dict[cc[0]]
                    morestuff.append(c[1])
                    final_dict[cc[0]] = morestuff
                else:
                    final_dict[cc[0]] = [c[1] ]
        for kk,v in final_dict.iteritems():
            vlist = []
            vlist.append(v)
            vlist.append(len(v))
            yield None, {type_k : (kk, vlist)}


    def steps(self):
        tagger = ner.SocketNER(host='localhost', port=9000)
        return [
                 self.mr(mapper=self.mapper_get_dicts , combiner_init=self.get_words, combiner=self.get_type_dicts,  reducer=self.reducer_total_dict )
        ]


if __name__ == '__main__':
   MRGetNer.run()
