import Foundation
#if os(Linux)
	import Glibc
#endif

var standardError = FileHandle.standardError
extension FileHandle : TextOutputStream {
	public func write(_ string: String) {
		guard let data = string.data(using: .utf8) else { return }
		self.write(data)
	}
}

func die(s: String) {
	perror(s);
	exit(1);
}

func do_cat(path: String) {
	var f: UnsafeMutablePointer<FILE>?
	var buf: [CChar] = []

	f = fopen(path, "r")
	if f == nil { die(s: path) }

	while true {
		var nRead: size_t = fread(&buf, 1, 2048, f)
		if ferror(f) != 0 { die(s: path) }
		var nWrite: size_t = fwrite(buf, 1, nRead, stdout)
		if nWrite < nRead { die(s: path)}
		if nRead > buf.count {break}
	}
	fclose(f)

}

let argc = CommandLine.arguments.count
let argv = CommandLine.arguments

if argc < 2 {
	print("\(argv[0]): file name not given", to: &standardError)
}
for file in argv[1..<argc] {
	do_cat(path: file)
}
