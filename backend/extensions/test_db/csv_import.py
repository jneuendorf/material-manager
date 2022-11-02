import csv


def import_data():
    with open("extensions/test_db/Materialbestand_Jugend.csv") as csvdatei:
        csv_reader_object = csv.reader(csvdatei)

        data = []

        for row in csv_reader_object:
            # split_row = row.split(",")
            data += [row]
            # print(row)

        return data
