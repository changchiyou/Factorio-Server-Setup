```
docker compose -f mapshot.yml -p factorio-mapshot stop
docker compose -f mapshot.yml -p factorio-mapshot build
docker compose -f mapshot.yml -p factorio-mapshot up -d
```

```
docker compose -f factorio.yml -p factorio-server stop
docker compose -f factorio.yml -p factorio-server up -d
```