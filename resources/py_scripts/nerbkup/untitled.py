if k in self.new_dict:
            print k
            for s in ner_stuff:
                for z,v in s.iteritems():
                    if z in self.new_dict:
                    stuff =self.new_dict[z]
                    stuff = stuff + v
                    self.new_dict[z] = stuff
                else:
                    self.new_dict[z] = v
        else:
            self.newdict[k] = ner_stuff
        print "*****newdict**"
        print self.new_dict
        print "*****k***"
        print k
       # for k, v in self.new_dict.iteritems():
       #     yield (k,v)
