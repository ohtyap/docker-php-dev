## DOCKER PHP DEV

```shell
gem install docker-sync
cd ~
git clone git@github.com:ohtyap/docker-php-dev.git .docker-php-dev
cd .docker-php-dev
cp env-example .env
```

Open and edit `.env`. `APP_CODE_PATH_HOST` should point to your root directory 
of all your projects/repositories.

Generate/export your ssh keys and gpg keys and store them in the `keys` directory.
```shell
cd keys
ssh-keygen -t ed25519 -C "<your email>" -f id_ed2551
gpg --full-generate-key
gpg --export-secret-keys <id> > gpg.key
cd ..
```

Start building your docker containers:
```shell
# Building all
docker-compose build
# or building selected ones
docker-compose build <name>

# Bringing all containers up
docker-compose up -d 
# or bringing up selected containers
docker-compose up -d <name>
```

To build/enter a workspace container:
```shell
docker-compose build workspace-php-<version>
docker-compose up -d workspace-php-<version>
docker exec -it workspace-php-<version> /bin/zsh
```
