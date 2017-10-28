//moni Fri Oct 21, 12:21 am

//all files read/write methods and other streams methods
#include "mltaln.h"

static int upperCase = 0;

#define DEBUG   0
#define IODEBUG 0

char creverse( char f )
{
	static TLS char *table = NULL;

	if( f == 0 )
	{
		free( table );
		table = NULL;
		return( 0 );
	}

	if( table == NULL )
	{
		int i;
		table = AllocateCharVec(0x80);
		for( i=0; i<0x80; i++ ) table[i] = i;
		table['A'] = 'T';
		table['C'] = 'G';
		table['G'] = 'C';
		table['T'] = 'A';
		table['U'] = 'A';
		table['M'] = 'K';
		table['R'] = 'Y';
		table['W'] = 'W';
		table['S'] = 'S';
		table['Y'] = 'R';
		table['K'] = 'M';
		table['V'] = 'B';
		table['H'] = 'D';
		table['D'] = 'H';
		table['B'] = 'V';
		table['N'] = 'N';
		table['a'] = 't';
		table['c'] = 'g';
		table['g'] = 'c';
		table['t'] = 'a';
		table['u'] = 'a';
		table['m'] = 'k';
		table['r'] = 'y';
		table['w'] = 'w';
		table['s'] = 's';
		table['y'] = 'r';
		table['k'] = 'm';
		table['v'] = 'b';
		table['h'] = 'd';
		table['d'] = 'h';
		table['b'] = 'v';
		table['n'] = 'n';
//		table['-'] = '-';
//		table['.'] = '.';
//		table['*'] = '*';
	}
	return( table[(int)f] );
}

//fills r with reversed chars from s
void sreverse( char *r, char *s )
{
	r += strlen( s );
	*r-- = 0;
	while( *s )
		*r-- = creverse( *s++ );
//		*r-- = ( *s++ );
}

void seqLower( int nseq, char **seq )
{
	int i, j, len;
	for( i=0; i<nseq; i++ )
	{
		len = strlen( seq[i] );
		for( j=0; j<len; j++ )
			seq[i][j] = tolower( seq[i][j] );
	}
}

///////countlen methods////////
static int countKUorWA( FILE *fp ) //this method counts the number of sequences in FASTA formatted input file
{
	int value;
	int c, b;

	value= 0;
	b = '\n';
	while( ( c = getc( fp ) ) != EOF )
	{
		if( b == '\n' && ( c == '>' ) ) { //if new sequence, then count up
//			printf("new sequence \n");
			value++;
		}
		b = c;
	}
	rewind( fp ); //reset the file position to the beginning of the input stream
	return( value );
}

void searchKUorWA( FILE *fp )
{
	int c, b;
	b = '\n';
	//reads characters till reach first sequence, then stop
	while( !( ( ( c = getc( fp ) ) == '>' || c == EOF ) && b == '\n' ) )
		b = c;
	ungetc( c, fp ); //pushes current character again to input stream to be available for next 'getc'
}

//what i understand till now is that this reads first line of each sequence(seq. name) into char sequence
//char s[]; int l; FILE *fp;
int myfgets(char s[], int l, FILE* fp)
{
        int     c = 0, i = 0 ;

		if( feof( fp ) ) return( 1 ); //test end of file

		for( i=0; i<l && ( c=getc( fp ) ) != '\n'; i++ ) {
        	*s++ = c;
		}
        *s = '\0' ;
		if( c != '\n' ) {
			while( getc(fp) != '\n' )
				;
		}
		return( 0 );
}

void kake2hiku( char *str )
{
	do
		if( *str == '*' ) *str = '-';
	while( *str++ );
}

int charfilter( unsigned char *str )
{
	unsigned char tmp;
	unsigned char *res = str;
	unsigned char *bk = str;

	while( (tmp=*str++) )
	{
//		if( tmp == '=' || tmp == '*' || tmp == '<' || tmp == '>' || tmp == '(' || tmp == ')' )
		if( tmp == '=' || tmp == '<' || tmp == '>' )
		{
			fprintf( stderr, "\n" );
			fprintf( stderr, "Characters '= < >' are not accepted in the --text mode, \nalthough most printable characters are ok.\n" );
			fprintf( stderr, "\n" );
			exit( 1 );
		}
//		if( 0x20 < tmp && tmp < 0x7f )
//		if( 0x0 <=tmp && tmp < 0x100 &&
		if( tmp != 0x0a && tmp != 0x20 && tmp != 0x0d )
//		if( tmp != '\n' && tmp != ' ' && tmp != '\t' ) // unprintable characters mo ok.
		{
			*res++ = tmp;
//			reporterr( "tmp=%d (%c)\n", tmp, tmp );
		}
	}
	*res = 0;
	return( res - bk );
}

int onlyAlpha_lower( char *str )
{
	char tmp;
	char *res = str;
	char *bk = str;

	while( (tmp=*str++) )
		if( isalpha( tmp ) || tmp == '-' || tmp == '*' || tmp == '.' )
			*res++ = tolower( tmp );
	*res = 0;
	return( res - bk );
}

int onlyAlpha_upper( char *str )
{
	char tmp;
	char *res = str;
	char *bk = str;

	while( (tmp=*str++) )
		if( isalpha( tmp ) || tmp == '-' || tmp == '*' || tmp == '.' )
			*res++ = toupper( tmp );
	*res = 0;
	return( res - bk );
}

char *load1SeqWithoutName_realloc( FILE *fpp )
{
	int c, b;
	char *cbuf;
	int size = N;
	char *val;

	val = (char *)malloc( (size+1) * sizeof( char ) );
	cbuf = val; //point to start of buffer

	b = '\n';
	while( ( c = getc( fpp ) ) != EOF &&
          !( ( c == '>' || c == EOF ) && b == '\n' ) )
	{
		*cbuf++ = (char)c;
		if( cbuf - val == size ) //if buffer exceeds size, double size
		{
			size += N;
			fprintf( stderr, "reallocating...\n" );
			val = (char *)realloc( val, (size+1) * sizeof( char ) );
			if( !val )
			{
				fprintf( stderr, "Allocation error in load1SeqWithoutName_realloc \n" );
				exit( 1 );
			}
			fprintf( stderr, "done.\n" );
			cbuf = val + size-N;
		}
		b = c;
	}
	ungetc( c, fpp );
	*cbuf = 0;

	if( nblosum == -2 )
	{
		charfilter( (unsigned char *) val ); //filter characters in sequence
	}
	else
	{
		if( dorp == 'd' )
			onlyAlpha_lower( val );
		else
			onlyAlpha_upper( val );
		kake2hiku( val );
	}
	return( val );
}

int countnogaplen( char *seq )
{
	int val = 0;
	while( *seq )
		if( *seq++ != '-' ) val++;
	return( val );
}

int countATGCandN( char *s, int *countN, int *total )
{
	int nATGC;
	int nChar;
	int nN;
	char c;
	nN = nATGC = nChar = 0;

	if( *s == 0 )
	{
		*total = 0;
		return( 0 );
	}

	do
	{
		c = tolower( *s ); //convert character to lower case
		if( isalpha( c ) ) //is this character is alphabetic
		{
			nChar++; //increase number of characters by 1
			if( c == 'a' || c == 't' || c == 'g' || c == 'c' || c == 'u' || c == 'n' )
				nATGC++;
			if( c == 'n' )
				nN++;
		}
	}
	while( *++s );

//	reporterr( "nN = %d", nN );

	*total = nChar;
	*countN = nN;
	return( nATGC );
}

int countATGC( char *s, int *total )
{
	int nATGC;
	int nChar;
	char c;
	nATGC = nChar = 0;

	if( *s == 0 )
	{
		*total = 0;
		return( 0 );
	}

	do
	{
		c = tolower( *s );
		if( isalpha( c ) )
		{
			nChar++;
			if( c == 'a' || c == 't' || c == 'g' || c == 'c' || c == 'u' || c == 'n' )
				nATGC++;
		}
	}
	while( *++s );

	*total = nChar;
	return( nATGC );
}

//char *AllocateCharVec( int l1 )
//{
//	char *cvec;
//
//	cvec = (char *)calloc( l1, sizeof( char ) );
//	if( cvec == NULL )
//	{
//		fprintf( stderr, "Cannot allocate %d character vector.\n", l1 );
//		exit( 1 );
//	}
//	return( cvec );
//}


//it reads input file and counts number of sequences in it, frequency of acgt chars, freq of n chars
//and finds min and max lengths of sequences
void getnumlen_nogap_countn( FILE *fp, int *nlenminpt, double *nfreq )
{
	printf("getnumlen_nogap_countn \n");

	int total;
	int nsite = 0;
	int atgcnum, nnum, nN;
	int i, tmp;
	char *tmpseq, *tmpname;
	double atgcfreq;
	tmpname = AllocateCharVec( N ); //N = 5,000,000
	njob = countKUorWA( fp ); //njob = number of sequences in the input file - this var is defined in defs.h
	searchKUorWA( fp ); //this method locates the stream pointer to start of first sequence
	nlenmax = 0; //this var is defined in defs.h
	*nlenminpt = 99999999;
	atgcnum = 0;
	total = 0;
	nnum = 0;

	printf("number of jobs = %d\n", njob);

	for( i=0; i<njob; i++ )
	{
		myfgets( tmpname, N-1, fp ); //read sequence name in tmpname
		tmpseq = load1SeqWithoutName_realloc( fp ); //load sequence characters in tmpseq
		tmp = countnogaplen( tmpseq ); //get count of characters in sequence - without gaps
		if( tmp > nlenmax ) nlenmax  = tmp; //set max sequence length
		if( tmp < *nlenminpt ) *nlenminpt  = tmp; //set min sequence length
		atgcnum += countATGCandN( tmpseq, &nN, &nsite ); //finds number of cgtanu chars, n chars and total chars in sequence
		total += nsite; //total = total num of chars in all sequences
		nnum += nN; //nnum = number of n chars in all sequences
		free( tmpseq ); //free sequence memory
	}
	free( tmpname ); //free sequence name memory
	atgcfreq = (double)atgcnum / total; //get atgc freq in all sequences
	*nfreq = (double)nnum / atgcnum; //get n freq in all sequences
//	fprintf( stderr, "##### nnum = %d\n", nnum );
//	fprintf( stderr, "##### atgcfreq = %f, *nfreq = %f\n", atgcfreq, *nfreq );
	if( dorp == NOTSPECIFIED )
	{
		if( atgcfreq > 0.75 ) //if atgc freq is > 0.75, then dorp is d (dna)
		{
			dorp = 'd';
			upperCase = -1;
		}
		else                  //else, dorp is p (protein)
		{
			dorp = 'p';
			upperCase = 0;
		}
	}
}

//Finds sequences count, max length and dna or protein from fp file
void getnumlen( FILE *fp )
{
	int total;
	int nsite = 0;
	int atgcnum;
	int i, tmp;
	char *tmpseq;
	char *tmpname;
	double atgcfreq;
	tmpname = AllocateCharVec( N ); //N is defined in mltaln.h and = 5,000,000
	njob = countKUorWA( fp ); //number of sequences. defined in defs.h
	searchKUorWA( fp ); //stop at first sequence
	nlenmax = 0; //defined in defs.h
	atgcnum = 0;
	total = 0;
	for( i=0; i<njob; i++ )
	{
		myfgets( tmpname, N-1, fp ); //read sequence name into tmpname
		tmpseq = load1SeqWithoutName_realloc( fp ); //read sequence itself
		tmp = strlen( tmpseq ); //get length of tmpseq
		if( tmp > nlenmax ) nlenmax  = tmp; //save max length of sequences
		atgcnum += countATGC( tmpseq, &nsite ); //count atgc chars in all sequences
		total += nsite; //count total number of chars in all sequences
//		fprintf( stderr, "##### total = %d\n", total );
		free( tmpseq );
	}


	atgcfreq = (double)atgcnum / total;
//	fprintf( stderr, "##### atgcfreq = %f\n", atgcfreq );
	if( dorp == NOTSPECIFIED ) //dorp defined in defs.c
	{
		if( atgcfreq > 0.75 )
		{
			dorp = 'd';
			upperCase = -1; //defined here in io.c
		}
		else
		{
			dorp = 'p';
			upperCase = 0;
		}
	}
	free( tmpname );
}

//It reads sequences and their names from fp file into seq, name and nlen arrays.
void readData_pointer( FILE *fp, char **name, int *nlen, char **seq )
{
	int i;
	static char *tmpseq = NULL;

#if 0
	if( !tmpseq )
	{
		tmpseq = AllocateCharVec( N );
	}
#endif

	rewind( fp ); //point to first character in the fp stream
	searchKUorWA( fp ); //locates the stream pointer to start of first sequence

	for( i=0; i<njob; i++ )
	{
		name[i][0] = '='; getc( fp );
#if 0
		fgets( name[i]+1, B-2, fp );
		j = strlen( name[i] );
		if( name[i][j-1] != '\n' )
			ErrorExit( "Too long name\n" );
		name[i][j-1] = 0;
#else
		myfgets( name[i]+1, B-2, fp ); //read sequence name into 'name[i]' with max length B-2
#endif
#if 0
		fprintf( stderr, "name[%d] = %s\n", i, name[i] );
#endif
		tmpseq = load1SeqWithoutName_realloc( fp ); //load sequence characters in tmpseq
		strcpy( seq[i], tmpseq ); //copy tmpseq to seq[i]
		free( tmpseq );
		nlen[i] = strlen( seq[i] ); //save length of seq[i] in nlen[i]
	}
	if( dorp == 'd' && upperCase != -1 ) seqLower( njob, seq ); //set all chars to lower case
#if 0
	free( tmpseq );
#endif
	if( outnumber ) //outnumber is defined in defs.c, and = 0
	{
		char *namebuf;
		char *cptr;
		namebuf = (char *) calloc( B+100, sizeof( char ) );
		for( i=0; i<njob; i++ )
		{
			namebuf[0] = '=';
			cptr = strstr( name[i], "_numo_e_" ); //find the first occurrence of second param in the name[i]
			if( cptr ) //sprintf send formatted output to first parameter string
				sprintf( namebuf+1, "_numo_s_%08d_numo_e_%s", i+1, cptr+8 );
			else
				sprintf( namebuf+1, "_numo_s_%08d_numo_e_%s", i+1, name[i]+1 );
			strncpy( name[i], namebuf, B ); //copy B chars from namebuf to name[i]
			name[i][B-1] = 0; //add null char at the end of name[i]
		}
		free( namebuf );
//		exit( 1 );
	}
}


////////replaceu methods////////////
char *load1SeqWithoutName_realloc_casepreserve( FILE *fpp )
{
	int c, b;
	char *cbuf;
	int size = N;
	char *val;

	val = (char *) malloc( (size+1) * sizeof( char ) );
	cbuf = val;

	b = '\n';
	while( ( c = getc( fpp ) ) != EOF &&
          !( ( c == '>' || c == EOF ) && b == '\n' ) )
	{
		*cbuf++ = (char)c;
		if( cbuf - val == size )
		{
			size += N;
			fprintf( stderr, "reallocating...\n" );
			val = (char *)realloc( val, (size+1) * sizeof( char ) );
			if( !val )
			{
				fprintf( stderr, "Allocation error in load1SeqWithoutName_realloc \n" );
				exit( 1 );
			}
			fprintf( stderr, "done.\n" );
			cbuf = val + size-N;
		}
		b = c;
	}
	ungetc( c, fpp );
	*cbuf = 0;
//	onlyGraph( val );
	charfilter( (unsigned char *) val );
//	kake2hiku( val );
	return( val );
}

//read sequences in input file, count their number and get cgta freq to determine dorp value
void getnumlen_casepreserve( FILE *fp, int *nlenminpt )
{
	int total;
	int nsite = 0;
	int atgcnum;
	int i, tmp;
	char *tmpseq, *tmpname;
	double atgcfreq;
	tmpname = AllocateCharVec( N ); //allocate memory for sequences names
	njob = countKUorWA( fp ); //get number of sequences in input file
	searchKUorWA( fp ); //point to first sequence name
	nlenmax = 0;
	*nlenminpt = 99999999;
	atgcnum = 0;
	total = 0;
	for( i=0; i<njob; i++ )
	{
		myfgets( tmpname, N-1, fp ); //read sequence name
		tmpseq = load1SeqWithoutName_realloc_casepreserve( fp ); //read sequence chars without changing case
		tmp = strlen( tmpseq ); //length of sequence
		if( tmp > nlenmax ) nlenmax  = tmp;
		if( tmp < *nlenminpt ) *nlenminpt  = tmp;
		atgcnum += countATGC( tmpseq, &nsite ); //count acgt chars in sequence
		total += nsite; //count total chars in all sequences
		free( tmpseq );
	}
	free( tmpname );
	atgcfreq = (double)atgcnum / total; //get acgt chars frequency in total chars count
//	fprintf( stderr, "##### atgcfreq = %f\n", atgcfreq );
	if( dorp == NOTSPECIFIED ) //dna or protein
	{
		if( atgcfreq > 0.75 ) //dna
		{
			dorp = 'd';
			upperCase = -1;
		}
		else                  //protein
		{
			dorp = 'p';
			upperCase = 0;
		}
	}
}

//fill matrices of sequences, sequences names and lengths
void readData_pointer_casepreserve( FILE *fp, char **name, int *nlen, char **seq )
{
	int i;
	static char *tmpseq = NULL;

#if 0
	if( !tmpseq )
	{
		tmpseq = AllocateCharVec( N );
	}
#endif

	rewind( fp );
	searchKUorWA( fp ); //point to first sequence name

	for( i=0; i<njob; i++ )
	{
		name[i][0] = '='; getc( fp );
#if 0
		fgets( name[i]+1, B-2, fp );
		j = strlen( name[i] );
		if( name[i][j-1] != '\n' )
			ErrorExit( "Too long name\n" );
		name[i][j-1] = 0;
#else
		myfgets( name[i]+1, B-2, fp ); //read sequence name into name[i][...]
#endif
#if 0
		fprintf( stderr, "name[%d] = %s\n", i, name[i] );
#endif
		tmpseq = load1SeqWithoutName_realloc_casepreserve( fp ); //read sequence in tmpseq
		strcpy( seq[i], tmpseq ); //then copy to seq[i]
		free( tmpseq );
		nlen[i] = strlen( seq[i] ); //set length of sequence to nlen[i]
	}
}

static void tab2space( char *s ) // nen no tame  //converts tap to space
{
	while( *s )
	{
		if( *s == '\t' ) *s = ' ';
		s++;
	}
}

static int readasubalignment( char *s, int *t, int *preservegaps )
{
	int v = 0;
	char status = 's';
	char *pt = s;
	*preservegaps = 0;
	tab2space( s ); //convert tabs to space
	while( *pt )
	{
		if( *pt == ' ' )
		{
			status = 's';
		}
		else
		{
			if( status == 's' )
			{
				if( *pt == '\n' || *pt == '#' ) break; //exit while loop
				status = 'n';
				t[v] = atoi( pt ); //convert char in pt to int and assign to t[v]
				if( t[v] == 0 )
				{
					fprintf( stderr, "Format error? Sequences must be specified as 1, 2, 3...\n" );
					exit( 1 );
				}
				if( t[v] < 0 ) *preservegaps = 1; //if negative number, set preservegaps to 1
				t[v] = abs( t[v] );
				t[v] -= 1;
				v++;
			}
		}
		pt++;
	}
	t[v] = -1;
	return( v );
}

static int countspace( char *s )
{
	int v = 0;
	char status = 's';
	char *pt = s;
	tab2space( s ); //defined here. converts all taps in s to spaces
	while( *pt )
	{
		if( *pt == ' ' )
		{
			status = 's';
		}
		else
		{
			if( status == 's' )
			{
				if( *pt == '\n' || *pt == '#' ) break; //exit from while loop
				v++;
				status = 'n';
				if( atoi( pt ) == 0 )
				{
					fprintf( stderr, "Format error? Sequences should be specified as 1, 2, 3...\n" );
					exit( 1 );
				}
			}
		}
		pt++;
	}
	return( v );
}

//First call of this method with table = NULL reads number of subalignments in subalignments file and assign to nsubpt
//also reads max number of spaces in all sequences into maxmempt
//Second call reads data from the file and fills table with it
void readsubalignmentstable( int nseq, int **table, int *preservegaps, int *nsubpt, int *maxmempt ) {
	FILE *fp;
	char *line;
	int linelen = 1000000;
	int nmem;
	int lpos;
	int i, p;
	int *tab01;

	line = (char *) calloc( linelen, sizeof( char ) );
	fp = fopen( "_subalignmentstable", "r" ); //I need to know where this file exists and what is its content?
	if( !fp )
	{
		fprintf( stderr, "Cannot open _subalignmentstable\n" );
		exit( 1 );
	}
	if( table == NULL )
	{
		*nsubpt = 0;
		*maxmempt = 0;
		while( 1 )
		{
			fgets( line, linelen-1, fp );
			if( feof( fp ) ) break;
			if( line[strlen(line)-1] != '\n' ) //line length exceeds max length
			{
				fprintf( stderr, "too long line? \n" );
				exit( 1 );
			}
			if( line[0] == '#' ) continue; //comment line, so jump to next iteration, i. e. line
			if( atoi( line ) == 0 ) continue; //jump to next iteration, i. e. line
			nmem = countspace( line ); //defined here. converts all tabs in line to spaces and counts their number
			if( nmem > *maxmempt ) *maxmempt = nmem; //maxmempt contains max number of spaces in all subalignments
			(*nsubpt)++; //increment count of subalignments
		}
	}
	else
	{
		tab01 = (int *) calloc( nseq, sizeof( int ) );
		for( i=0; i<nseq; i++ ) tab01[i] = 0;
		lpos = 0;
		while( 1 )
		{
			fgets( line, linelen-1, fp );
			if( feof( fp ) ) break;
			if( line[strlen(line)-1] != '\n' ) //line length exceeds max length
			{
				fprintf( stderr, "too long line? \n" );
				exit( 1 );
			}
			if( line[0] == '#' ) continue; //comment line, so jump to next iteration, i. e. line
			if( atoi( line ) == 0 ) continue; //jump to next iteration, i. e. line
			readasubalignment( line, table[lpos], preservegaps+lpos ); //defined here. read sequence in line and fill table[lpos] with chars
			for( i=0; (p=table[lpos][i])!=-1; i++ ) //i think this loop checks for duplicated sequences in different groups
			{
				if( tab01[p] )
				{
					fprintf( stderr, "\nSequence %d appears in different groups.\n", p+1 );
					fprintf( stderr, "Hierarchical grouping is not supported.\n\n" );
					exit( 1 );
				}
				tab01[p] = 1;
				if( p > nseq-1 )
				{
					fprintf( stderr, "Sequence %d does not exist in the input sequence file.\n", p+1 );
					exit( 1 );
				}
			}
			lpos++;
		}
		free( tab01 );
	}
	fclose( fp );
	free( line );
}


void ErrorExit( char *message )
{
	fprintf( stderr, "%s\n", message );
	exit( 1 );
}

//inits signalSM value which is defined in defs.h.
void initSignalSM( void )
{
//	int signalsmid;

#if IODEBUG
	if( ppid ) fprintf( stderr, "PID of xced = %d\n", ppid );
#endif
	if( !ppid ) //ppid is int defined in defs.h
	{
		signalSM = NULL; //signalSM is char* defined in defs.h
		return;
	}

#if 0
	signalsmid = shmget( (key_t)ppid, 3, IPC_ALLOC | 0666 );
	if( signalsmid == -1 ) ErrorExit( "Cannot get Shared memory for signal.\n" );
	signalSM = shmat( signalsmid, 0, 0 );
	if( (int)signalSM == -1 ) ErrorExit( "Cannot attatch Shared Memory for signal!\n" );
	signalSM[STATUS] = IMA_KAITERU;
	signalSM[SEMAPHORE] = 1;
#endif
}

//init prep_g and trap_g files. I think these files are for tracing
void initFiles( void )
{
	char pname[100];
	if( ppid )
		sprintf( pname, "/tmp/pre.%d", ppid );
	else
		sprintf( pname, "pre" );
	prep_g = fopen( pname, "w" ); //prep_g is FILE* defined in defs.h
	if( !prep_g ) ErrorExit( "Cannot open pre" );

	trap_g = fopen( "trace", "w" ); //trap_g is FILE* defined in defs.h
	if( !trap_g ) ErrorExit( "cannot open trace" );
	fprintf( trap_g, "PID = %d\n", getpid() ); //getpid -> get process ID
	fflush( trap_g );
}

void closeFiles( void )
{
	fclose( prep_g );
	fclose( trap_g );
}

static void showaamtxexample()
{
	fprintf( stderr, "Format error in aa matrix\n" );
	fprintf( stderr, "# Example:\n" );
	fprintf( stderr, "# comment\n" );
	fprintf( stderr, "   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V\n" );
	fprintf( stderr, "A  4 -1 -2 -2  0 -1 -1  0 -2 -1 -1 -1 -1 -2 -1  1  0 -3 -2  0\n" );
	fprintf( stderr, "R -1  5  0 -2 -3  1  0 -2  0 -3 -2  2 -1 -3 -2 -1 -1 -3 -2 -3\n" );
	fprintf( stderr, "...\n" );
	fprintf( stderr, "V  0 -3 -3 -3 -1 -2 -2 -3 -3  3  1 -2  1 -1 -2 -2  0 -3 -1  4\n" );
	fprintf( stderr, "frequency 0.07 0.05 0.04 0.05 0.02 .. \n" );
	fprintf( stderr, "# Example end\n" );
	fprintf( stderr, "Only the lower half is loaded\n" );
	fprintf( stderr, "The last line (frequency) is optional.\n" );
	exit( 1 );
}

double *loadaamtx( void ) //called when Blosum number = -1 ---- read user defined matrix and return it
{
	int i, j, k, ii, jj;
	double *val;
	double **raw;
	int *map;
	char *aaorder = "ARNDCQEGHILKMFPSTWYV";
	char *inorder;
	char *line;
	char *ptr1;
	char *ptr2;
	char *mtxfname = "_aamtx";
	FILE *mf;

	raw = AllocateDoubleMtx( 21, 20 );
	val = AllocateDoubleVec( 420 );
	map = AllocateIntVec( 20 );

	if( dorp != 'p' )
	{
		fprintf( stderr, "User-defined matrix is not supported for DNA\n" );
		exit( 1 );
	}

	mf = fopen( mtxfname, "r" );
	if( mf == NULL )
	{
		fprintf( stderr, "Cannot open the _aamtx file\n" );
		exit( 1 );
	}

	inorder = (char *) calloc( 1000, sizeof( char ) );
	line = (char *) calloc( 1000, sizeof( char ) );


	while( !feof( mf ) )
	{
		fgets( inorder, 999, mf );
		if( inorder[0] != '#' ) break;
	}
	ptr1 = ptr2 = inorder;
	while( *ptr2 )
	{
		if( isalpha( *ptr2 ) )
		{
			*ptr1 = toupper( *ptr2 );
			ptr1++;
		}
		ptr2++;
	}
	inorder[20] = 0;

	for( i=0; i<20; i++ )
	{
		ptr2 = strchr( inorder, aaorder[i] );
		if( ptr2 == NULL )
		{
			fprintf( stderr, "%c: not found in the first 20 letters.\n", aaorder[i] );
			showaamtxexample(); //defined here in io.c. Shows error and example for aamtx then exit
		}
		else
		{
			map[i] = ptr2 - inorder;
		}
	}

	i = 0;
	while( !feof( mf ) )
	{
		fgets( line, 999, mf );
//		fprintf( stderr, "line = %s\n", line );
		if( line[0] == '#' ) continue;
		ptr1 = line;
//		fprintf( stderr, "line = %s\n", line );
		for( j=0; j<=i; j++ )
		{
			while( !isdigit( *ptr1 ) && *ptr1 != '-' && *ptr1 != '.' )
				ptr1++;

			raw[i][j] = atof( ptr1 );
//			fprintf( stderr, "raw[][]=%f, %c-%c %d-%d\n", raw[i][j], inorder[i], inorder[j], i, j );
			ptr1 = strchr( ptr1, ' ' );
			if( ptr1 == NULL && j<i) showaamtxexample();
		}
		i++;
		if( i > 19 ) break;
	}

	for( i=0; i<20; i++ ) raw[20][i] = -1.0;
	while( !feof( mf ) )
	{
		fgets( line, 999, mf );
		if( line[0] == 'f' )
		{
//			fprintf( stderr, "line = %s\n", line );
			ptr1 = line;
			for( j=0; j<20; j++ )
			{
				while( !isdigit( *ptr1 ) && *ptr1 != '-' && *ptr1 != '.' )
					ptr1++;

				raw[20][j] = atof( ptr1 );
//				fprintf( stderr, "raw[20][]=%f, %c %d\n", raw[20][j], inorder[i], j );
				ptr1 = strchr( ptr1, ' ' );
				if( ptr1 == NULL && j<19) showaamtxexample();
			}
			break;
		}
	}

	k = 0;
	for( i=0; i<20; i++ )
	{
		for( j=0; j<=i; j++ )
		{
			if( i != j )
			{
				ii = MAX( map[i], map[j] );
				jj = MIN( map[i], map[j] );
			}
			else ii = jj = map[i];
			val[k++] = raw[ii][jj];
//			fprintf( stderr, "%c-%c, %f\n", aaorder[i], aaorder[j], val[k-1] );
		}
	}
	for( i=0; i<20; i++ ) val[400+i] = raw[20][map[i]];

	fprintf( stderr, "inorder = %s\n", inorder );
	fclose( mf );
	free( inorder );
	free( line );
	FreeDoubleMtx( raw );
	free( map );
	return( val );
}

char *progName( char *str )
{
    char *value;
    if( ( value = strrchr( str, '/' ) ) != NULL )
        return( value+1 );
    else
        return( str );
}

int myatoi( char *in )
{
	if( in == NULL )
	{
		fprintf( stderr, "Error in myatoi()\n" );
		exit( 1 );
	}
	return( atoi( in ) ); //'atoi' converts the string argument to integer
}

void reporterr( const char *str, ... )
{
//	static int loglen = 0;
	va_list args;

	if( gmsg )
	{
# if 1  // ato de sakujo
		static FILE *errtmpfp = NULL;
		if( errtmpfp == NULL )
			errtmpfp = fopen( "maffterr", "w" );
		else
			errtmpfp = fopen( "maffterr", "a" );
		va_start( args, str );
		vfprintf( errtmpfp, str, args );
		va_end( args );
		fclose( errtmpfp );
#endif

#if 0
		char *tmpptr;
		tmpptr = (char *)realloc( *gmsg, (loglen+10000) * sizeof( char ) );
		if( tmpptr == NULL )
		{
			fprintf( stderr, "Cannot relloc *gmsg\n" );
			exit( 1 );
		}
		*gmsg = tmpptr;
		va_start( args, str );
		loglen += vsprintf( *gmsg + loglen, str, args );
		va_end( args );


		va_start( args, str );
		loglen += vsprintf( *gmsg + loglen, str, args );
		va_end( args );
		*(*gmsg + loglen) = 0;
		if( loglen > gmsglen - 100 ) loglen = 0; // tekitou
#endif

	}
	else
	{
		va_start( args, str );
		vfprintf( stderr, str, args );
		va_end( args );
//		fflush( stderr ); // iru?
	}
	return;
}

