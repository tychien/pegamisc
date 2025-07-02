#include <iostream>
#include <cstdio>

using namespace std;

int main(int argc, char **argv)
{
    string filename = "";
    for(int i=1; i<argc; i++){
        string argi = argv[i];
        if(argi.find("--filename=") == 0){
            filename = argi.substr(11);
        }
    }

    if(filename== ""){
        cout << "Usage: filenin --filename=test.txt" << endl;
        return 1;
    }
    FILE *f = fopen(filename.c_str(), "r");
    if(!f){
        cout << "Unable to open file: "<< filename << endl;
        return 1;
    }

    string str = "line:[";
    while (1){
        int c = fgetc(f);

        if(feof(f))
            break;
        if(c == '\n'){
            str += "]";
            cout << str << endl;
            str = "line: [" ; 
        }
        else 
            str += c;
    }
    fclose(f);
    return 0;
}
