#include <iostream>
using namespace std;
bool message(string msg="Hello there. How are things?")
{
    cout << msg << endl;

    if(msg.length() >10)
        return(true);
    return false;
} // namespace std;

int main(int argc, char **argv)
{
    cout << argc << endl;
    if(argc >2 ){
        cout << "Usage: hellocmd MESSAGE" << endl;
        return(1);
    }
    bool msg_is_long;
    if(argc == 2) 
        msg_is_long = message(argv[1]);
    else
        msg_is_long = message();

    if(msg_is_long)
        cout << "That was a long message." << endl;
    else
        cout << "That was a short message." << endl;

    return (0);

}