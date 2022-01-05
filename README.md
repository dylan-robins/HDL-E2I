# HDL - E2I

## What is this?

This is a repository containing all the HDL designs I’ve written for my VHDL and FPGA classes. It’s intended mainly as a backup in case anything happens to my computer, but if it’s useful to you that’s great.

## Tools used

- **GHDL** v1.0.0: HDL compiler/simulator
- **GTKWave** v3.3.104: waveform visualizer
- **python** v3.7-3.10.1: interpreter for custom build script

## Simulating the designs

The available testbenches are listed in the `test/` directory. You can compile and simulate them by running `./make.py <entity_name>`. This will compile the required files, elaborate the modules and run the simulation.

You can set the simulation length by setting `--stop_time <duration>` option, and using `--gui` will attempt to open the generated wave file in GTKWave.

## Authors

- Dylan Robins - https://github.com/dylan-robins
- Quentin Werlé

## License

This project is licensed under the WTFPL licence - see the [LICENSE](https://github.com/dylan-robins/HDL-E2I/blob/main/LICENCE) file for details.