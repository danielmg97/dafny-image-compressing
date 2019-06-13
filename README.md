# Software Specification - Dafny

### The Compression Algorithm

The algorithm we decided to use was LZW (Lempel-Ziv-Welch) a dictionary based algorithm that could be useful for simple images such as logos or files that have repeated content, plus the data structure on which it depends it's pretty straight forward. We could use a map or an array (being that the keys are correspondent to the indexes).

The following pseudocode helps to illustrate the algorithm's inner operations:  

    string s;
    char ch;
    ...

    s = empty string;
    while (there is still data to be read)
    {
        ch = read a character;
        if (dictionary contains s+ch)
        {
    	s = s+ch;
        }
        else
        {
    	encode s to output file;
    	add s+ch to dictionary;
    	s = ch;
        }
    }
    encode s to output file;


### The Implementation
We tried to implement the algorithm above using an array as the main data structure, because we were not sure about the performance of the map implementation behind Dafny which was said to be based on associative arrays.

The process is simple, we start by reading the file content into a byte array and passing it to our compression implementation. The LZW will run and store the bytes into the array that will be used as if it was a table, the index is the key. The array will have all the singular characters but also the patterns it finds. Meanwhile we are already producing the encoded content to be store in the destination file. After the encoding operation we follow on to joining the encoded content and the table into a sequence. This sequence will also have 3 bytes at the end representing the size of the encoded message, so we can later split it from the table.

The decompression is the exact same process, only reversed.


### Issues and Conclusions
The main issues about this challenge were related to the extensive work developed in order to achieve a functional compression and decompression algorithm. We spent too much time attacking problems with datatype casts or bit related operations. Not leaving us much time left to improve the verification and specification alone, although we tried to do it as we progressed.
The use of operations with 16-bit or more bytes represented by means of 8-bit bytes (necessary, given the problem at hand) made it impossible to verify them, has it would involve also specify other type of operations such as sums in sequences...
The requirements, ensures and invariantes to write were in this fashion impossible to write has they depended largely on the operations mentioned above.

In relation to the compressing performance, from what we've tested, it takes time for bigger files but it ends up compressing if the array size is not exceeded, for the size is fixed at 2 to the power of 13, 8192. The two smaller files in the sample folder are verified to compress with our algorithm.

There are also minor issues which we could not figure out the source, after a compression and a decompression the output file is identical to the original file before compression but there are little characters that differ from the original ones like there could be a phrase in the file saying "Today it's my 21st anniversary." and the output after encoding and decoding might show up as "Today it's my É1st anniversary.", for example.
This error could be derived from the fact that our implementation, the function`convertBin` was built to convert only positive integers in the window [0, 65536], meaning that when the coded message is compressed, it can only register that it's length may be less or equal than 65535 in the compressed file.

There are missing pre and post conditions that we didn't include or are commented out because we could not make them work, but mostly we tried to maintain them and leave them commented.
