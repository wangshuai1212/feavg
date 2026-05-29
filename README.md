# FEAVG — FEAP FE VTK Post-Processing Tool

Extract displacement / stress from FEAP ASCII VTK files  
and plot hysteresis curves.

## Build

```bash
make
```

Requires:
- `gfortran`
- `gnuplot` (for plotting)

## Usage

```bash
feavg ep ep.csv 100        # extract displacement
feavg ee ee.csv 100        # extract stress
feavg plot ep.csv          # interactive X11 plot
feavg plot ep.csv --png    # save ep.png
feavg help
```

## Input

- FEAP ASCII VTK (`feap.vtk.0000000`, ...)
- `nn` = grid division (default 100 → (nn+1)² nodes)

## Output

- CSV: `E, value`
- PNG: hysteresis curve (if `--png`)

## License

MIT
