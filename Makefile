# Compiler and flags
CC      = gcc
CFLAGS  = -Wall -Wextra -Iinclude -MMD -MP

# Directories
SRCDIR  = src
OBJDIR  = obj
BINDIR  = .
TESTDIR = tests

# Target binary
TARGET  = $(BINDIR)/hello

# Source and object files
SRCS    = $(wildcard $(SRCDIR)/*.c)
OBJS    = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

# Dependency files
DEPS    = $(OBJS:.o=.d)

# Test binary and sources
TEST_BIN    = $(TESTDIR)/test_hello
TEST_SRCS   = $(wildcard $(TESTDIR)/*.c)
TEST_OBJS   = $(patsubst $(TESTDIR)/%.c, $(OBJDIR)/%.o, $(TEST_SRCS))
# hello.c compiled without main for tests
LIB_OBJ     = $(OBJDIR)/hello.o

# Default target
all: $(TARGET)

# Link
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile
$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create obj directory if it doesn't exist
$(OBJDIR):
	mkdir -p $(OBJDIR)

# Run the program
run: $(TARGET)
	./$(TARGET)

# Remove object files
clean:
	rm -rf $(OBJDIR)

# Remove object files and binary
fclean: clean
	rm -f $(TARGET) $(TEST_BIN)

# Rebuild from scratch
re: fclean all

# Compile test object files
$(OBJDIR)/%.o: $(TESTDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Build and run tests
tests_run: $(LIB_OBJ) $(TEST_OBJS)
	$(CC) $(CFLAGS) -o $(TEST_BIN) $^
	./$(TEST_BIN)

# Include auto-generated dependency files
-include $(DEPS)

.PHONY: all run clean fclean re tests_run
