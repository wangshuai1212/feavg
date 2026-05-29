# FEAVG — FEAP FE VTK Post-Processing Tool

post-process packages for phase field ferroelectric  simulation including:

(1) generating Initial Condition for polarization in 2D
(2) Extract polarization / stain from FEAP ASCII VTK files  
(3) plot hysteresis curves

## Build

```bash
make
```

Requires:
- `gfortran`
- `gnuplot` (for plotting)

## Usage

```bash
feavg rd 100               #generating random numbers for polarization
feavg ep ep.csv 100        # extract polarization
feavg ee ee.csv 100        # extract strain
feavg plot ep.csv          # interactive X11 plot
feavg plot ep.csv --png    # save ep.png
feavg help
```

## Input

- FEAP ASCII VTK (`feap.vtk.0000000`, ...)
- `nn` = grid division (default 100 → (nn+1)² nodes)

## Output

- DAT:rdxx.dat  `n,0, rd1,rd2`
- CSV: `E, value`
- PNG: hysteresis curve (if `--png`)

## License

MIT
