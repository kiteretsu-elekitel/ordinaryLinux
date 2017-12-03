import Glibc

typealias IntPointer = UnsafePointer<Int>
typealias CharPointer = UnsafePointer<Char>
let BUFFER_SIZE = 2048

print("args=\(CommandLine.arguments.count)")

func die (s: String) {
	perror(s)
	exit(1)
}

func do_cat(filePath: CharPointer) {
	var fd: CInt
	let buf = [CUnsignedChar]()
	var n: CInt

	fd = open(filePath, O_RDONLY)
	if fd < 0 { die(filePath) }
	while true {
		n = read(fd, buf, BUFFER_SIZE)
		if n < 0 { die(filePath) }
		if n == 0 { break }
		if write(STDOUT_FILENO, buf, n) < 0 { die(filePath) }
	}
	if close(fd) < 0 { die(filePath) }
}

// main Function
guard CommandLine.arguments.count < 2 else {
	fprintf(stderr, "%s: file name not given\n", &CommandLine.arguments.0.cStringUsingEncoging )
}
var count: Int = 0
for args in CommandLine.arguments {

	print("args[\(count)]=\(args)")
	count = count + 1
}





