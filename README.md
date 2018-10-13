# README

## Info

RuCAd is a simple administrations tool for administering Servers and get5-servers through [Challonge](https://challonge.com), making it easier to remotely initialize a match, over `get5_loadmatch_json`, triggered from a web interface.

It's primary use is for the annual LAN, for new students at Aalborg University's bachelor's degree in Computer Science and Software Engineering.

## Running

First pull from `frederikspang/ruslan-rucad`, then run the server

```bash
docker pull frederikspang/ruslan-rucad
docker run -d -p "3000:3000" --env-file=.env frederikspang/csgo-mgmt
```

## Be aware

That the servers IP addresses mustn't be `127.0.0.1` when running this application within Docker, as the routing to localhost, will not route outside the container and into the host, or to other docker images, [like our RUSLAN-CS:GO image](https://hub.docker.com/r/frederikspang/ruslan-csgo/), that is also [on GitHub](https://github.com/aau-datsw/ruslan-csgo).

As Docker usually works as a (double) NAT into the containers, you MAY however use the host PC's LAN address, or any other address, that has a routable IP from the docker image; including public WAN facing IP's, or LAN-IP's on the Host PC's network. Another option here, is to define [docker networks](https://docs.docker.com/v17.09/engine/userguide/networking/) or to build a [docker-compose environment](https://docs.docker.com/compose/).