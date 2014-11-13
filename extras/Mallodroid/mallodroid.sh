#! /bin/bash
# Wrapper for Mallodroid running on Docker

FILE=
JAVA=
XML=
CONTAINER="appguarden/mallodroid"

function show_help() {
cat <<EOS
Usage: $0 [-h] -f FILE [-j] [-x] [-c CONTAINER]"

Analyse Android Apps for broken SSL certificate validation.

optional arguments:
  -h            show this help message and exit
  -f FILE       APK File to check
  -j            Show Java code for results for non-XML output
  -x            Print XML output
  -c CONTAINER  Docker container with Mallodroid (appguarden/mallodroid)
EOS
}

# Parse arguments
while getopts hf:jc:x opt; do
  case $opt in
    h)
      show_help
      exit 0;
      ;;

    j) 
      JAVA=1
      ;;

    x)
      XML=1
      ;;
      
    f)
      FILE="$OPTARG" 
      APP="$(basename "$FILE")"
      ;;
    c)
      CONTAINER="$OPTARG"
      ;;
  esac
done

# Check that we have an APK to actually check
if [ -z "$FILE" ]; then
  show_help
  exit 1
fi

# Construct the optional argument string
ARGS=''
if [ -n "$JAVA" ]; then
  ARGS="$ARGS -j"
fi
if [ -n "$XML" ]; then
  ARGS="$ARGS -x"
fi

# Move the app to a temporary directory for bind-mounting into the container
TEMPDIR="$(mktemp -d /tmp/mallodroid.XXXXXXXXXX)"
chmod 0700 "$TEMPDIR"
function on_die() {
rm -rf "$TEMPDIR"
exit -1
}
trap 'on_die' SIGTERM SIGINT
cp "$FILE" "$TEMPDIR/$APP"

# Run Mallodroid in Docker
docker run \
  --rm=true \
  -v "$TEMPDIR:/mnt" \
  "$CONTAINER" \
  mallodroid.py -f "/mnt/$APP" $ARGS

# Clean up
rm -rf "$TEMPDIR"
