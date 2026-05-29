# Ceph

I built this trying to get kubernetes working. I realized I couldn't have dynamic state without finding a distributed filesystem.

```bash
ariadne@tiny-4:~$ sudo ceph status

  cluster:
    id:     06184e1d-d46d-43fb-80ef-8b485942ca80
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum tiny-5,tiny-4,tiny-7 (age 12d)
    mgr: tiny-5(active, since 2w), standbys: tiny-4, tiny-7
    mds: 1/1 daemons up, 2 standby
    osd: 4 osds: 4 up (since 13d), 4 in (since 7M)
 
  data:
    volumes: 1/1 healthy
    pools:   4 pools, 97 pgs
    objects: 7.92k objects, 30 GiB
    usage:   88 GiB used, 2.4 TiB / 2.5 TiB avail
    pgs:     97 active+clean
```

My first ceph cluster I tried with USB 3.0 thumbdrives ... ceph eats bandwidth, so this is backed with 20G port channels with NVME drives.

```bash
ariadne@tiny-4:~$ sudo rados bench -p rbd 10 write --no-cleanup

hints = 1
Maintaining 16 concurrent writes of 4194304 bytes to objects of size 4194304 for up to 10 seconds or 0 objects
Object prefix: benchmark_data_tiny-4_4182550
  sec Cur ops   started  finished  avg MB/s  cur MB/s last lat(s)  avg lat(s)
    0       0         0         0         0         0           -           0
    1      16       222       206   823.898       824    0.138184    0.073974
    2      16       438       422   843.911       864     0.12581   0.0742721
    3      16       646       630   839.918       832    0.112153    0.075176
    4      16       853       837   836.922       828    0.077436   0.0753808
    5      16      1064      1048   838.323       844   0.0452554   0.0754338
    6      16      1286      1270   846.589       888   0.0690823    0.075085
    7      16      1489      1473   841.637       812     0.12503   0.0754491
    8      16      1702      1686   842.924       852   0.0767748   0.0755216
    9      16      1920      1904   846.146       872   0.0426611   0.0751712
   10      16      2134      2118   847.123       856   0.0574978   0.0751677
Total time run:         10.0712
Total writes made:      2134
Write size:             4194304
Object size:            4194304
Bandwidth (MB/sec):     847.568
Stddev Bandwidth:       23.6868
Max bandwidth (MB/sec): 888
Min bandwidth (MB/sec): 812
Average IOPS:           211
Stddev IOPS:            5.92171
Max IOPS:               222
Min IOPS:               203
Average Latency(s):     0.075293
Stddev Latency(s):      0.0340845
Max latency(s):         0.221071
Min latency(s):         0.0187221
```