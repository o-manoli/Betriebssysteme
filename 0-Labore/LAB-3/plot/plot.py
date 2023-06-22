r"""
   Plots Data it finds in 'Data.csv'

   Author: @O-Manoli, SS23

"""

import sys
import pandas
import numpy as np
from math import floor, log
from collections import defaultdict
from matplotlib import pyplot as plt

OutputFile = sys.argv[-1] if len(sys.argv) > 1 else 'benchmarks.png'

Scale = defaultdict(lambda : '')

Scale[1] = 'K'      # 1ooo**1
Scale[2] = 'M'      # 1ooo**2
Scale[3] = 'G'      # 1ooo**3
base = 10**3

def suffix(x)->str:
   x = int(x*10**6)
   p = floor(log(x, base))
   index = f"{x//base**p} {Scale[p]}B/s"
   return f"{index:^6}"

df = pandas.read_csv('Data.csv', index_col=0)

print("\n\tRead Data:\n")
print(df, end=2*'\n' + 24*'-' + 2*'\n')

Y = np.linspace(min(df.min()), max(df.max()), len(df.index))
YLabels = [*map(suffix, Y)]

X = [x for x in range(len(df.index))]

fig = df.plot(xticks=X, yticks=Y, style='o-').get_figure()

plt.xticks(rotation=45)

plt.yticks(Y, labels=YLabels)

print(f"Writing to {OutputFile}\n")

fig.savefig(OutputFile, dpi=600)

