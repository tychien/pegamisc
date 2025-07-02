#include <iostream>
#include <cstdlib>

using namespace std; 

int main()
{
    struct Vertex{
        int x;
        int y;
    };

    for(int i=1; i<=5; i++){
        Vertex vertex;
        vertex.x = (rand() % 201) + -100;
        vertex.y = (rand() % 201) + -100;
        cout << "x=" << vertex.x << ",y=" << vertex.y << endl;
    }
    return 0;
}