# QuickCommands

Smart command manager for Ubuntu terminal. Save, search, and execute your frequently used commands instantly.

## Features

- **Smart search** - Find commands as you type
- **Keyboard shortcuts** - Ctrl+R for instant access, Ctrl+S to save, Ctrl+D to delete
- **Instant execution** - Press Enter to run any command
- **Persistent storage** - Commands saved automatically

## Installation

Download and install the latest release:

```bash
# Download the .deb package
curl -LO https://github.com/md-arif-islam/quickcommands/releases/latest/download/quickcommands.deb

# Install
sudo dpkg -i quickcommands.deb

# Activate in current terminal
source ~/.bashrc
```

## Usage

### Interactive Interface

Simply press:

```bash
Ctrl+R
```

**Interface Controls:**

- `↑↓` Navigate through commands
- `Enter` Fill terminal with selected command
- `Ctrl+S` Save new command (type it first)
- `Ctrl+D` Delete selected command
- `Ctrl+C` Exit

### Example Workflow

1. Press `Ctrl+R` to open interface
2. Type `git status` and press `Ctrl+S` to save
3. Type `docker ps` and press `Ctrl+S` to save
4. Use arrow keys to navigate, press `Enter` to fill terminal

## Requirements

- Ubuntu/Debian Linux
- bash shell
- Automatically installs dependencies

## Compatibility

- Works in bash and zsh terminals
- Tested on Ubuntu 20.04+

## Uninstall

```bash
sudo dpkg -r quickcommands
```

Your saved commands file (`~/.saved_commands`) will be preserved. To remove it:

```bash
rm ~/.saved_commands
```

## Author

**Arif Islam**  
Website: [arifislam.me](https://arifislam.me)  
GitHub: [@md-arif-islam](https://github.com/md-arif-islam)

## License

MIT License - see LICENSE file for details.

## Contributing

Pull requests welcome! Please ensure your code follows the existing style.
