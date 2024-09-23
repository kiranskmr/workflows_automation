# Filename: __main__.py
import sys, os

sys.path.append(os.path.join(os.path.dirname(__file__), "..", ".."))

from addcol import *

def main():
  print('Hello from my func')
  pass

if __name__ == "__main__":
  main()