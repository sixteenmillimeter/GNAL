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
	python3
)

for dep in ${DEPS[@]}; do
	if ! command -v "${dep}" &> /dev/null
	then
	    echo "Application ${dep} could not be found"
	    if [[ "${dep}" == "admesh" ]]; then
	    	echo "For more information about how to install admesh https://github.com/admesh/admesh"
	    	echo "OR https://www.howtoinstall.me/ubuntu/18-04/admesh/"
	    	echo "Individual .scad files can be compiled directly without this binary but will be unoptimized"
	    elif [[ "${dep}" == "povray" ]]; then
	    	echo "For more information about how to install POV-Ray https://wiki.povray.org/content/HowTo:Install_POV"
	    	echo "Individual .scad files can be compiled without this binary"
	    else
	    	echo "Please install ${dep} before running the build script"
	    	exit 1
	    fi
	fi
done

echo "All dependencies are installed"

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
CORES=`bash ./scripts/cores.sh`

echo "CPU: (${CORES}x) ${CPU}"
echo "OpenSCAD: ${VERSION}"

