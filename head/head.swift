import Foundation

#if os(Linux)
import Glibc
#endif

func do_head(f: UnsafeMutablePointer<FILE>, arglines: CLong) {
	var c: Int32
	var nlines = arglines

	if nlines <= 0 { return }
	while true {
		c = getc(f)
		if c == EOF { break }
		if putchar(c) < 0 { exit(1)}
		if c == 10 {
			nlines -= 1
			if nlines == 0 { return }
		}
	}
}

extension FileHandle : TextOutputStream {
	public func write(_ string: String) {
		guard let data = string.data(using: .utf8) else {return}
		self.write(data)
	}
}

let argv = CommandLine.arguments
let argc: Int = Int(CommandLine.argc)
let nlines: CLong
var standardError = FileHandle.standardError

if argc < 2 {
	print("Usage: \(argv[0]) n [file file ...]", to: &standardError)
	exit(1)
}
nlines = atol(argv[1])
if argc == 2 {
	do_head(f: stdin, arglines: nlines)
} else {
	for i in argv[2..<argc] {
		let f: UnsafeMutablePointer<FILE>!
		f = fopen(i, "r")
		if f != nil {
			perror(i)
			exit(1)
		}
		do_head(f: f, arglines: nlines)
	}
}

