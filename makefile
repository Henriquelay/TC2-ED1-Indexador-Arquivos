#	A Flag -c diz para gerar o arquivo de objeto, o -o $@ diz para colocar a saída da compilação no arquivo nomeado no lado esquerdo do :, o $< é o primeiro item na lista de dependências, e o A macro CFLAGS é definida como acima.
#	Como simplificação final, vamos usar as macros especiais $@ e $^, que são os lados esquerdo e direito de :, respectivamente, para tornar a regra geral de compilação mais geral. 
#	No exemplo abaixo, todos os arquivos de inclusão devem ser listados como parte da macro DEPS e todos os arquivos de objetos devem ser listados como parte da macro OBJ.

#Flags interessantes
#-Wall dispara todos os warnings em seu código
#-g necessário para avaliar o código do valgrind (permite o valgrind dizer em que linha dá merda)
#-lm obrigatorio caso utilize a biblioteca math.h

CC			=gcc
CFLAGS		=-Wall -g -lm -O3
DEPS		=lista.h arquivos.h ArvoreBinaria.h ArvoreAVL.h hash.h base.h trie.h
DEPSDIR		=headers
_DEPS		=$(patsubst %,${DEPSDIR}/%,${DEPS})
OBJDIR		=src

ARQUIVO		=data/APRENDE.txt
BUSCAS		=10
EXEC		=Lista

OBJLISTA	=arquivos.o testLista.o base.o lista.o
_OBJLISTA	=$(patsubst %,${OBJDIR}/%,${OBJLISTA})

OBJARVBIN	=arquivos.o testArvoreBinaria.o base.o ArvoreBinaria.o
_OBJARVBIN	=$(patsubst %,${OBJDIR}/%,${OBJARVBIN})

OBJARVAVL	=arquivos.o testArvoreAVL.o base.o ArvoreAVL.o
_OBJARVAVL	=$(patsubst %,${OBJDIR}/%,${OBJARVAVL})

OBJHASH		=arquivos.o testHash.o base.o ArvoreAVL.o hash.o
_OBJHASH	=$(patsubst %,${OBJDIR}/%,${OBJHASH})

OBJTRIE		=arquivos.o testTrie.o base.o trie.o
_OBJTRIE	=$(patsubst %,${OBJDIR}/%,${OBJTRIE})




${OBJDIR}/%.o: %.c ${_DEPS}
	${CC} -c -o $@ $< ${CFLAGS}

all: lista arvbin arvavl hash trie
	rm src/*.o

lista: ${_OBJLISTA} 
	${CC} -o Lista $^ ${CFLAGS}

arvbin: ${_OBJARVBIN} 
	${CC} -o ArvBin $^ ${CFLAGS}

arvavl: ${_OBJARVAVL} 
	${CC} -o ArvAVL $^ ${CFLAGS}

hash: ${_OBJHASH} 
	${CC} -o Hash $^ ${CFLAGS}

trie: ${_OBJTRIE} 
	${CC} -o Trie $^ ${CFLAGS}

valzin: 
	make all
	valgrind ./${EXEC} ${BUSCAS} ${ARQUIVO}

val:
	make all
	valgrind --leak-check=full ./${EXEC} ${BUSCAS} ${ARQUIVO} 

valzao:
	make all
	valgrind --leak-check=full --show-leak-kinds=all ./${EXEC} ${BUSCAS} ${ARQUIVO}

clear:
	rm -f *.o
	rm -f ${OBJDIR}/*.o
	rm -f ${EXEC}
	clear
	make
	rm -f *.o

push:
	gitPusher ${msg}
