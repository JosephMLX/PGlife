typedef struct {
	int day, month, year;
} DateT;

typedef struct {
	int hour, minute;
} TimeT;

typedef struct {
	int transaction_number;
	char weekday[4];
	DateT date;
	TimeT time;
	char mode;
	char from[32], destination[32];
	int journey;
	char faretext[12];
	float fare, discount. amount;
} JourneyT;