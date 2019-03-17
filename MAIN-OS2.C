/*        MAIN.C

        Alternate, standalone main() file.  Demonstrates
        linking to the startup code without having to link
        to any of the Turbo C library routines.

*/

void exit(int c)
{ _exit(c);}

int pascal DosWrite(int handle, char *s, int l, int *bw);

main(int argc,char **argv)
{
int BytesWritten;
        DosWrite(1,"Hello, world!\n",14,&BytesWritten);
        exit(0);
}
