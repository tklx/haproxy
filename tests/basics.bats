fatal() { echo "fatal [$(basename $BATS_TEST_FILENAME)]: $@" 1>&2; exit 1; }

_in_cache() {
    IFS=":"; img=($1); unset IFS
    [[ ${#img[@]} -eq 1 ]] && img=("${img[@]}" "latest")
    [ "$(docker images ${img[0]} | grep ${img[1]} | wc -l)" = "1" ] || return 1
}

APPNAME=haproxy

[ "$IMAGE" ] || fatal "IMAGE envvar not set"
_in_cache "$IMAGE" || fatal "$IMAGE not in cache"

_init() {
    export TEST_SUITE_INITIALIZED=y

    echo >&2 "init: running $IMAGE"

    export CNAME="$APPNAME-$RANDOM-$RANDOM"
    export CID="$(docker run -d --name "$CNAME" -v $(dirname "$HAPROXY_CONFIG"):/tmp -p 1936 "$IMAGE")"
    [ "$CIRCLECI" = "true" ] || trap "docker rm -vf $CID > /dev/null" EXIT
}
[ -n "$TEST_SUITE_INITIALIZED" ] || _init

# @test "haproxy is running" {
#    ip=$(docker inspect "$CID" | grep '\"IPAddress\"' | head -1 | cut -d':' -f2 | tr -d '", ')
#    curl -s "http://$ip" --port 1936
#    [ $? -eq 0 ]
# }

