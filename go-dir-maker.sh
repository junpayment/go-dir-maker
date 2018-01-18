#!/usr/bin/env bash
echo "It's interactive making go working directories tool."
echo "go and direnv are required."
echo ""

echo -n "continue?:(yes/no):"

read answer
case ${answer} in
  yes)
    ;;
 *)
    exit 1
    ;;
esac

# check go exists
go version || echo "go not found." || exit 1

# check direnv exists
direnv version || echo "direnv not found." || exit 1

# set and check environments
echo -n "Set GOPATH.(Default: \$HOME/go):"
read tempGOPATH
tempGOPATH=`eval "echo ${tempGOPATH}"`

if [ ${tempGOPATH} != "" ]; then
  echo -n ""
else
  echo "GOPATH should not be empty."
  exit 1
fi

if [[ ${tempGOPATH} =~ ^\/ ]]; then
  echo -n ""
else
  echo "GOPATH should be absolute path." || exit 1
  exit 1
fi

if [ -e ${tempGOPATH} ]; then
  echo -n ""
else
  echo "GOPATH not exists." || exit 1
  exit 1
fi

if [ -d ${tempGOPATH} ]; then
  echo -n ""
else
  echo "GOPATH is file." || exit 1
  exit 1
fi

GOPATH=${tempGOPATH}
GOBIN=${GOPATH}/bin

# set github name
echo -n "Set user name(use github.com path, Default current username):"
read tempUserName
USERNAME=${tempUserName:-${USER}}

# create directories
pushd ${GOPATH}
mkdir src pkg bin
mkdir -p src/github.com/${USERNAME}
cat << EOS > .envrc
export GOPATH=${GOPATH}
export GOBIN=${GOBIN}
export PATH=\$PATH:${GOBIN}
EOS
direnv allow
popd

# display results
echo "below directories and file created."
echo "======"
tree -a $GOPATH
echo "======"
#=========
