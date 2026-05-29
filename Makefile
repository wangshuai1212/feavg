# ============================================
# FEAVG Makefile
# ============================================

FC      ?= gfortran
FFLAGS ?= -O3 -Wall -std=gnu

SRC      = src
BIN      = bin
TARGET   = $(BIN)/feavg

SRCS = \
  $(SRC)/common.f90 \
  $(SRC)/grep_ep.f90 \
  $(SRC)/grep_ee.f90 \
  $(SRC)/main.f90

OBJS = $(SRCS:.f90=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN)
	$(FC) $(FFLAGS) -o $@ $(OBJS)

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -rf $(BIN)
	find . -name "*.o" -delete
	find . -name "*.mod" -delete

install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

uninstall:
	rm -f /usr/local/bin/feavg