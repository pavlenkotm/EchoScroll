CC = gcc
CFLAGS = -Wall -Wextra -O3 -std=c11
TARGET = keccak256
SRC = keccak256.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
