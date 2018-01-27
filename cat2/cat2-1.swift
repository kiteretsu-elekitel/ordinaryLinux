import Foundation

let argv: [String] = CommandLine.arguments
let argc = CommandLine.arguments.count

//let tab = "\t"
//let rturn = "\n"
//let bslash = "\\"
//let charT = "t"
//
//let ctab: CChar = tab.cStringUsingEncoding(NSASCIIStringEncoding)
//let creturn: CChar = rturn.cStringUsingEncoding(NSASCIIStringEncoding)
//let cbslash: CChar = bslash.cStringUsingEncoding(NSASCIIStringEncoding)
//let cCharT: CChar = charT.cStringUsingEncoding(NSASCIIStringEncoding)

let ctab: Int32 = 9
let creturn: Int32 = 10
let cbslash: Int32 = 92
let cCharT: Int32 = 116

for file in argv[1..<argc] {
	var f: UnsafeMutablePointer<FILE>
	var c: Int32

	f = fopen(file, "r")
	if f == nil {
		perror(file)
		exit(1)
	}

	while true {
		c = fgetc(f)
		if c == EOF {
			break
		}
		switch c {
		case ctab:
			if putchar(cbslash) < 0 { exit(1) }
			if putchar(cCharT) < 0 { exit(1) }
		case creturn:
			if putchar(cbslash) < 0 { exit(1) }
			if putchar(creturn) < 0 { exit(1) }
		default:
			if putchar(c) < 0 { exit(1) }
		}
	}
	fclose(f)
}
