# Test Database Usage

- use `make test_db` to create `test_db.db` file in instances folder and generate test data
- use `make run_test_data` to run test server with test data
- notice: all data in test_db.db will be dropped before creating the test data

# About the data

- mapping some of the database model columns with csv column index:

MaterialID = int:zeilennummer
max life = int:12
max service: int:13
manufactrer: string:5

- everything else is filled with random values
