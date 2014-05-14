# Islo - Self-contained apps

Make apps completely self-contained by abstracting service process settings and execution.

## Quick, show me how to use my favorite daemon!

First, install Islo:

```
$ gem install islo
```

Then, a nice example might be worth a thousand words, so here goes:

### MySQL or MariaDB

```
$ islo mysql_install_db  # creates database in db/mysql
$ islo mysqld            # starts server without daemonizing[^1]
$ islo mysql             # connects to running server via unix socket in tmp/sockets
```

### Redis

```
$ islo redis-init        # creates directory in db/redis
$ islo redis-server      # starts server without daemonizing[^1]
$ islo redis-cli         # connects to server via unix socket in tmp/sockets
```

### PostgreSQL

```
$ islo initdb            # creates directory in db/postgres
$ islo postgres          # starts server without daemonizing[^1]
$ islo psql              # connects to server via unix socket in tmp/sockets
```

[^1]: Best used in a [Procfile](https://github.com/ddollar/foreman)

## What's more to know?

- Additional arguments are passed to the command.

  Run `islo --help` for details.

- Servers will listen only on unix sockets, TCP will be disabled.

  This saves headaches when you have to handle multiple projects, and thus
  conflicting ports. Also, it's too easy to forget not to listen for the world.

## My service is installed in a non-standard location/I want to use different versions in different projects

Configuration is a pending item, which will make locations selectable.

## I don't like how it assumes a Rails project layout

Configuration is a pending item, which will help set relevant paths.

## I've got a super service you don't seem to know about

Some configuration may help you soon. Also, contributions are welcome.

## I can't be bothered/always forget to type *islo* before my commands every single time!

Look soon enough under `support` for a few optional helpers for your favorite shell.

## I want to contribute. How?

Great! Write specs, have them all pass, respect rubocop, rebase on master and make your PR.

## License

MIT, see [LICENSE](LICENSE).
