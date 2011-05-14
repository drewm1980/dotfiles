/* 
 * This program illustrates how to use the pipe(), fork(), dup2() and exec()
 * system calls to control stdin and stdout of an exec'ed program via pipes
 * from within the calling program.
 *
 * Just because someone asked me ;-)
 * Eike Rathke
 * Tue Jun 26 21:44:17 CEST 2001
 */

#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>


void errMsg( const char* pMsg )
{
    fflush( stdout );
    fputs( pMsg, stderr );
    fflush( stderr );
}


void writeToPipe( int fd )
{
    FILE *stream;
    errMsg( "writing\n" );
    if ( (stream = fdopen( fd, "w" )) == NULL )
    {
        perror( "fdopen() w" );
        exit(255);
    }
    fputs( "Hello, world!\n", stream );
    fputs( "Goodbye, world!\n", stream );
    fclose( stream );
    errMsg( "writing done\n" );
}


void readFromPipe( int fd )
{
    FILE *stream;
    int ch;
    errMsg( "reading\n" );
    if ( (stream = fdopen( fd, "r" )) == NULL )
    {
        perror( "fdopen() r" );
        exit(255);
    }
    while ( (ch = getc( stream )) != EOF )
        putc( ch, stdout );
    fflush( stdout );
    fclose( stream );
    errMsg( "reading done\n" );
}


int main()
{
    pid_t nPid;
    int pipeto[2];      /* pipe to feed the exec'ed program input */
    int pipefrom[2];    /* pipe to get the exec'ed program output */

    if ( pipe( pipeto ) != 0 )
    {
        perror( "pipe() to" );
        exit(255);
    }
    if ( pipe( pipefrom ) != 0 )
    {
        perror( "pipe() from" );
        exit(255);
    }

    nPid = fork();
    if ( nPid < 0 )
    {
        perror( "fork() 1" );
        exit(255);
    }
    else if ( nPid == 0 )
    {
		// Child
        /* dup pipe read/write to stdin/stdout */
        dup2( pipeto[0], STDIN_FILENO );
        dup2( pipefrom[1], STDOUT_FILENO  );
        /* close unnecessary pipe descriptors for a clean environment */
        close( pipeto[0] );
        close( pipeto[1] );
        close( pipefrom[0] );
        close( pipefrom[1] );
        /* call od as an example, with hex and char output */
        execlp( "od", "od", "-tx1c", "-v", NULL );
        perror( "execlp()" );
        exit(255);
    }
    else
    {
		// Parent
        pid_t nPid2;

        /* Close unused pipe ends. This is especially important for the
         * pipefrom[1] write descriptor, otherwise readFromPipe will never 
         * get an EOF. */
        close( pipeto[0] );
        close( pipefrom[1] );

        nPid2 = fork();
        if ( nPid2 < 0 )
        {
            perror( "fork() 2" );
            exit(255);
        }
        else if ( nPid2 == 0 )
        {
            /* Close pipe write descriptor, or we will never know when the
             * writer process closes its end of the pipe and stops feeding the
             * exec'ed program. */
            close( pipeto[1] );
            readFromPipe( pipefrom[0] );
        }
        else
        {
            int status;

            /* close unused pipe end */
            close( pipefrom[0] );
            writeToPipe( pipeto[1] );

            errMsg( "waiting for readFromPipe\n" );
            if ( -1 == waitpid( nPid2, &status, 0 ) )
            {
                perror( "waitpid()" );
                exit(255);
            }
            if ( WIFEXITED( status ) )
                fprintf( stderr, "exit status: %d\n", WEXITSTATUS( status ) );
            if ( WIFSIGNALED( status ) )
                fprintf( stderr, "signal status: %d\n", WTERMSIG( status ) );
            fflush( stderr );
        }
    }
    fflush( stdout );
    return( 0 );
}
