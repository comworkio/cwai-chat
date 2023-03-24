# CWAI-CHAT

## Getting started in localhost

First, create an environment variables file:

```shell
cp .env.dist .env # replace the values
```

```shell
docker-compose -f docker-compose-local.yml up --build --force-recreate
```

If you're on a MacOS (M1 or x86):

```shell
brew install flutter
./build.macos.sh
```

Then you'll be able to test on http://localhost:3000
