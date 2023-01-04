# User extension

## Data model

For details see [models.py](./models.py)


## Authentication

The authentication is done via JSON Web Tokens (JWT).
This way, we're bound to cookies so that browsers (web applications)
as well as native mobile apps can use the mechanisms for authentication.

The flow is as follows:
1. `POST /signup ==> {"access_token": "..."}` with the data for registration or
2. `POST /login ==> {"access_token": "..."}` with e-mail and password.

### Password hashing

We use `argon2` as it seems to be a good standard and an alternative to
`scrypt` which is computationally more expensive.

Like other password-hashing algorithms, the salt is part of the computed hash,
thus we do not need to store it in an extra column.


## API

`make run` and open http://localhost:5001/swagger-ui.



### Permissions

#### Superuser:
This is a special permission that always allows access
when using the `permissions_required` decorator.
#### User read
Allows reading any users data
#### User write
Allows writing any users data