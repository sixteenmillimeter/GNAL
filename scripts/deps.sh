DEPS=(
	echo
	git
	date
	wc
	grep
	awk
	uniq
	sha256sum
	zip 
	tar
	sqlite3
	admesh
	openscad
	bc
)

for dep in ${DEPS[@]}; do
	if ! command -v "${dep}" &> /dev/null
	then
	    echo "Application ${dep} could not be found"
	    echo "Please install ${dep} before running the build script"
	    if [[ "${dep}" == "admesh" ]]; then
	    	echo "For more information about how to install admesh https://github.com/admesh/admesh"
	    	echo "OR https://www.howtoinstall.me/ubuntu/18-04/admesh/"
	    fi
	    if [[ "${dep}" == "openscad" ]]; then
	    	echo "Individual .scad files can be compiled directly without this script"
	    fi
	    exit 1
	fi
done

echo "All dependencies are installed"

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
CORES=`bash ./scripts/cores.sh`

echo "CPU: (${CORES}x) ${CPU}"
echo "OpenSCAD: ${VERSION}"

