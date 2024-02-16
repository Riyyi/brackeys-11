#!/bin/sh

convert $(find . -type f -name '*_Normal.png' ! -name "output*" -print | sort) -background none -alpha background -append output_normal.png
convert $(find . -type f -name '*.png' ! -name '*_Normal.png' ! -name "output*" -print | sort) -background none -alpha background -append output.png
