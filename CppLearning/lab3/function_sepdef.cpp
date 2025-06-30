#include <iostream>
using namespace std;
bool message(bool& capitalized, string msg="Hello there. How are things?")
{
    cout << msg << endl;
    bool msg_long = false;


    if(msg.length() >10)
        msg_long= true;
    capitalized = false;
    if(msg.length()>0 && msg[0]>=65 && msg[0] <=90)
        capitalized = true;

    return (msg_long);

} // namespace std;

