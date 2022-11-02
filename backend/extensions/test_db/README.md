# Test Database

- use `make test_db` to create `test_db.db` file in instances folder and generate test data
- all data in test_db.db will be dropped before creating the test data

## material model

- mapping some of the database model columns with csv column index:
- MODEL_COLUMN = DATATYPE:CSV_INDEX

- everything else is filled with random date, float and int values

### material

MaterialID = int:zeilennummer
max life = int:12
max service: int:13
condition: string:18

### serialnumber

SerialNumber: string:11
manufactorer: string:5

### equipment-type

name = string:3

### property

description/name/unit = string:6

### purchase-details

### ???