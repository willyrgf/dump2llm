# dump2llm

Dump a Git repo or entire path as text for LLM chats.

## Run with Nix
```
# it builds bash and git from scratch as deps
nix run github:willyrgf/dump2llm -- <git-repo-url|local-path>
```

## Install using Nix
```
nix profile install github:willyrgf/dump2llm
```

## Install manually
```
# download the raw script directly into /usr/local/bin
sudo curl -sSL \
  https://raw.githubusercontent.com/willyrgf/dump2llm/main/dump2llm \
  -o /usr/local/bin/dump2llm

# make it executable
sudo chmod +x /usr/local/bin/dump2llm

# verify it’s on your path
which dump2llm && dump2llm --help
```

