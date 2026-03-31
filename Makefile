# Compiler and flags
CC      = gcc
CFLAGS  = -Wall -Wextra -Iinclude -MMD -MP

# Directories
SRCDIR  = src
OBJDIR  = obj
BINDIR  = .

# Target binary
TARGET  = $(BINDIR)/hello

# Source and object files
SRCS    = $(wildcard $(SRCDIR)/*.c)
OBJS    = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

# Dependency files
DEPS    = $(OBJS:.o=.d)

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
	rm -f $(TARGET)

# Rebuild from scratch
re: fclean all

# Include auto-generated dependency files
-include $(DEPS)

.PHONY: all run clean fclean re
