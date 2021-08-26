# web3.storage sql schema experiments

Experiments converting web3.storage fauna database into postgresql.

To set up a database locally, first create a new database:

```shell
createdb web3_storage
```

Then apply the schema to it:

```shell
psql -d web3_storage < schema.sql
```

To deploy to your existing heroku app with postgresql addon via the cli:

```shell
heroku pg:psql DATABASE < schema.sql
```

To set up a new heroku app run, hit the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This will create a new heroku project with postgresql addon and PostgREST configured.
