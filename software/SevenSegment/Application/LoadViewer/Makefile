EXECUTABLE	= main

CC			= ${CROSS_COMPILE}gcc

SOURCES		= $(wildcard *.c)
BINS 		= $(SOURCES:.c=.o)

all: ${EXECUTABLE}

${EXECUTABLE}: ${BINS}
	${CC} ${CFLAGS} -march=${TYPE} -m${ARCH} -mfpu=${FPU} -mfloat-abi=${FLOAT_ABI} -mcpu=${CPU} --sysroot=${SYSROOT} $< -o $@

%.o: %.c
	${CC} ${CFLAGS} -march=${TYPE} -m${ARCH} -mfpu=${FPU} -mfloat-abi=${FLOAT_ABI} -mcpu=${CPU} --sysroot=${SYSROOT} -c $<

clean:
	rm *.o ${EXECUTABLE}
