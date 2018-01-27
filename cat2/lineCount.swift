import Foundation

#if os(Linux)
import Glibc
#endif

let argc = CommandLine.arguments.count
let argv = CommandLine.arguments

for file in argv[1..<argc] {
	var f: UnsafeMutablePointer<FILE>?
	var c: Int32
	var lineNum: UInt32 = 0
	let  asciiReturn: UInt32 = 10

	f = fopen(file, "r")
	if f == nil {
		perror(file)
		exit(1)
	}
	while true {
		c = fgetc(f)
		if c == EOF { break }
		if c == asciiReturn { lineNum += 1 }
	}
	print("\(file): \(lineNum)")
}
