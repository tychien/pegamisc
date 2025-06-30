 #include <iostream>   // For terminal I/O using cout                                 

 using namespace std;

 int main(int argc, char **argv)
 {
   string search_pattern;
   for(int i=1; i<argc; i++) {
     string argi = argv[i];
     if(argi.find("--search=") == 0)
       search_pattern = argi.substr(9);
   }

   if(search_pattern == "") {
     cout << "Usage: str_search PATTERN str str ... str" << endl;
     exit(1);
   }

   bool found = false;
   for(int i=1; i<argc; i++) {
     string argi = argv[i];
     if(argi.find("--search=") != 0)
       if(argi == search_pattern)
         found = true;
   }

   if(found)
     cout << "The pattern was found." << endl;
   else
     cout << "The pattern was not found." << endl;

   return(0);
 }