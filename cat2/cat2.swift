import Foundation

let argList = CommandLine.arguments[1..<CommandLine.arguments.count]
for file in argList {
	var c: Int32
	var f = fopen(file, "r")

	if &f != 0 {
		perror(file)
		exit(1)
	}

	while (c = fgetc(f)) != EOF {
		if putchar(c) < 0 { exit(1) }
	}
	fclose(f)
}


