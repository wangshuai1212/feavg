module common
  implicit none

  real(8), allocatable :: a(:), t(:), E(:)
  character(len=256)   :: line
  character(len=128)   :: outname

  real(8) :: f = 1d0
  real(8) :: Ampl = 6.0d0
  real(8) :: ts
  real(8) :: nn
  integer :: nfiles

contains

  subroutine set_nn(val)
  integer, intent(in) :: val
  nn = dble(val)
  end subroutine set_nn

  subroutine init_common()
    ts = 1.0d0 / f

    if (nn <= 0.0d0) then
    nn = 64.0d0
    end if
    
    nn = (nn + 1.0d0)**2
    call random_seed()
  end subroutine init_common

  subroutine set_outname(name)
    character(len=*), intent(in) :: name
    outname = trim(name)
  end subroutine set_outname

  subroutine count_vtk_files(prefix)
    character(len=*), intent(in) :: prefix
    character(len=256) :: fname
    integer :: i, iunit, ios
    logical :: exists

    print *, 'DEBUG prefix = "', trim(prefix), '"'

    nfiles = 0
    iunit = 10

    do i = 0, 9999999
      write(fname, '(A,I7.7)') trim(prefix), i
      inquire(file=fname, exist=exists)
      if (.not. exists) exit

      open(unit=iunit, file=fname, status='old', iostat=ios)
      if (ios /= 0) exit
      close(iunit)
      nfiles = nfiles + 1
    end do

    if (nfiles == 0) then
      print *, "ERROR: no vtk files found with prefix: ", trim(prefix)
      stop
    end if

    print *, "Found vtk files:", nfiles
  end subroutine count_vtk_files

  subroutine allocate_arrays()
    if (allocated(a)) deallocate(a)
    if (allocated(t)) deallocate(t)
    if (allocated(E)) deallocate(E)
    allocate(a(nfiles), t(nfiles), E(nfiles))
  end subroutine allocate_arrays


subroutine plot_csv_x11(filename)
  character(len=*), intent(in) :: filename
  character(len=512) :: cmd

  cmd = 'gnuplot -persist -e "' // &
        'set datafile separator '',''; ' // &
        'plot ''' // trim(filename) // ''' using 1:2 with linespoints pt 7 ps 0.5 notitle; ' // &
        'pause -1"'

  call system(trim(cmd))
end subroutine plot_csv_x11


subroutine plot_csv_png(filename)
  character(len=*), intent(in) :: filename
  character(len=512) :: cmd
  character(len=128) :: pngname

  pngname = trim(filename)
  if (index(pngname, '.csv') > 0) then
    pngname = pngname(1:index(pngname,'.csv')-1) // '.png'
  else
    pngname = trim(pngname) // '.png'
  end if

  cmd = 'gnuplot -e "' // &
        'set terminal pngcairo size 800,600; ' // &
        'set output ''' // trim(pngname) // '''; ' // &
        'set datafile separator '',''; ' // &
        'unset key; ' // &
        'plot ''' // trim(filename) // ''' using 1:2 with linespoints pt 7 ps 0.5"'

  call system(trim(cmd))
  print *, "Saved image: ", trim(pngname)
end subroutine plot_csv_png


subroutine generate_random_init(nn_in)
  implicit none
  integer, intent(in) :: nn_in

  integer :: N, num_nodes, i
  real(8) :: amp, u1, u2
  character(len=128) :: fname

  N = nn_in
  num_nodes = (N + 1) * (N + 1)
  amp = 0.3d0

  write(fname, '(A,I0,A)') 'rd', N, '.dat'

  open(unit=20, file=trim(fname), status='replace')
  do i = 1, num_nodes
    call random_number(u1)
    call random_number(u2)
    u1 = amp * (2.0d0 * u1 - 1.0d0)
    u2 = amp * (2.0d0 * u2 - 1.0d0)

    ! ✅ FEAP-safe format
    write(20, '(I6, I3, 2E14.6)') i, 0, u1, u2
  end do
  close(20)

  print *, "Generated FEAP initial file: ", trim(fname)
end subroutine generate_random_init


end module common