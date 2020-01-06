all:
	cd src && ghc --make Main.hs -o ../latc_x86
clean:
	-rm -f *.bak *.log *.hi *.o latc_x86 src/Grammar/*.hi src/Grammar/*.o src/Frontend/*.hi src/Frontend/*.o src/Backend/*.hi src/Backend/*.o
