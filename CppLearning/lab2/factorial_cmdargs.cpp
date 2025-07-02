#include <iostream>
#include <cstdlib>

using namespace std;

int main(int argc, char* argv[])
{
    cout << argv[1] << endl;
    int input = atoi(argv[1]);
    long int result= 1;
    
    if argc !=2{
        cout << "Usage:factorial_cmdargs NUMBER" << endl;
    }
    while (input >0) {
        result = result * input; 
        input = input -1;
    }

    cout << "13! is equal to " << result << "(using int)"<< endl;
    return (0);
}