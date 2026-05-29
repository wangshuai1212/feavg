program feavg
  use common
  implicit none

  character(len=10)  :: mode
  character(len=128) :: arg1, arg2
  integer :: nn_val

  nn_val = 100

  call get_command_argument(1, mode)
  if (len_trim(mode) == 0) then
    call print_usage()
    stop
  end if

  ! ===== help =====
  if (trim(mode) == "help") then
    call print_help()
    stop
  end if


    if (trim(mode) == "rd") then
    call get_command_argument(2, arg1)
    if (len_trim(arg1) /= 0) then
      read(arg1,*) nn_val
    end if
    call generate_random_init(nn_val)
    stop
  end if

  ! ===== plot =====
  if (trim(mode) == "plot") then
    call get_command_argument(2, arg1)
    if (len_trim(arg1) == 0) then
      print *, "ERROR: missing csv file"
      call print_usage()
      stop
    end if

    call get_command_argument(3, arg2)
    if (trim(arg2) == "--png") then
      call plot_csv_png(trim(arg1))
    else
      call plot_csv_x11(trim(arg1))
    end if
    stop
  end if

  ! ===== pe / ee =====
  call get_command_argument(2, arg2)
  if (len_trim(arg2) == 0) then
    call print_usage()
    stop
  end if

  call get_command_argument(3, arg1)
  if (len_trim(arg1) /= 0) then
    read(arg1,*) nn_val
  end if

  call set_outname(trim(arg2))
  call set_nn(nn_val)
  call count_vtk_files("feap.vtk.")
  call allocate_arrays()
  call init_common()

  if (trim(mode) == "pe") then
    call run_ep()
  else if (trim(mode) == "ee") then
    call run_ee()
  else
    print *, "ERROR: unknown mode"
    call print_usage()
    stop
  end if

contains

  subroutine print_usage()
    print *
    print *, "Usage:"
    print *, "  feavg <pe|ee> <output> [nn]"
    print *, "  feavg plot <csv> [--png]"
    print *, "  feavg help"
    print *
  end subroutine print_usage

  subroutine print_help()
    print *
    print *, "=============================================="
    print *, " FEAVG — FEAP VTK Post-Processing Tool"
    print *, "=============================================="
    print *
    print *, "Modes:"
    print *, "  pe        Extract polarization vs Efield"
    print *, "  ee        Extract strain vs Efield"
    print *, "  plot      Plot X-Y scatter / hysteresis curve"
    print *, "  help      Show this help message"
    print *
    print *, "Examples:"
    print *, "  feavg pe pe.csv 64"
    print *, "  feavg ee ee.csv 100"
    print *, "  feavg plot pe.csv"
    print *, "  feavg plot pe.csv --png"
    print *
    print *, "Notes:"
    print *, "  - nn: grid density (default = 100)"
    print *, "  - Output format: CSV (comma separated)"
    print *, "  - No header required in CSV files"
    print *, "  - Plot uses gnuplot (X11 or PNG)"
    print *
  end subroutine print_help

end program feavg