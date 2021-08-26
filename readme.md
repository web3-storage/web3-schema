# web3.storage sql schema experiments

Experiments converting web3.storage [fauna database schema](https://github.com/web3-storage/web3.storage/blob/main/packages/db/fauna/schema.graphql) into postgresql.

Schema design is based on [this](https://bafybeieevwz3ubli22dra5dnjp5w2gvuc54y6bpf67p3xikeracokttp2m.ipfs.dweb.link/web3.storage-schema.jpg) image, not exactly matching the current fauna schema.

[![faunadb schema](https://bafybeieevwz3ubli22dra5dnjp5w2gvuc54y6bpf67p3xikeracokttp2m.ipfs.dweb.link/web3.storage-schema.jpg)](https://bafybeieevwz3ubli22dra5dnjp5w2gvuc54y6bpf67p3xikeracokttp2m.ipfs.dweb.link/web3.storage-schema.jpg)

To set up a database locally, first create a new database:

```shell
createdb web3_storage
```

Then apply the schema to it:

```shell
psql -d web3_storage < schema.sql
```

<hr>

### Heroku and PostgREST

This repo also contains the config to deploy PostgREST to heroku on top of the new schema.

To deploy to your existing heroku app with postgresql addon via the cli:

```shell
heroku pg:psql DATABASE < schema.sql
```

To set up a new heroku app run, hit the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This will create a new heroku project with postgresql addon and PostgREST configured.
