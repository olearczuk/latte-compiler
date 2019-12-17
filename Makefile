all:
	ghc --make Main.hs -o latc_x86
clean:
	-rm -f *.bak *.log *.hi *.o latc_x86 Grammar/*.hi Grammar/*.o Frontend/*.hi Frontend/*.o
