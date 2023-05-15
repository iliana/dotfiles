# pylint: disable=missing-function-docstring,missing-module-docstring

import argparse
import csv
import sys


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("csvs", nargs="+")
    args = parser.parse_args()

    output = csv.DictWriter(
        sys.stdout, fieldnames=["txn_id", "date", "account", "description", "amount", "price"]
    )
    output.writeheader()

    for file in args.csvs:
        with open(file, encoding="ascii", newline="") as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                for output_row in process_row(row):
                    output.writerow(output_row)


def account(name):
    return f"stripe_split.{name}"


def process_row(row):
    if "created" in row:
        timestamp = row["created"]
        gross = account("income")
        net = account("balance")
    else:
        timestamp = row["effective_at"]
        gross = account("balance")
        net = account("payout")

    common = {
        "txn_id": row["balance_transaction_id"],
        "date": timestamp.split()[0],
        "description": row["description"],
        'price': 1,
    }

    yield {"account": net, "amount": row["net"], **common}
    if float(row["fee"]):
        yield {"account": account("fee"), "amount": row["fee"], **common}
    yield {"account": gross, "amount": "-" + row["gross"], **common}


if __name__ == "__main__":
    main()
