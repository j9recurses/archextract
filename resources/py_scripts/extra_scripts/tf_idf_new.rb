require_relative './test_stnlp.rb'  


def write_collection_list_file(name_of_collection, file_list)
	file = File.open(name_of_collection +"collection_file_list.txt", "w")
	file_list.each do | f|
 		file.write(f + "\n") 
 	end
 end

def get_tf_idf
	wasGood = system( "python /home/j9/Desktop/bancroft/tf_idf_test/tfidf.py -l english john_muircollection_file_list.txt")
	puts wasGood

end

base_dir = '/home/j9/Desktop/bancroft/john_muir/data/plaintxt'
np =  NLP_Base.new()


name_of_collection = 'john_muir'
file_list = np.get_files(base_dir)
write_collection_list_file(name_of_collection, file_list)
get_tf_idf
