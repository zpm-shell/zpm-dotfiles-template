# ZPM Dotfiles

Welcome to my personal dotfiles repository for Zsh, managed with the Zsh Plugin Manager (ZPM). This setup is designed to streamline my shell environment with custom configurations, functions, and themes for Zsh.

## Prerequisites

Before you get started, ensure you have `zsh` installed on your system. ZPM will be used to manage Zsh plugins and themes.

## Installation

To install these dotfiles and set up Zsh with ZPM, follow these steps:

1. **Clone the Repository:**

```sh
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
```

2. **Install ZPM:**

If you haven't installed ZPM yet, you can do so by running:

```sh
curl -fsSL https://raw.githubusercontent.com/zpm-zsh/zpm/master/zpm.zsh | zsh
```

3. **Link ZPM Configuration:**

Link the `zpm.zsh` file from the dotfiles repository to your home directory:

```sh
ln -s ~/dotfiles/zpm.zsh ~/.zpm.zsh
```

4. **Update `.zshrc`:**

Add the following line to your `~/.zshrc` file to initialize ZPM with the configuration:

```sh
source ~/.zpm.zsh
```

5. **Apply the Configuration:**

Open a new Zsh terminal session or source your `.zshrc` file to apply the changes:

```sh
source ~/.zshrc
```

## Features

- **Plugin Management:** Easily add, update, and manage Zsh plugins.
- **Themes:** Customize your terminal's appearance with ZPM-managed themes.
- **Aliases and Functions:** Define your own shortcuts and functions for common tasks.
- **Prompt Customization:** Adjust your prompt with ZPM plugins and themes to display the information you need.

## Customizing

To customize your Zsh environment:

- Edit `zpm.zsh` to add or remove plugins and themes.
- Modify `aliases.zsh` and `functions.zsh` to tweak your aliases and shell functions.

## Contributing

Feel free to fork this repository and customize your own Zsh environment. If you have suggestions or improvements, pull requests are welcome.

## License

This dotfiles repository is open-sourced under the MIT license.