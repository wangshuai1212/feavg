FC = gfortran
FFLAGS = -O3 -Wall

SRC = src
BIN = bin

TARGET = $(BIN)/feavg

SRCS = \
  $(SRC)/common.f90 \
  $(SRC)/grep_ep.f90 \
  $(SRC)/grep_ee.f90 \
  $(SRC)/main.f90

$(TARGET): $(SRCS)
	@mkdir -p $(BIN)
	$(FC) $(FFLAGS) -o $(TARGET) $(SRCS)

clean:
	rm -rf $(BIN) *.mod