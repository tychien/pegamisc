#include <iostream>
using namespace std;

int main()
{
    int input = 13;
    long int long_result= 1;
    int result = 1;
    
    while (input >0) {
        result = result * input; 
        long_result = long_result * input; 
        input = input -1;
    }

    cout << "13! is equal to " << result << "(using int)"<< endl;
    cout << "13! is equal to " << long_result << "(using long int)"<< endl;
    return (0);
}