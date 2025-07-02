#include <vector>
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include "VertexSimple.h"

using namespace std; 

int main(int argc, char **argv)
{

    string filename = "";
    int    amt=0;
    for (int i=1; i<argc; i++){
        string argi = argv[i];
        cout << argi << endl;
        if(argi.find("--filename=")==0)
            filename = argi.substr(11);
        else if(argi.find("--amt=")==0){
            amt = atoi(argi.substr(6).c_str());
        }
    }

    if(filename == ""){
        cout << "Usage: rand_vertices_file --filename=test.txt --amt=5" << endl;
        return (1);
    }

    vector<VertexSimple> vertices;
    for(int i=1; i<=amt; i++){
        VertexSimple vertex;
        vertex.setRandom(-100, 100);
        vertices.push_back(vertex);
    }

    FILE *f = fopen(filename.c_str(),"w");
    if(!f){
        cout << "Unable to open file: " << filename << endl;
        return(1);
    }

    for(int i=1; i<=amt; i++){
        string vertex_spec = vertices[i].getSpec();
        fprintf(f, "%s\n", vertex_spec.c_str());
    }

    fclose(f);
    return 0;
}