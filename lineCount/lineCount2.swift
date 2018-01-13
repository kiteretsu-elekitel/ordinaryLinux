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
	let fileURL: URL = URL(fileURLWithPath: filePath)
	let contents: String?
	do {
		contents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
	} catch {
		print(error, to: &standardError)
		print("No such find \(filePath)")
		exit(1)
	}

	if let target = contents {
		let lines = target.components(separatedBy: NSCharacterSet.newlines)
		print(lines.count - 1)
	} else {
		print("0")
	}


}

func doCatStdin() {
	//var fd: CInt
	var buf = Array<UInt8>(repeating: 0, count: Int(BUFSIZ))
	var n: Int
	var count: UInt8 = 0
	//10 is return code by ASCII
	let target: UInt8 = 10


	//fd = open(&STDIN_FILENO, O_RDONLY)

	//if fd < 0 { die(s: "STDIN") }
	while true {
		n = read(STDIN_FILENO, &buf, Int(BUFSIZ))
		if n < 0 { die(s: "STDIN") }
		if n == 0 { break }
		for i in buf {
			if i == target { count = count + 1 }
		}
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






