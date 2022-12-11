import std.stdio;
import std.conv;
import std.math;
import std.string;

/**
Main loop.
*/
void main(string[] argv)
{
	uint lineCount = 0;
	int cycleCount = 0;
	int registerValue = 1;
	int signalStrengthTotal = 0;
	string crt = "";

	// Display usage if no arguments are given
	if (argv.length < 2)
	{
		writeln("Usage: ", argv[0], " <input file>");
		return;
	}

	File file = File(argv[1], "r");

	// Read file line by line
	while (!file.eof())
	{
		string line = chomp(file.readln());
		if (!line) { break; } // Break if empty line
		lineCount++;
		// writeln("Line ", lineCount, ": ", line, " - ", cycleCount);

		string[] splitLine = line.split(" ");
		if (splitLine[0] == "noop") {
			cycleLoop(&cycleCount, &signalStrengthTotal, registerValue, &crt);
		}
		else if (splitLine[0] == "addx") {
			cycleLoop(&cycleCount, &signalStrengthTotal, registerValue, &crt);
			cycleLoop(&cycleCount, &signalStrengthTotal, registerValue, &crt);
			int value = to!int(splitLine[1]);
			registerValue += value;
		}

	}
	file.close();

	// Display results
	writeln("Total Signal Strength: ", signalStrengthTotal);
	displayCRT(crt);
}

/**
Checks if the signal strength should be updated.

Params:
	cycleCount = The cycle count.
	registerValue = The register value.

Returns: The signal strength.
*/
int checkSignalStrength(uint cycleCount, int registerValue) {
	int offsetCycleCount = cycleCount - 20;
	int signalStrength = 0;

	if (cycleCount == 20 || offsetCycleCount % 40 == 0) {
		signalStrength = registerValue * cycleCount;
	}

	return signalStrength;
}

/**
The cycle loop.

Params:
	cycleCount = The cycle count pointer.
	signalStrengthTotal = The signal strength total pointer.
	registerValue = The register value.
	crt = The CRT display pointer.
*/
void cycleLoop(int* cycleCount, int* signalStrengthTotal, int registerValue, string* crt) {
	updateCRT(*cycleCount, registerValue, crt);
	*cycleCount += 1;
	*signalStrengthTotal += checkSignalStrength(*cycleCount, registerValue);
}

/**
Updates the CRT display.

Params:
	cycleCount = The cycle count.
	registerValue = The register value.
	crt = The CRT display pointer.
*/
void updateCRT(int cycleCount, int registerValue, string* crt) {
	string CRT_LIT = "X";
	string CRT_DARK = " ";
	string* selectedCRTString;

	if ((registerValue - 1 <= crt.length % 40 && registerValue + 1 >= crt.length % 40) || 
		(crt.length >= 40 && registerValue - 1 <= 1 && registerValue + 1 >= -1 && (crt.length - 40) % 40 == 0)
	) {
		selectedCRTString = &CRT_LIT;
	} else {
		selectedCRTString = &CRT_DARK;
	}
	*crt ~= *selectedCRTString;

	// writeln("Cycle ", cycleCount, " - Register Value: ", registerValue, " - CRT Draw Position: ", crt.length % 40, " - Added: ", *selectedCRTString);
	// displayCRT(*crt);
}

/**
Displays the CRT display.
Display width is 40 characters.

Params:
	crt = The CRT display.
*/
void displayCRT(string crt) {
	write("---------------CRT DISPLAY--------------");
	for (int i = 0; i < crt.length; i++) {
		if (i % 40 == 0) {
			writeln();
		}
		write(crt[i]);
	}
	writeln("\n----------------------------------------");
}
