#include <iostream>
#include <cstdio>

using namespace std;

int main(int argc, char **argv)
{
    string filename;
    for (int i=1; i<argc; i++){
        string argi = argv[i];
        cout << argi << endl;
        if(argi.find("--filename=")==0)
            filename = argi.substr(11);
    }

    if(filename == ""){
        cout << "Usage: fileout --filename=test.txt one two three" << endl;
        cout << "filename:" << filename << endl;
        return (1);
    }
    FILE *f = fopen(filename.c_str(), "w");
    if(!f){
        cout << "Unable to open file: " << filename << endl;
        return (1);
    }

    for(int i=1; i<argc; i++){
        string argi = argv[i];
        if(argi.find("--filename=") !=0)
            fprintf(f, "%s\n", argi.c_str());
    }

    fclose(f);
    return(0);
}