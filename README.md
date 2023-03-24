A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

ENCRYPTATION INSTALATION

POSTGRESQL 14

```bash
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

ELSE

```bash
$ sudo apt-get install libpq-dev postgresql-server-dev-<version> 
$ sudo apt-get install postgresql-<version>-bcrypt
```