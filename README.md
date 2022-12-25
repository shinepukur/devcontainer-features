# Some useful Dev Container Features

> This repo provides useful features to use with a [devcontainer](https://containers.dev/) (e.g. in VS Code or GitHub Codespaces). 
> To learn more about all available features, please refer to this [features list](https://containers.dev/features).  

## Available features

### `vale`

Install [`vale`](https://vale.sh/), a prose linter for your documentation.
Learn more about the feature [here](./src/vale/README.md).

## How-to use a feature

The features in this repository can be used like any other availables features.
You need to reference them in your `.devcontainer.json`, and set specific feature options if you need.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/shinepukur/devcontainer-features/vale:1": {
            // specify here any options you would like to set for the feature
            "version": "latest"
        }
    }
}
```

## Credits

This repository is derived from the [feature starter template](https://github.com/devcontainers/feature-starter).
