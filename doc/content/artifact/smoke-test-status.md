---
title: Smoke (end-to-end) test status
expirydate: 2019-03-27
author: Anton Evangelatov
---

We have a few different types of smoke tests:

1. **Upload speed** smoke test
1. **Upload and sync** smoke test
1. **Sliding window** smoke test
1. **Feed sync** smoke test
1. **PSS** smoke test (in-progress)

These are all meant to be long-running tests targetted at long-running environments (for example `staging-private`), so that we know that Swarm process does not have resource leaks, and so that we collect measurements in terms how long it takes to perform these tests on a given Swarm version/commit.

## The ideal state of the end-to-end tests in the future would be
1. Run all of them on a few long-running environments, such as `staging` and `staging-private`.
2. Have these tests passing >99% of the time.
3. Be able to debug and understand why they failed in the small number of cases when they do fail.
4. Have meaningful dashboards for all of them with past measurements (how long it took for the test to complete, how long it took to upload/download/sync, etc.)
5. Send alerts to the `notifications` Gitter room when tests fail.
6. Have a baseline of how much time tests take for a predefined set of parameters (network size, file size, sync delays, etc.).


## Current state of the end-to-end tests
1. The easiest test to handle is the **Upload speed** smoke test, which only uploads a file to a given node and measures how long it takes. Generally this test is successful 100% of the time for small files (such as 100KB, 1MB, 10MB, etc.) Obviously the bigger the file, the slower we upload it. We can improve the speed it takes to upload a file, but increasing the chunk size from 4KB, to larger sizes, such as 32KB or 64KB. We need to do more research on what the consequences of this would be. We haven't established a baseline of what we deem acceptable in terms of the upload speed, so that we measure this in terms of success/failure alerts, in case we introduce a regression.

    We have dashboards for this test, but no alerts.

2. We have spent the most time on the **Upload and sync** smoke test, which uploads a file to node 0 and tries to download it after a certain delay (generally 30sec) from a random other node. This test has highlighted multiple issues with Swarm, and we still don't have it consistently passing for a larger period of time. Ideally we should get to the point where this test passes consistently for:
    * timeframe: 7 days
    * filesize: 10MB
    * schedule: * * * * * * (every minute)
    * network size: 50 swarm nodes
    * store size for each node: 10000 chunks (* 4KB == 40MB)

    If we get there at least we have some basic confidence that garbage collection works and doesn't remove the most recently uploaded chunks.

    We have dashboards for this test, but no alerts.

3. **Sliding window** smoke test (probably we should rename it) sequentially uploads files 0, 1, 2, ..., N, and on every upload tries to download all previously uploaded files (from 0 to N-1). The idea behind the test is to give us some intuition on the network capacity, as we have had bugs in the past where chunks have been synced to every single node in the network, essentially making the network capacity equal to one node's capacity.

    We don't have dashboards for this test.

4. I haven't put any effort in running the **Feed sync** smoke test

## Screenshots

![](https://i.imgur.com/ETnz6NF.png)

Screenshot of the **Upload and sync** test, where we upload 4MB and 6MB files every 1 minute, showing no failures, as well as the upload and download times for the given files. You can see that there is a huge deviation in terms of the download time (between 3sec and 15sec), highlighting bugs in Swarm.

---
![](https://i.imgur.com/3XpfK44.png)

Screenshot of another **Upload and sync** test in another environment, where we upload 300KB and 500KB files. We see some failures in the dashboard, and we also see a huge deviation in terms of the download time for such small files.

## How to run these tests on your own environment?

You can run your own Swarm deployment on K8s as you all know. The easiest way to do that is copy the configuration of the `staging-private` environment from https://github.com/ethersphere/release-staging and apply the configuration to your own `namespace` with `helmsman --apply -f your-namespace.yaml`.

Make sure you update:
1. network size
2. chunk store size
3. smoke test parameters (schedule, filesize, etc.)
4. persistence