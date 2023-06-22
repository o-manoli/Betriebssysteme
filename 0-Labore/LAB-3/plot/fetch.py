r"""
   Reads data from any .txt it can find
   Tries to match the following RegEx patterns:
      (\d+\.\d+)\s*MB/s
      (\d+)\s*Bytes

   Author: @O-Manoli, SS23

"""

import re
import numpy as np
import pandas as pd
from glob import glob
from pathlib import Path
from math import log, floor
from typing import TextIO, Callable
from collections import defaultdict

Scale = defaultdict(lambda : '')

Scale[1] = 'K'      # 1ooo**1
Scale[2] = 'M'      # 1ooo**2
Scale[3] = 'G'      # 1ooo**3
BASE = 10**3

def suffix(x)->str:
   x = int(x)
   p = floor(log(x, BASE))
   index = f"{x//BASE**p} {Scale[p]}B"
   return f"{index:^6}"

Speed = re.compile(r"(\d+\.\d+)\s*MB/s", re.IGNORECASE)
Bytes = re.compile(r"(\d+)\s*Bytes", re.IGNORECASE)

def process(
   data:str,
   Format:Callable = lambda b, s: (int(b), float(s))
   )->tuple[int, float] | None:
   B = Bytes.findall(data)
   S = Speed.findall(data)
   if len(B):
      if len(S):
         return Format(B[-1], S[-1])
      return None
   return None

def fetch(f:TextIO)->pd.Series:
   Processed = [entry for entry in map(process, f.readlines()) if entry]
   Sorted = sorted(Processed, key=lambda r: r[0])
   Packaged = np.array(Sorted)
   Labeled = {suffix(label):value for label, value in Packaged}
   return pd.Series(Labeled)

def read(file:str) -> tuple[str, pd.Series]:
   with open(file) as f:
      label, data = Path(file).stem, fetch(f)
   return label, data

Files = glob("*.txt")

Data = {label:data for label, data in map(read, Files)}

print(Data)

df = pd.DataFrame.from_dict(Data)

print("\n\tWritten Data:\n")
print(df, end=2*'\n' + 24*'-' + 2*'\n')

df.to_csv("Data.csv")
