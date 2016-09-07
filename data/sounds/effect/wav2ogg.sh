#!/bin/sh
for i in *.wav; do ffmpeg -i $i ${i%.wav}.ogg && rm $i; done

