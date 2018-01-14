import Foundation
import Glibc

let argList = CommandLine.arguments[1..<CommandLine.arguments.count]
for file in argList {
	var c: Int32
	var f: UnsafeMutablePointer<FILE>! = fopen(file, "r")

	if f == nil {
		perror(file)
		exit(1)
	}
	while true {
		c = fgetc(f)
		if c == -1 {break}
		if putchar(c) < 0 { exit(1) }
	}
	fclose(f)
}


