# Material Manager

A manager for items used in mountain climbing.

This project contains the backend as well as the frontend part.
For more details for each part, see the according documentations:

- [backend documentation](./backend/README.md)
- [frontend documentation](./frontend/README.md)



## Deployment

Docker compose can be used for deployment.


### Prerequisites

#### 1. Create .env files

For configuring the backend and frontend,
we need 2 .env files - 1 in each (`backend` and `frontend/env`).

```shell
echo "CORE_PUBLIC_API_URL=http://my-awesome-server/api
CORE_PUBLIC_FRONTEND_URL=http://my-awesome-server
" > backend/.env

echo 'API_URL=/api' > frontend/env/.env
```

For more customization, see [config.py](backend/core/config.py).


### Deploy!

```shell
make run_docker
# docker-compose --file docker-compose.yml up --detach --build
```

Note that currently sample data is created.
Therefore, there will be a root user with the following credentials:

- Email: `root@localhost.com`
- Password: `root`


### URLs

After the container `frontend` has finished compiling Flutter and stopped running,
the following URLs can be accessed (assuming local deployment).

- Frontend: http://localhost
- API UI (Swagger): http://localhost:8000


## Authors and acknowledgment

Contributors to this project: See the [LICENSE](./LICENSE) file.

Thanks also to
- R.-Bodo Riediger-Klaus and Fynn Renner for providing development/test server
- Oliver Wiese for supporting us while development



## License

[MIT License](./LICENSE)
