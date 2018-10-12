# README

First build as "frederikspang/csgo-mgmt" or what ever you'd like

Then run the server

```bash
docker run -d -p "3000:3000" \
  -e "TOURNAMENT_ID=MYKEY" \
  -e "CHALLONGE_API_USER=LOGIN" \
  -e "CHALLONGE_API_KEY=TOKEN" \
  frederikspang/csgo-mgmt
```