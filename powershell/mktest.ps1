# $Id$ $Revision$ $Author$ $Date$

if ($args.count -lt 1) {
	echo ""
	echo "Usage: mktest.ps1 <path> <file_1_size> [file_2_size] ..."
	echo ""
	echo "Where <path> is the directory where new files will be created"
	echo "File sizes are specified as #, #kb, #mb or #gb"
	echo ""
	exit
} elseif (!(Test-Path $args[0] -pathType container)) {
	echo "Not a directory:" $args[0]
	exit
}

$fullpath = (resolve-path $args[0]).Path

for ($i = 1; $i -lt $args.count; $i++) {
	$path = $fullpath + "\testfile_" + $i
	$file = [io.file]::Create($path)
	$file.SetLength($args[$i])
	$file.Close()
	get-item $path
}
