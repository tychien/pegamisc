#include <iostream>
#include <cstdlib>

using namespace std;

int main(int argc, char** argv)
{
    int total_numbers = argc - 1;
    if(total_numbers ==0){
        cout << "Usage: ./arrays NUMBER [MORENUMBERS]" << endl;
        return(1);
    }



    int numbers[total_numbers];

    for(int i=1; i<argc; i++)
        numbers[i-1] = atoi(argv[i]);
    cout<< "Total amount of integers provided: " << total_numbers << endl;
    for(int i=0; i<total_numbers; i++)
        cout << "numbers["<<i<<"]: " << numbers[i] << endl;

    return 0;
}