import Glibc

print("args=\(CommandLine.arguments.count)")

var count = 0
for args in CommandLine.arguments {

	print("args[\(count)]=\(args)")
	count = count + 1
}


