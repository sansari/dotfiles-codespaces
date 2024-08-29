# Dotfiles codespaces

This is an adaptation of [dotfiles-public
repo](https://github.com/vladistan/dotfiles-public) for use in
[development containers](https://containers.dev/) and [GitHub
CodeSpaces](https://github.com/features/codespaces).  It is based
on the original work of
[@dcreager](https://github.com/dcreager/dotfiles-public).

## Why is this needed?

[Dotfiles
repositories](https://github.com/search?q=topic%3Adotfiles&type=repositories)
enable developers to maintain consistent configurations across different machines they work
on.  These repositories contain configuration files for different tools,
allowing

Dotfiles repositories are super handy for developers. They keep
your setup consistent across different machines you are working
on. These repos save a ton of time setting up new systems. Plus,
you can keep track of changes with version control and easily share
your setup with your coworkers and friends.  Sharing your dotfiles
allows for mutual learning, as others can discover your clever
setups while you gain insights from the community's configurations.

Examples of configurable items:

- Shell settings (e.g., .zshrc)
- Editor settings (e.g., .vimrc)
- Git configurations (e.g., .gitconfig)
- Special tools (e.g., pv, fzf, etc.)
- Oh-my-zsh plugins and themes
- Timezones
- Shell aliases


Dotfiles are very useful for development containers and code spaces.
These setups are different from your local system,  thus they do not
share the same configuration files.  While containers and code spaces give you a
consistent base, dotfiles let you add your personal touch to these
shared environments. This is especially handy when you're working
with code spaces from repositories you don't own.

## How do dotfiles work in development containers and Codespaces?

<a name="dotfiles-in-containers"></a>

1. You configure your VSCode or GitHub with the dotfiles repository
to use.  Look at the links below for details:

  - [Personalizing GitHub Codespaces for your
  account](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles)

  - [Personalizing VSCode Dev containers with dotfile
  repositories](https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories)

2. Every time a new development container or codespace environment
is created, the dotfiles repository is automatically cloned into
the container. Then the repository install script is run
inside the container to set up everything.

## Should I use it?

This setup is useful if you have an existing dotfiles setup based
on the [dcreager dotfiles
manager](https://github.com/dcreager/dotfiles-base/) Such as one
of the ones below:

- [dcreager dotfiles-base](https://github.com/dcreager/dotfiles-public)
- [vladistan dotfiles-public](https://github.com/vladistan/dotfiles-public)
- [rouge8 dotfiles](https://github.com/rouge8/dotfiles)
- [cpaulik dotfiles](https://github.com/cpaulik/dotfiles)


For a new
setups I recommend using more modern tool  like
[chez-moi](https://www.chezmoi.io/) that has a DevContainer
[feature](https://github.com/rio/features/tree/main/src/chezmoi)

Alternatively, for a simpler container-only setup, you can refer
to the guide by Bea Stollnitz on [Codespaces Terminal
Setup](https://bea.stollnitz.com/blog/codespaces-terminal/).


## Why do you need a container-specific dotfiles repository?

Why not use your original dotfile repo? Dotfiles repos based on
dcreager's manager use multiple repositories: a generic manager and
custom dotfiles. The manager script is usually a clone of dcreager's
repo, while the dotfiles repo contains personalized configurations.

DevContainers and CodeSpaces, however, allow using only a single
repository for both the installation script and dotfiles. Additionally,
different tools and cloud environments clone the repo in various
locations, almost never into the home directory, which doesn't work
with dcreager's manager.

This container-specific dotfiles repo addresses both issues by
combining the management script and the dotfiles into a single
monorepo and being flexible with the location it's cloned into.

## How to Use It

1. [Fork](https://github.com/vladistan/dotfiles-codespaces/fork) the repo
2. Modify files in the [dotfiles folder](https://github.com/vladistan/dotfiles-codespaces/tree/main/dotfiles) according to your preferences
3. [Configure](#dotfiles-in-containers) your environment to use the repo
4. PROFIT!

## WARNING:

Dotfile repositories are public, so don't put any API keys, passwords,
or personal info in them. Use proper secret storage methods to
handle these things. This way, your sensitive info stays safe and
isn't exposed to unauthorized access. Always follow best practices
for managing secrets and credentials to keep your data and systems
secure.
