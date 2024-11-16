# Factorio Server Setup

## Usage

### Factorio

> The combination of [factoriotools/factorio-docker](https://github.com/factoriotools/factorio-docker) and [Mattie112/FactoriGOChatBot](https://github.com/Mattie112/FactoriGOChatBot)

```
docker compose -f factorio.yml -p factorio-server stop
docker compose -f factorio.yml -p factorio-server up -d
```

### Mapshot

> Based on [Palats/mapshot](https://github.com/Palats/mapshot), inspired by [martydingo/Factorio MapShot Containerised](https://github.com/martydingo/factorio-mapshot-docker)

```
docker compose -f mapshot.yml -p factorio-mapshot stop
docker compose -f mapshot.yml -p factorio-mapshot build
docker compose -f mapshot.yml -p factorio-mapshot up -d
```