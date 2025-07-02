#include <vector>
#include <iostream>
#include <cstdlib>
#include <cstdio>

using namespace std; 

int main(int argc, char **argv)
{
    struct Vertex {
        int x;
        int y;
    };

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

    vector<Vertex> vertices;
    for(int i=1; i<=amt; i++){
        Vertex vertex;
        vertex.x = (rand() % 201) + -100;
        vertex.y = (rand() % 201) + -100;
        vertices.push_back(vertex);
    }

    FILE *f = fopen(filename.c_str(),"w");
    if(!f){
        cout << "Unable to open file: " << filename << endl;
        return(1);
    }

    for(int i=1; i<=amt; i++){
        fprintf(f, "x=%d", vertices[i].x);
        fprintf(f, ",y=%d\n", vertices[i].y);
    }

    fclose(f);
    return 0;
}