import Glibc
import Foundation

//Standard error setting
//Requied Foundation Lib
var standardError = FileHandle.standardError
extension FileHandle : TextOutputStream {
  public func write(_ string: String) {
    guard let data = string.data(using: .utf8) else { return }
    self.write(data)
  }
}

func die (s: String) {
	perror(s)
	exit(1)
}

func do_cat(filePath: String) {
	var fd: CInt
	var buf = Array<UInt8>(repeating: 0, count: Int(BUFSIZ))
	var n: Int

	fd = open(filePath, O_RDONLY)

	if fd < 0 { die(s: filePath) }
	while true {
		n = read(fd, &buf, Int(BUFSIZ))
		if n < 0 { die(s: filePath) }
		if n == 0 { break }
		if write(STDOUT_FILENO, buf, n) < 0 { die(s: filePath) }
	}
	if close(fd) < 0 { die(s: filePath) }
}

func doCatStdin() {
	//var fd: CInt
	var buf = Array<UInt8>(repeating: 0, count: Int(BUFSIZ))
	var n: Int

	//fd = open(&STDIN_FILENO, O_RDONLY)

	//if fd < 0 { die(s: "STDIN") }
	while true {
		n = read(STDIN_FILENO, &buf, Int(BUFSIZ))
		if n < 0 { die(s: "STDIN") }
		if n == 0 { break }
		if write(STDOUT_FILENO, buf, n) < 0 { die(s: "STDIN") }
	}
	//if close(fd) < 0 { die(s: "STDIN") }
}

// main Function
var noArgFlg: Bool
if CommandLine.arguments.count > 1 {
	noArgFlg = false
} else {
	noArgFlg = true
}

if noArgFlg {
	doCatStdin()
} else {
	let filelist = CommandLine.arguments[1..<CommandLine.arguments.count]
	for file in filelist {
		do_cat(filePath: file)
	}
}

exit(0)






