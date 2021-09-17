all: zzmon.hex loadngo.run

test: zzmon0.hex

# build release version
zzmon.rel: zzmon.mac
	zxcc zsm4 -"=zzmon/dtest=0/l"

zzmon.hex: zzmon.rel mkhex
	zxcc drlink -"zzmon.bin=zzmon[nr,lB200]"
	./mkhex -l 0xb200 -e 0xb400 zzmon.bin zzmon.hex

# build test version (loads at 0000h)
zzmon0.rel: zzmon.mac
	zxcc zsm4 -"=zzmon/dtest=1/l"

zzmon0.hex: zzmon0.rel mkhex
	zxcc drlink -"zzmon0.bin=zzmon[nr,l0]"
	./mkhex zzmon0.bin zzmon0.hex

# build serial bootstrap loader
loadngo.rel: loadngo.mac
	zxcc zsm4 -"=loadngo/l"

loadngo.bin: loadngo.rel
	zxcc drlink -"loadngo.bin=loadngo[nr,l0]"

loadngo.run: loadngo.bin zzmon.hex
	cat loadngo.bin zzmon.hex > loadngo.run

# build the bin to hex converter
mkhex: mkhex.c
	cc -o $@ $<

clean:
	rm -f mkhex *.rel *.prn *.bin *.hex *.run *~
