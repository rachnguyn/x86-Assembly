/*-----------------------------------------------------------------------------------------
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch13, Prime_Check_with_Inline_Assembly
Due Date: 5/13/21

Description:
This program lets the user input numbers repeatedly to display a message for each one
indicating whether it is prime or not until -1 entered:
-----------------------------------------------------------------------------------------*/

#include <iostream>
#pragma warning(disable: 4716)
using namespace std;
bool isPrimeC_inlineASM(int n);
bool isPrimeC(int n);
bool isPrimeC_inlineASM2(int n);

int main()
{
    int N;
    do {
        cout << "Enter an Integer (-1 to exit): ";
        cin >> N;
        cout << "isPrimeC:   " << N << " is " << (isPrimeC(N) ? "" : "NOT ") << "prime\n";
        cout << "inlineASM:  " << N << " is " << (isPrimeC_inlineASM(N) ? "" : "NOT ") << "prime\n";
        cout << "inlineASM2: " << N << " is " << (isPrimeC_inlineASM2(N) ? "" : "NOT ") << "prime\n";
    } while (N != -1);

    return 0;
}

bool isPrimeC(int n)
{
    bool ret = false;

    if (n >= 2)
    {
        int divisor;
        for (divisor = 2; divisor <= n / 2; divisor++)
        {
            if (n % divisor == 0)
                break;
        }

        if (divisor > n / 2)
            ret = true;
    }
    return ret;
}

bool isPrimeC_inlineASM(int n)
{
    __asm {
        mov esi, 0             // ret = false

        // if (n >= 2)
        cmp n, 2
        jl quit                // no: quit
        mov ebx, 2             // ebx = divisor (2)
        mov ecx, n             
        shr ecx, 1             // ecx = n/2

        L1:
            cmp ebx, ecx       // divisor <= n/2? 
            jg L2              // no: skip
            mov eax, n         // high dividend (n)
            xor edx, edx       // clear low dividend
            div ebx            // n % divisor (edx = remainder)
            cmp edx, 0         // rem = 0?
            jz quit            // yes: quit
            inc ebx            // no: divisor++
            jmp L1             

        L2:
            mov esi, 1         // yes: ret = true

        quit:
            mov eax, esi       // return eax (t/f)
    }      // asm
}

bool isPrimeC_inlineASM2(int n)
{
    bool isPrime = true;

    //  if (n < 2), isPrime = false;
    __asm {
        cmp n, 2
        jge quit            // n < 2? no: quit
        mov isPrime, 0      // yes: isPrime = false

        quit :
    }

    if (!isPrime)
        return false;

    for (int divisor = 2; divisor <= n / 2; divisor++)
    {
        __asm {
            mov eax, n         // high dividend
            xor edx, edx       // clear low dividend

            div divisor        // n % divisor (edx = remainder) 
            cmp edx, 0         // rem = 0?
            jnz done           // no: skip, loop again
            mov isPrime, 0     // yes: ret = false

            done:
        }      // asm

        if (!isPrime)
            break;
    }
    return isPrime;
}