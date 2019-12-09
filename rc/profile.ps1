#powershell profile

function cdto($util)
{
	cd $(cygpath -w $(dirname $(which $util)))
}

function cdd()
{
	cd "C:\Users\nefedov\Desktop\"
}
