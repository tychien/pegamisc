#include <iostream>
#include <cstdlib>

using namespace std;


void remove_small(int numberList[], int total_numbers)
{
	int smallest_num;
	int smallest_place;
	cout << "tatal numbers = " << total_numbers << endl;
	for(int i=0; i<=total_numbers-1; i++){
		if (numberList[i] < smallest_num){
		       smallest_num = numberList[i];
			smallest_place = i;
		}	
	}

	int new_numbers[total_numbers-1]; 
	bool smallest_trigger = false;
	for(int i=0; i<=total_numbers; i++){
		if (i!=smallest_place && smallest_trigger==false)
			new_numbers[i] = numberList[i];
		else if (i== smallest_place && smallest_trigger == false)
			smallest_trigger= true;
		else if (i!=smallest_place && smallest_trigger== true)
			new_numbers[i-1] = numberList[i];
	}

	for (int i=0; i<=total_numbers-2; i++){
		cout <<"new number list [" << i <<"]:" << new_numbers[i] << endl;
	}

}



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

    remove_small(numbers, total_numbers);
    
    return 0;
}
