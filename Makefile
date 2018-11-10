all: 2009-LFR-Benchmark 2008-CliquePercolation 2009-Connected-Iterative-Scan 2009-EAGLE \
	2010-LinkCommunity 2010-CONGA 2010-TopGC 2010-iLCD \
	2011-OSLOM-v2 2011-GCE 2011-MOSES 2012-Fast-Clique-Percolation 2012-CPMOnSteroids \
	2013-MSCD 2013-SVINET

PROJDIR=$(shell pwd)

2009-LFR-Benchmark: lfr_undir_net lfr_dir_net lfr_weighted_net lfr_weighted_dir_net lfr_hierarchical_net
lfr_undir_net: lfr_dir_net lfr_weighted_net lfr_weighted_dir_net lfr_hierarchical_net
lfr_dir_net: lfr_weighted_net lfr_weighted_dir_net lfr_hierarchical_net
lfr_weighted_net: lfr_weighted_dir_net lfr_hierarchical_net
lfr_weighted_dir_net: lfr_hierarchical_net
lfr_hierarchical_net:
	cd Benchmark/2009-LFR-Benchmark/src_refactor_cpp/ && mkdir -p build && cd build && cmake .. && make && find . -executable -type f -name lfr*net -exec cp {} $(PROJDIR) \;

2008-CliquePercolation: k_clique
k_clique:
	cd Algorithms/2008-CliquePercolation/src_cpp && rm -fr lcelib && ln -s $(PROJDIR)/../lcelib . && make -f doc/makefile && cp k_clique $(PROJDIR)

2009-Connected-Iterative-Scan: 2009-cis
2009-cis:
	cd Algorithms/2009-Connected-Iterative-Scan/src-refactor/ && mkdir -p build && cd build && cmake .. && make && cp 2009-cis $(PROJDIR)

igraph: libigraph.a
libigraph.a:
	if [ ! -f SubModules/igraph-0.7.1.tar.gz ]; then \
	 cd SubModules && wget http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz && tar xf igraph-0.7.1.tar.gz; \
	fi
	
	cd SubModules/igraph-0.7.1 && ./configure && make -j4 && cp src/.libs/libigraph.a $(PROJDIR)
2009-EAGLE: 2009-eagle igraph	
2009-eagle: 
	cd Algorithms/2009-EAGLE/src/ && mkdir -p build && cd build &&cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_CXX_FLAGS=-I$(PROJDIR)/SubModules/igraph-0.7.1/include/ \
	-DCMAKE_EXE_LINKER_FLAGS="-L$(PROJDIR)" -DCMAKE_CXX_STANDARD_LIBRARIES="-lxml2" ..  && make && cp 2009-eagle $(PROJDIR)

2010-LinkCommunity: calcJaccards clusterJaccards link_clustering.sh
link_clustering.sh:
	cd Algorithms/2010-LinkCommunity/cpp && cp $@ $(PROJDIR) && chmod u+x $@
calcJaccards:
	cd Algorithms/2010-LinkCommunity/cpp && g++ -O5 -o calcJaccards calcAndWrite_Jaccards.cpp && cp calcJaccards $(PROJDIR)
clusterJaccards:
	cd Algorithms/2010-LinkCommunity/cpp && g++ -O5 -o clusterJaccards clusterJaccsFile.cpp && cp clusterJaccards $(PROJDIR)

2010-CONGA: conga-1.0-SNAPSHOT.jar
conga-1.0-SNAPSHOT.jar:
	cd Algorithms/2010-CONGA/conga_src && mvn package && cp target/$@ $(PROJDIR)

2010-TopGC: topgc-1.0-SNAPSHOT.jar mkidx
topgc-1.0-SNAPSHOT.jar:
	cd Algorithms/2010-TopGC/src_refactor && mvn package && cp target/$@ $(PROJDIR)
mkidx:
	cd Algorithms/2010-TopGC/src_original/Graphs/original && gcc mkidx.c -o mkidx && cp $@ $(PROJDIR)

2010-iLCD: iLCD-source-1.0-SNAPSHOT.jar
iLCD-source-1.0-SNAPSHOT.jar:
	cd Algorithms/2010-iLCD/src && mvn package && cp target/$@ $(PROJDIR)


2011-GCE: 2011-gce
2011-gce:
	cd Algorithms/2011-GCE/src-refactor/ && mkdir -p build && cd build && cmake .. && make &&  cp 2011-gce $(PROJDIR)

2011-MOSES: 2011-moses
2011-moses:
	cd Algorithms/2011-MOSES/src-refactor/ && mkdir -p build && cd build && cmake .. && make &&  cp $@ $(PROJDIR)

2011-OSLOM-v2: infomap_undir infomap_dir louvain_comm louvain_convert louvain_hier
louvain_comm: infomap_dir
	cd Algorithms/2011-OSLOM-v2/src-refactor/build  &&  cp $@ $(PROJDIR)
louvain_convert: infomap_dir
	cd Algorithms/2011-OSLOM-v2/src-refactor/build  &&  cp $@ $(PROJDIR)
louvain_hier: infomap_dir
	cd Algorithms/2011-OSLOM-v2/src-refactor/build  &&  cp $@ $(PROJDIR)
infomap_undir: infomap_dir
	cd Algorithms/2011-OSLOM-v2/src-refactor/build  &&  cp $@ $(PROJDIR)
infomap_dir:
	cd Algorithms/2011-OSLOM-v2/src-refactor && mkdir -p build && cd build && cmake .. && make infomap_undir infomap_dir louvain_comm louvain_convert louvain_hier &&  cp $@ $(PROJDIR)

2012-Fast-Clique-Percolation: 2012-fast-cpm
2012-fast-cpm:
	cd Algorithms/2012-Fast-Clique-Percolation/src_refactor/ && mkdir -p build && cd build && cmake .. && make &&  cp $@ $(PROJDIR)

2012-CPMOnSteroids: 2012-ParCPM max-clique
max-clique: 2012-ParCPM
	cd Algorithms/2012-CPMOnSteroids/src_refactor/src/build &&  cp $@ $(PROJDIR)

2012-ParCPM:
	cd Algorithms/2012-CPMOnSteroids/src_refactor/src && mkdir -p build && cd build && cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS=-I$(PROJDIR)/SubModules/igraph-0.7.1/include/ \
	-DCMAKE_EXE_LINKER_FLAGS="-L$(PROJDIR)" -DCMAKE_C_STANDARD_LIBRARIES="-lxml2 -lm" .. && make &&  cp $@ $(PROJDIR)

2013-MSCD: 2013-mscd
2013-mscd:
	cd Algorithms/2013-MSCD && make && cp mscd $(PROJDIR)/$@


2013-SVINET: 2013-svinet
2013-svinet:
	cd Algorithms/2013-SVINET/src-cmake/src && mkdir -p build && cd build && cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_STANDARD_LIBRARIES="-lgsl -lgslcblas" .. && make &&  cp $@ $(PROJDIR)




















