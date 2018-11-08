#include <fstream>
#include "eagle.h"

using namespace std;

int main(int argc, char *argv[]) {
    int mode;
    const char *src = "";
    const char *dest = "";
    int nthreads;
    int directed=0;
    cout << "argc: " << argc << endl;
    switch (argc) {
        case 4:
            mode = 1;
            nthreads = atoi(argv[1]);
            src = argv[2];
	    if (string("dir") == argv[3]) directed=true;
            break;

        case 5:
            mode = 2;
            nthreads = atoi(argv[1]);
            src = argv[2];
	    if (string("dir") == argv[3]) directed=1;
            dest = argv[4];
            break;

        default:
            cerr << "Sinopsi: " << argv[0] << " nThreads src <dir|undir> [dest]" << endl;
            return EXIT_FAILURE;
    }

    cout << "EAGLE" << endl;
    if (directed)
	    cout <<  "directed graph" << endl;
    else
	    cout <<  "undirected graph" << endl;

    cout << "Caricato su: " << src << endl;
    if (mode == 2) cout << "Salvataggio dati su: " << dest << endl;
    cout << "Numero di thread usati: " << nthreads << endl;

    omp_set_num_threads(nthreads);
    igraph_i_set_attribute_table(&igraph_cattribute_table);

    int result;
    igraph_t graph;

    FILE *instream = fopen(src, "r");
    if (instream == NULL) {
        cerr << "File non esistente." << endl;

        return EXIT_FAILURE;
    }

    cout << "Lettura grafo" << endl;
    //result = igraph_read_graph_edgelist(&graph, instream, 0,directed);
    result = igraph_read_graph_ncol(&graph, instream, 0,0, IGRAPH_ADD_WEIGHTS_YES, directed>0?IGRAPH_DIRECTED:IGRAPH_UNDIRECTED);

    cout << "OK." << endl;

    fclose(instream);

    EAGLE e(&graph);

    Communities *r = e.run();


    cout << r->summary(mode == 1) << endl;

    if (mode == 2) {
        ofstream ofs(dest);
        r->dump(ofs);
        ofs.close();
    }

    // liberiamo la memoria
    r->free();
    delete r;

    return EXIT_SUCCESS;
}

