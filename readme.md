# web3.storage sql schema experiments

Experiments converting web3.storage fauna database into postgresql.

Deploy to an existing heroku app with postgresql addon via the cli:

```shell
heroku pg:psql --app app_name DATABASE < schema.sql
```
