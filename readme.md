# web3.storage sql schema experiments

Experiments converting web3.storage fauna database into postgresql.

To set up a database locally, first create a new database:

```
createdb web3_storage
```

Then apply the schema to it:

```
psql -d web3_storage < schema.sql
```

To deploy to your heroku app with postgresql addon via the cli:

```shell
heroku pg:psql --app app_name DATABASE < schema.sql
```
