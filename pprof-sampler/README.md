# pprof-sampler

This README explains how to collect pprof profiles from Go applications built by [go-with-wakeup-profile](https://github.com/IBM/go-with-wakeup-profile), which gathers additional profiles about goroutines who wake up others (i.e. "wakeup profile"). Along with [pprof and block profiles](https://golang.org/pkg/net/http/pprof/) that the standard Go runtime can collect, the wakeup profile helps us to detect performance bottlenecks in Go applications.

## How to configure a sampler

Copy [config.json](/config.json) locally and edit it. List a pair of the IP address and port for all target Go processes under `addresses` tag. `pprof`, `wakeup`, and `block` under `paths` tag enable the standard pprof, the wakeup profile, and the block profile, respectively. `rate=1000` indicates the sampling rate of the wakeup profile. Note that the block profile is collected after the application calls runtime.SetBlockProfileRate. Thus, typically the application needs to be modifed to collect the block profile.

```
{
  "addresses": [
    "localhost:6060"
  ],
  "paths": {
    "pprof": "/debug/pprof/goroutine?debug=2",
    "wakeup": "/debug/pprof/wakeup?debug=2&rate=1000",
    "block": "/debug/pprof/block?debug=1"
  }
}
```

## How to run the sampler

```
$ docker build -t pprof-sampler .
$ docker run -v $(pwd)/config.json:/config.json:ro -e SAMPLING_RATE=10s --name pprof-sampler pprof-sampler
```

Here, "SAMPLING_RATE" specificies the interval time in the number of seconds to collect profiles (e.g. every 10 seconds in this example).


## How to stop the sampler and save the profile data

```
docker stop -t 0 pprof-sampler
docker cp pprof-sampler:/profiles .
docker rm -f pprof-sampler
```

The profiles directory now contain collected profile data for further examination.


