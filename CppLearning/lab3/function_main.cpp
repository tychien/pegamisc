#include <iostream>
#include "function_sepdef.h"
using namespace std;

int main(int argc, char **argv)
{
    cout << argc << endl;
    if(argc >2 ){
        cout << "Usage: hellocmd MESSAGE" << endl;
        return(1);
    }
    bool capitalized;
    bool msg_is_long;
    if(argc == 2) 
        msg_is_long = message(capitalized, argv[1]);
    else
        msg_is_long = message(capitalized);

    if(msg_is_long)
        cout << "That was a long message." << endl;
    else
        cout << "That was a short message." << endl;

    
    if(capitalized)
        cout << "The message was properly capitalized." << endl;
    else
        cout << "The message was not properly capitalized." << endl;
        
    return (0);

}