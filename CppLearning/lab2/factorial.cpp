#include <iostream>
using namespace std;

int main()
{
    int input = 13;
    int result= 1;
    
    while (input >0) {
        result = result * input; 
        input = input -1;
    }

    cout << "13! is equal to " << result << endl;
    return (0);
}