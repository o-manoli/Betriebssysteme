# Plot Data

Just capture the output in a `txt` file

## Call

```bash
python3 main.py
```

Or one script at a time:

```bash
python3 fetch.py

python plot.py
```

The module `plot` depends on `fetch` to create the `Data.csv` file!

The `csv` file will be generated from the `txt` files via the python scripts

The name of the `txt` files shouldn't matter and will be used as column header in the DataFrame.

Any line with no matches will be ignored.

The order of doesn't lines matters!

## Secret Feature

```bash
python3 plot.py benchmark.pdf
```

After you've created the `Data.csv` file!
